# Koye Feche Yohanis Begena

Koye Feche Yohanis is a Begena-learning web app for students and mentors. This bundle contains the app source, its offline-ready service worker, audio files, and the November 7, 2026 feature upgrade.

## Run locally on Windows

1. Install Python if it is not already installed.
2. Open PowerShell in this folder.
3. Run:

   ```powershell
   python -m http.server 3000
   ```

4. Open `http://localhost:3000` in Firefox or Chrome.

Use the deployed HTTPS site or localhost for features that require a secure browser context, such as microphone permissions and installable PWA behavior. Sign in with an existing student or mentor account to see the matching role-based pages.

## What is included in this upgrade

- **Mentor notices:** a mentor can issue a reminder, warning, or serious warning to a student, edit it, resolve/reopen it, or delete it. The student sees their own notices in a dedicated page and an active-notice indicator on the dashboard.
- **Begena practice:** choose one of seven kignets and a major/root from C through F-sharp. The five main string positions are displayed and played in left-hand order, with a landscape/full-screen practice layout. Each string shows its calculated note and plays the matching local recording.
- **Mezmur library:** every Mezmur record has its own optional YouTube link. When mentors add or edit any Mezmur, they can paste its matching video URL; the student page loads and embeds the URL saved on that selected record. Mentors can see whether each Mezmur has a video, and edit or delete earlier entries. The supplied “ሰላም ለማርያም” link remains attached to that record as the example already provided.
- **Mentor content management:** existing assignments, announcements, and lessons have edit/delete actions in their history lists. Assignment deletion can be blocked by existing student submissions; lesson deletion can be blocked by existing references or progress records.
- **PWA refresh:** the script, stylesheet, manifest, and service-worker cache versions have been updated so installed copies request the refreshed app shell.

## Begena note example

The selected tuning is calculated from the kignet interval map and the selected root. For **Selamta + D major**, the expected targets are:

| String | Target |
|---:|:---|
| 1 | G2 |
| 4 | D2 |
| 6 | E2 |
| 8 | B2 |
| 10 | A2 |

The audio recordings are loaded from `audio/begena/begena_audio/`. The service worker precaches the note recordings required by the available kignet/major combinations.

## Supabase database

The connected Supabase project is `koye-feche-yohanis-begena`. The database upgrade has already been applied to the connected project. The SQL is also included in `DATABASE_UPGRADE.sql` for a reproducible setup or review. It adds the optional `mezmur.youtube_url` field and the `student_warnings` table with row-level security. The separate `SECURITY_HARDENING.sql` records the API permission changes and the class-membership guard on the leaderboard RPC.

Mentors can create/update/delete notices only in a class they are assigned to. Students can read only notices addressed to their own account. No warning is created automatically; a mentor must explicitly issue it. Legacy public execution was removed from unused account-promotion, trigger, and student-lookup helpers. The leaderboard RPC now checks that the caller is enrolled in the requested class or is staff assigned to it. The allowed student-class and denied unrelated-class cases were checked against Supabase.

## Notes and limitations

- YouTube playback is embedded in the app. Playback still requires internet access, and YouTube may block embedding for videos whose owner has disabled it.
- Browser/device fullscreen and orientation-lock support varies. On devices that reject orientation lock, rotate the device manually after entering landscape practice.
- This bundle has been syntax-checked and its tuning/audio file coverage has been checked. The Supabase table policies and leaderboard class gate were verified with database queries. A complete live sign-in walkthrough on physical devices and a hosting deployment were not performed as part of this file update.
- Supabase still reports that leaked-password protection is disabled. A project owner should enable it in the Supabase Auth password-security settings. Three authenticated-only `SECURITY DEFINER` helpers remain because the current row policies and class-scoped leaderboard depend on them; they no longer have anonymous execution access.
- Do not commit service-role credentials or other private keys to the browser bundle. Use the project's intended public client configuration and Supabase row-level security.

## Version markers

- `app.js?v=217`
- `styles.css?v=204`
- Service-worker cache: `kfy-begena-v14`
