# Mekagna target-pitch update

## What changed

- Added a Mekagna tuner page to both student and mentor navigation. Mentor accounts can now open it from their own menu.
- Added kignet selection for Selamta, Tizita, Wanen, Sile Chernet, Ambasel, Nusus Wanen, and Bati.
- Added major/root selection from C through F-sharp.
- Shows target notes and reference frequencies for strings 1, 4, 6, 8, and 10.
- Lets the player select one string, hear its reference tone, and compare the microphone's detected pitch with that specific target (cents low/high/in tune).
- Bumped the app script URL and service-worker cache version to `v213` / `kfy-begena-v10` to avoid serving stale code in the installed PWA.

## C-major reference notes

| Kignet | String 1 | String 4 | String 6 | String 8 | String 10 |
|---|---|---|---|---|---|
| Selamta | F2 | C2 | D2 | A2 | G2 |
| Tizita | E2 | C2 | D2 | A2 | G2 |
| Wanen | E2 | C2 | D2 | A2 | G2 |
| Sile Chernet | F2 | C2 | C#2 | A2 | F#2 |
| Ambasel | F2 | C2 | C#2 | A2 | G2 |
| Nusus Wanen | D#2 | C2 | D2 | A2 | G2 |
| Bati | F2 | C2 | E2 | B2 | G2 |

These mappings are transcribed from the supplied reference app where available. Tizita remains as an additional preset using the mapping already present in this web app. Selecting a different major transposes all targets by the corresponding semitone offset. Reference frequencies use standard equal temperament.

## Deployment notes

The tuning configuration is local JavaScript, so no Supabase table/schema migration is required. The existing authentication/profile role determines which navigation menu is shown. Microphone pitch detection needs HTTPS (such as the deployed site) or localhost and the browser must be granted microphone permission.


## Real audio playback update

- Mekagna Play tone buttons now play the matching recording from `audio/begena/begena_audio/` rather than generating an oscillator tone.
- Example: F2 plays `bf2.ogg`; C2 plays `bc2.ogg`; C♯2 plays `bcs2.ogg`; F♯2 plays `bfs2.ogg`.
- Updated the app script query to `v214` and service-worker cache to `kfy-begena-v11`.
- Added all available shared reference recordings to the service-worker precache for offline playback.


## Persistent sign-in and creator credit update

- The authenticated app-session marker now uses persistent local storage, so closing and reopening the installed app does not ask for the password again. Users stay signed in on that device until they press Logout.
- Desktop and mobile Logout controls share the same cleanup flow, clear the saved app-session marker, locally sign out of Supabase, clear in-memory user state, and return to the login screen. Cached offline lesson data is retained, and offline students must still enter their password to sign in again after logging out.
- Startup can restore the matching student's cached offline session, or a minimal cached profile shell during offline startup. No password or Supabase token is stored in the new app-session metadata.
- Added a subtle “Made by Yonathan Mitiku” credit on the login screen, navigation areas, and app footer.
- Bumped the script to `v215`, stylesheet to `v203`, and service-worker cache to `kfy-begena-v12` for the installed PWA update.

## Local Mezmur list visibility / debugging update (2026-11-07)

- Added the HTML5 `<!DOCTYPE html>` declaration so browsers render in Standards Mode rather than Quirks Mode.
- Bumped the app shell cache to `kfy-begena-v15` and the asset URLs to `app.js?v=218` / `styles.css?v=205` so installed/local copies refresh the modified files.
- The mentor Mezmur list now displays the actual Supabase load error in the page instead of silently looking empty.
- Added a manual **Refresh list** action to the mentor Mezmur history.
- Mezmur create/update now asks Supabase to return the saved record, verifies that a row was returned, and shows an error rather than a success toast if saving fails or cannot be verified.
- No additional database migration is required for this update.
