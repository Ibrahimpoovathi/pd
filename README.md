# PD — Personal Development App

An all-in-one personal development app for Android and iOS: to-dos, Muslim daily
tracker, water, pomodoro, screen-time control — unified by a cross-module scoring
system. Local-first and private by design: all data stays in on-device SQLite.

## Status

| Phase | Scope | Status |
|---|---|---|
| 1 | Foundation: scaffold, themes, DB schema, shell, docs | Done |
| 2 | To-Do (tabs, reminders, trash, auto-clear) | Done |
| 3 | Muslim tracker (prayer calc + override + reset, ibadah) | Done |
| 4 | Water tracker (ring, smart reminders, history) | Done |
| 5 | Pomodoro (dim circle, hidden time, background, chime) | Done |
| 6 | Screen time (usage tracking, limits, focus mode) | Planned |
| 7 | Scoring dashboard, export/import, polish | Planned |

## Tech stack

- **Flutter 3.47 / Dart 3.13** (installed at `~/flutter`)
- **State:** flutter_riverpod 3 · **Nav:** go_router · **DB:** drift (SQLite)
- **Notifications:** flutter_local_notifications + timezone (local, per-module channels)
- Prayer times: `adhan` (Phase 3) · Audio: `audioplayers` (Phase 5)
- Background pomodoro: `flutter_foreground_task` (Phase 5)

## Project structure

```
lib/
  main.dart                # bootstrap: prefs, DB, notifications, ProviderScope
  app/                     # PdApp, go_router config, shared providers
  core/
    constants/colors.dart  # GitHub Dark + Sepia Light palettes
    theme/                 # ThemeData builders, ThemeMode + module toggles
    storage/               # Drift database (all tables), SharedPreferences keys
    notifications/         # channels, init, permissions, cancellation
    widgets/               # ProgressRing (+ DimCircleTimer in Phase 5)
  features/
    home/ settings/        # Phase 1 screens
    todo/ prayer/ water/ pomodoro/ screen_time/ scoring/  # upcoming phases
```

## Themes

- **Dark — GitHub Dark:** bg `#0d1117`, surface `#161b22`, accent `#58a6ff`.
- **Light — Sepia:** bg `#fdf6e3`, surface `#f5ebe0`, dark-brown text `#3c3836`
  (low eye strain). Switchable System/Dark/Light in Settings.

## Scoring (frozen)

Overall daily score (0–100) =
`0.40·Prayer + 0.30·To-Do + 0.15·ScreenTime + 0.15·Water`
(sections normalized first). Prayer streak **resets** on a missed fard.
Pomodoro awards **Focus XP only on completed work sessions** — tracked
separately, excluded from the overall score. See
`lib/features/scoring/domain/score_constants.dart` for point values.

## Install on your phone

After every phase, a tested release APK is staged in `releases/`:

```
releases/pd-latest-release.apk          # always the newest build (grab this)
releases/pd-phase2-todo-debug.apk       # Phase 2: To-Do module
releases/pd-phase3-prayer-release.apk   # Phase 3: Muslim tracker + UX pack
releases/pd-phase4-water-release.apk    # Phase 4: Water tracker
releases/pd-phase5-pomodoro-release.apk # Phase 5: Pomodoro timer
```

1. Copy the APK to your phone (USB, file share, QR — any method).
2. Open it on the phone and allow **"Install unknown apps"** once when asked.
3. The app installs as **pd** with the dark monogram icon.
4. Switching from an older debug build to release: uninstall the debug app
   first (different signature; local data is wiped). Release-to-release
   upgrades keep your data.

## Development

```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # drift codegen
flutter analyze
flutter run
```

Key decisions and day-to-day progress are logged in [WORKLOG.md](WORKLOG.md).

## External releases (GitHub 100MB limit)

Release APKs are **not committed to git**. They live in a local staging folder:

```
/home/pseudo/Applications/OpenCode/pd-releases/
  pd-latest-release.apk          # symlink to newest
  pd-phase2-todo-debug.apk
  pd-phase3-prayer-release.apk
  pd-phase4-water-release.apk
  pd-phase5-pomodoro-release.apk
```

`.gitignore` excludes `releases/`. Git history was purged of APKs via
`git-filter-repo` (current `.git` ~776KB). Signing uses `~/.android/pd-release.keystore`
(outside repo) + `android/key.properties` (gitignored).

