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
