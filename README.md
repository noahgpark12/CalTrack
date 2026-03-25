# CalTrack (Native iOS + Supabase)

CalTrack is a native SwiftUI iOS app concept where you:

1. Take a photo of every meal/snack.
2. Send the photo to an AI nutrition scanner.
3. Save the nutrition snapshot to Supabase.
4. Track calories and daily value (DV) nutrient progress over time.
5. Receive push reminders so you do not forget to log food.

## What is included in this repo

- `CalTrackIOS/` SwiftUI app skeleton:
  - Authentication flow and tab layout.
  - Meal capture UI using photo picker.
  - Dashboard for calorie + nutrient progress.
  - Local notification reminder scheduling.
  - Service layer ready for Supabase integration.
- `supabase/schema.sql` Postgres schema + RLS policies.
- `supabase/functions/scan-meal/index.ts` Edge Function that calls OpenAI vision to estimate nutrition from meal photos.

## iOS architecture

- **Native app:** SwiftUI + Combine-style observable view models.
- **Backend:** Supabase Auth + Postgres + Storage + Edge Functions.
- **AI scan path:**
  - Upload photo to Storage.
  - Call edge function `scan-meal` with image URL.
  - Edge function calls OpenAI Responses API with image input.
  - Structured nutrition JSON is stored in `meal_entries.nutrition`.

## Supabase setup

1. Create a Supabase project.
2. Run SQL in `supabase/schema.sql`.
3. Create a private Storage bucket called `meal-photos`.
4. Deploy edge function:

   ```bash
   supabase functions deploy scan-meal
   ```

5. Set edge function secret:

   ```bash
   supabase secrets set OPENAI_API_KEY=your_key
   ```

## iOS app setup

1. Create an Xcode iOS App project named `CalTrackIOS`.
2. Copy files from `CalTrackIOS/` into your Xcode project.
3. Add dependencies (Swift Package Manager):
   - `supabase-swift` (https://github.com/supabase-community/supabase-swift)
4. Add environment/config values:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
5. Add iOS capabilities:
   - Push Notifications
   - Background Modes (remote notifications, if needed)
6. Add `NSPhotoLibraryUsageDescription` to `Info.plist`.

## Next implementation tasks

- Replace `SupabaseService` TODOs with real `supabase-swift` calls.
- Add camera capture (AVFoundation) in addition to photo picker.
- Add weekly/monthly trend charts.
- Add meal editing and manual overrides when AI estimate is off.
- Add onboarding for daily calorie/macro goals and nutrient targets.
