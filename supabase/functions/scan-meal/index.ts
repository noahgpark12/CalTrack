import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

interface ScanPayload {
  image_url: string;
  meal_type: "breakfast" | "lunch" | "dinner" | "snack";
  notes?: string;
}

serve(async (req: Request): Promise<Response> => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  const { image_url, meal_type, notes = "" } = (await req.json()) as ScanPayload;

  const openAIKey = Deno.env.get("OPENAI_API_KEY");
  if (!openAIKey) {
    return Response.json({ error: "Missing OPENAI_API_KEY" }, { status: 500 });
  }

  const prompt = [
    "You are a nutrition assistant.",
    "Given a meal photo, estimate foods + macronutrients + major micronutrients.",
    "Return strict JSON with keys: calories, proteinGrams, carbsGrams, fatGrams, fiberGrams, sodiumMilligrams, micronutrients[].",
    `Meal type: ${meal_type}`,
    `Notes: ${notes}`
  ].join("\n");

  const aiResponse = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${openAIKey}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      model: "gpt-4.1-mini",
      input: [
        {
          role: "user",
          content: [
            { type: "input_text", text: prompt },
            { type: "input_image", image_url }
          ]
        }
      ],
      text: {
        format: {
          type: "json_schema",
          name: "nutrition",
          schema: {
            type: "object",
            properties: {
              calories: { type: "number" },
              proteinGrams: { type: "number" },
              carbsGrams: { type: "number" },
              fatGrams: { type: "number" },
              fiberGrams: { type: "number" },
              sodiumMilligrams: { type: "number" },
              micronutrients: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    name: { type: "string" },
                    amount: { type: "number" },
                    unit: { type: "string" },
                    dailyValuePercent: { type: "number" }
                  },
                  required: ["name", "amount", "unit", "dailyValuePercent"],
                  additionalProperties: false
                }
              }
            },
            required: ["calories", "proteinGrams", "carbsGrams", "fatGrams", "fiberGrams", "sodiumMilligrams", "micronutrients"],
            additionalProperties: false
          }
        }
      }
    })
  });

  if (!aiResponse.ok) {
    const err = await aiResponse.text();
    return Response.json({ error: err }, { status: 500 });
  }

  const data = await aiResponse.json();
  const payload = data.output?.[0]?.content?.[0]?.text;

  if (!payload) {
    return Response.json({ error: "No model output" }, { status: 500 });
  }

  return new Response(payload, {
    headers: { "Content-Type": "application/json" },
    status: 200
  });
});
