# CalTrack (Native iOS + Supabase)

CalTrack is a native SwiftUI iOS app where you:

1. Take a photo of each meal/snack.
2. AI estimates calories + nutrients.
3. Data is saved to Supabase.
4. You track calories and daily-value progress over time.
5. Push notifications remind you to stay consistent.

## Design direction

The app UI now follows a modern wellness look:
- soft gray background,
- rounded white cards,
- green gradient hero + CTA buttons,
- metrics-forward dashboard cards.

## Included in this repo

- `CalTrackIOS/` SwiftUI app scaffold with styled screens:
  - Auth (`AuthView`)
  - Meal scanner (`MealCaptureView`)
  - Trends dashboard (`DashboardView`)
  - Notification/settings profile (`SettingsView`)
- `supabase/schema.sql` Postgres tables + RLS.
- `supabase/functions/scan-meal/index.ts` edge function for AI scan.
- `.env` template for Supabase/OpenAI keys.

## Environment variables (`.env`)

Create/update `.env` in repo root:

```bash
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
OPENAI_API_KEY=your_openai_api_key
```

## Supabase setup

1. Create a Supabase project.
2. Run SQL in `supabase/schema.sql`.
3. Create private Storage bucket `meal-photos`.
4. Deploy edge function:

   ```bash
   supabase functions deploy scan-meal
   ```

5. Set secret for the edge function:

   ```bash
   supabase secrets set OPENAI_API_KEY=your_key
   ```

## iOS app wiring

1. Create/open your Xcode iOS app target.
2. Copy `CalTrackIOS/` files into the target.
3. Add Swift package dependency:
   - `supabase-swift` (`https://github.com/supabase-community/supabase-swift`)
4. Wire TODOs in `SupabaseService` to real auth/storage/functions/database calls.
5. Add capabilities:
   - Push Notifications
   - Photo library usage permission
