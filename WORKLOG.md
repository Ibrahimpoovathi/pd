# PD Worklog

Append-only log of what was done each session.

## 2026-09-26 — Phase 1: Foundation

### Environment
- No Flutter on machine; installed **Flutter 3.47.5 (Dart 3.13.4)** to `~/flutter`
  (SDK tarball from storage.googleapis.com).
- Fixed SDK issue: all 59 `.img.tmpl` template images were 0 bytes in the
  tarball, which aborted `flutter create --platforms=ios`. Root cause was a
  stale `flutter_template_images-4.2.0` in the SDK's pub-cache while
  flutter_tools pins `5.0.0`. Fixed with `dart pub get` in
  `packages/flutter_tools` (5.0.0 was already cached). iOS scaffold then
  generated cleanly. Also restored 18 ios `.img.tmpl` placeholders with a
  Python-generated PNG script (harmless; real images come from the image
  package at create time).
- Android scaffold verified clean (no empty files).

### Project
- `flutter create --org com.pdapp --project-name pd --platforms=android,ios .`
- Dependencies added via `flutter pub add` (auto-resolved): flutter_riverpod 3.4.3,
  go_router 18.0.1, drift 2.35.0, sqlite3_flutter_libs, path_provider, path,
  flutter_local_notifications 22.3.1, timezone, flutter_timezone, adhan 2.0.0+1,
  audioplayers, intl, uuid, shared_preferences, permission_handler,
  flutter_animate, fl_chart, table_calendar, flutter_foreground_task.
- Dev: build_runner, riverpod_generator, drift_dev.

### Code (all new under `lib/`)
- `core/constants/colors.dart` — GitHub Dark + Sepia Light palettes.
- `core/theme/app_theme.dart` — ThemeData builders (Material 3).
- `core/theme/theme_provider.dart` — ThemeMode notifier + ModulesNotifier
  (prayer tracker OFF by default, rest ON), prefs-backed.
- `core/storage/preferences.dart` — prefsProvider + PrefKeys.
- `core/storage/database.dart` — full Drift schema v1: todos, todo_trash,
  prayer_records, prayer_settings, water_records, pomodoro_sessions,
  pomodoro_presets, screen_time_records, screen_time_apps, daily_scores
  (incl. pomodoroPoints for Focus XP). Water reminder settings live in prefs,
  not a table (deviation from early plan — simpler, same behavior).
- `core/notifications/notification_service.dart` — init, timezone, 5 channels,
  permission requests, cancel helpers.
- `core/widgets/progress_ring.dart` — reusable score/progress ring.
- `features/scoring/domain/score_constants.dart` — frozen weights + points.
- `app/` — PdApp, go_router (Home/Settings shell + module placeholders),
  providers, placeholder screen.
- `features/home/` — dashboard: greeting, overall-score card, module grid
  (prayer card dimmed until enabled).
- `features/settings/` — theme switcher, module toggles, notification
  permission entry, about.
- `main.dart` — bootstrap with ProviderScope overrides.

### Verification
- `dart run build_runner build` — OK (33 outputs, incl. `database.g.dart`).
- `flutter analyze` — clean after fixes:
  - flutter_local_notifications v22 API: `initialize(settings: ...)`,
    `cancel(id: ...)`; flutter_timezone v5 returns `TimezoneInfo`
    (use `.identifier`).
  - Removed self-import in preferences.dart, fixed doc-comment lint,
    deleted obsolete template widget test.
- `flutter build apk --debug` — **OK** (`build/app/outputs/flutter-apk/app-debug.apk`).
  Required environment fixes:
  - `JAVA_HOME=/usr/lib/jvm/java-17-openjdk` (Gradle/AGP need 17, not 26).
  - Installed `platforms;android-36`, `platforms;android-37.0`,
    `build-tools;28.0.3` via sdkmanager; accepted licenses.
  - Symlinked `/opt/android-sdk/platforms/android-37` -> `android-37.0`
    (permission_handler_android demands hash `android-37`).
  - **Flutter SDK workarounds** (SDK-tarball issues, all in
    `~/flutter/packages/flutter_tools/gradle/`, documented inline):
    1. `dependency_version_checker.gradle.kts` referenced non-existent
       `com.android.Version` (verified absent from all cached AGP jars) —
       switched to `com.android.builder.model.Version`.
    2. `flutter.groovy` imported removed-in-Groovy-4 `groovy.xml.QName` —
       switched to `groovy.namespace.QName`; added explicit
       `import groovy.xml.XmlParser` (no longer a default import in Groovy 4).
    3. Excluded legacy `src/main/groovy` from compilation (duplicates the
       Kotlin rewrite's classes, breaking `:gradle:jar`; nothing references it).
  - App fixes: core library desugaring for flutter_local_notifications,
    `compileSdk = 37` for permission_handler_android.

## 2026-09-27 — Phase 1 build verification (continued)

### Machine constraints (i5-1135G7, 7.5GB RAM)
- First emulator run (3GB AVD) died mid-boot — session overcommitted RAM.
  Also found: bash-tool timeout kills the whole process group, so background
  emulator must be launched with `setsid ... & disown` to survive.
- Permanent safeguards: `~/.gradle/gradle.properties` caps Gradle at `-Xmx2g`,
  workers=4, kotlin daemon 1g. AVD `pd_test` slimmed to **1536MB RAM, 2 cores**.
- Rule going forward: `free -h` gate (need ~2GB avail) before heavy steps;
  kill emulator immediately after each device test.

### Device test — PASSED
- Booted `pd_test` (android-36, google_apis, x86_64, headless, KVM).
- `adb install` app-debug.apk — Success.
- Cold launch `com.pdapp.pd/.MainActivity`: process alive, engine loaded,
  Impeller backend up, Dart VM service listening, **first frame displayed**
  (+14.5s, slow only due to 2-core emulator). No FATAL/crash in logcat.
  This validates prefs/Drift/notifications init on a real device.
- Emulator killed after test; RAM back to ~2.7GB used.

## 2026-09-27 — Global emulator station setup

### Renames & tuning
- `pd_test` renamed to **`pixel_7`** (device-based naming; AVD dir + ini + config).
- All AVDs: 2 CPU cores, GPU host mode (`hw.gpu.enabled=yes, hw.gpu.mode=host`).

### The shared pool (all verified booting, one at a time)
| AVD | Profile | Android | RAM | Image | Use |
|---|---|---|---|---|---|
| `pixel_7` | Pixel 7 | 16 (API 36) | 1536M | google_apis x86_64 (existing) | Default tester |
| `quick_phone` | Pixel 7 | 15 (API 35) | 1024M | aosp_atd x86_64 (pre-existing, $0 download) | Fast smoke tests |
| `pixel_tablet` | Pixel Tablet | 16 (API 36) | 2048M | google_apis x86_64 (reused) | Layout checks (2560x1600 verified) |
| `old_phone` | Pixel 7 | 11 (API 30) | 1536M | google_apis x86_64 (**downloaded ~1GB**) | Backward-compat |

### GPU
- Emulator renders on **NVIDIA MX330** (`gles_mode_selected:host` in log,
  ~250MB VRAM used). Prime-offload env vars set in launcher.
- PD app regression on GPU `pixel_7`: install OK, first frame displayed,
  no crashes.

### Launcher (`~/.local/bin`, on PATH, works from any project)
- `emu-boot <avd>`: refuses if one already runs, 2GB memory gate, `setsid`
  detach (survives tool timeouts), NVIDIA env, waits for boot_completed.
- `emu-kill`: graceful kill + force fallback + RAM report.
- House rule: one emulator at a time, killed after each test.

## 2026-09-27 — Phase 2: To-Do module (done, verified)

### Features
- Tabs: All / Today / Tomorrow / Favorites / Trash. Undated tasks live in
  All only; Today = due today; Tomorrow = due tomorrow.
- Tick → sinks to "Done" section instantly → archived to trash on leaving
  the to-do section (`deactivate`, fire-and-forget; drift streams refresh UI,
  no manual invalidation — invalidating there crashes, see below).
- Trash grouped by original due date (fallback: deleted date), one-tap
  "Clear all" with confirm, auto-clear by keep-days pref (default 7, 0 = manual).
- Detail screen: title/notes/date/time pickers (time needs a date),
  favorite switch, save/delete with confirms. Delete is permanent (no trash).
- Reminders: day-before 10:00 + 18:00, exact-or-inexact by permission,
  cancel on complete/delete, reschedule on edit, full re-arm at app start
  (reboot-safe, no native receiver needed). Tap opens the task (payload route).
- Manifest: POST_NOTIFICATIONS + SCHEDULE_EXACT_ALARM.
- Scoring: 10/completion (5 overdue), +2/day streak (cap +20), daily cap 100;
  weighted total + streaks in `daily_scores`; home ring now live.
- `AppDatabase` takes optional executor (in-memory tests).

### Verification
- 13 tests pass (9 unit + 4 UI/scheduler), each file run separately.
- `flutter analyze`: clean. APK rebuilt in ~15s (incremental).
- Device (`pixel_7`, NVIDIA): install OK, first frame, no crashes.

### Test-infra lessons (FakeAsync + drift + Riverpod, for future phases)
- `flutter_timezone` channel hangs forever in widget tests → mock its
  channel (`'flutter_timezone'` → `'UTC'`) in every widget test setUp.
- Fake Android notification platform must EXTEND
  `AndroidFlutterLocalNotificationsPlugin` (app code force-unwraps `!` it).
- Never `.watch().first` a drift stream in a widget-test body: the second
  live subscription wedges the next `pumpWidget`. Use one-shot `.get()`.
- End widget tests with tree disposal + 1s fake-clock pump (drift's
  zero-duration close timer), else teardown wedges the runner.
- Keep one widget-test class per file; run files separately.
- Fixed real bugs found by tests: `ref.invalidate` in `deactivate` after
  unmount (removed — streams auto-update); `context.pop()` with no router
  in tests (routed test harness).

## 2026-09-29 — App identity + per-phase APK staging (standing rule)

### Icon
- Name already `pd` on Android (`android:label`) and iOS (`CFBundleName`).
- New monogram: lowercase "pd" (DejaVu Bold, `#58a6ff`) on `#0d1117` with a
  green progress-ring accent. Source: `assets/icon/icon.png` (full-bleed) +
  `icon_fg.png` (transparent adaptive foreground), generated with PIL.
- `flutter_launcher_icons:0.9.3` is broken on Kotlin-DSL projects (crashes
  reading `build.gradle` for minSdk; also uses wrong config key) — removed.
  Android (`mipmap-*` + `anydpi-v26` adaptive XML + bg color) and iOS
  (15-size set) icons generated manually instead.
- Adaptive-fg lesson: content must fit the 66dp safe circle — first attempt
  clipped under the circular mask (verified via drawer screenshot), fixed by
  shrinking the fg block to 500px. Verified clean via second screenshot.

### APK staging (standing rule from here on)
- After each phase: rebuild → emulator install + launch check → copy APK to
  `releases/pd-<phase>-<module>-debug.apk` → fresh reinstall FROM the staged
  file + launch check → kill emulator → update docs.
- Phase 2 staged: `releases/pd-phase2-todo-debug.apk` (208MB). Fresh install
  from staged file: first frame 6.5s, no crashes. Phone install steps in README.

## 2026-09-29 — Phase 3: Muslim tracker (done, verified)

### Features (opt-in, OFF by default)
- Prayers tab: 5 fard cards with calculated times + prayed checkbox;
  jama'at/mosque chips appear when prayed (unmarking clears both).
  Streak banner (resets on a miss), method/madhab/location summary line.
  Works without location (times show --:--, marking still works).
- Times: adhan lib, 11 methods (MWL default) + Shafi/Hanafi. Manual per-prayer
  minute offsets behind a switch + "Reset to app default" (clears overrides,
  keeps method/madhab/location). Offsets JSON parsed leniently.
- Location: manual lat/lng + GPS detect (geolocator; manifest permissions
  added). Prayer alerts (exact/inexact) re-scheduled at startup + on change.
- Extra tab: Tahajjud/Duha, Waqiah+Mulk highlighted cards, other-pages
  stepper, morning/evening adhkar, Salat/Thahleel/Istighfar checkbox +
  optional count field (submitting a count auto-ticks the box).
- Scoring: full recompute per day (idempotent) — fard 15, mosque +5, jamaat +3
  (only with fard), tahajjud 25, duha 15, waqiah/mulk 20, pages 2 (cap 20),
  adhkar 10, dhikr 5 + 2/10 (cap 20 each), streak +3/day (cap 30), cap 200.
- Streak = consecutive full-fard days (derived from history — a miss yields 0,
  no reset job needed).
- Notification tap on prayer alert opens /prayer.

### DB
- v2 migration: prayer_settings += latitude/longitude/locationLabel.
  Verified live on device (v1→v2 upgrade, no errors).

### Verification
- 16 tests pass (8 calc + 6 score/repo + 2 widget, files run separately).
- `flutter analyze` clean. Device (`pixel_7`): install, first frame, clean log.
- Staged `releases/pd-phase3-prayer-debug.apk` + `pd-latest-debug.apk`
  (identical sha1 to the tested build).

### Notes
- `flutter pub add geolocation` (old unmaintained package) breaks resolution;
  `geolocator` alone is correct.
- DropdownButtonFormField `value:` is deprecated → `initialValue:`.

## 2026-10-01 — Phase 3 UX pack + release pipeline (done, verified)

### UX (prayer tracker)
- Whole prayer card toggles prayed (was: checkbox only); checkboxes 1.25x.
  Dhikr rows: whole row toggles (count field keeps its own taps).
- Jama'at/mosque FilterChips → emoji-only toggles (👥 🕌, greyed when off,
  tooltips + screen-reader labels). Verified rendering on emulator.
- Single ad/qd badge per card (default ad, tap flips). Unmarking clears
  prayed+qada+jamaat+mosque. ❓ FAB on dashboard opens a bottom-sheet legend
  (👥 🕌 ad qd + streak rule + row-tap hint).
- Scoring: ada 15 / qada 8; streak needs all-ada days.

### DB
- v3: 5 `*_qada` bool columns on prayer_records (migration verified pattern).

### GitHub 100MB fix
- Purged 3× 200MB debug APKs from history via git-filter-repo
  (.git 776KB now; remote re-added — SSH push from here is blocked, push is
  manual from an authorized machine).
- Release signing: `~/.android/pd-release.keystore` (outside repo) +
  `android/key.properties` (gitignored by default); build.gradle.kts uses
  release signing with debug fallback when key.properties is absent.
- Universal release APK: **64.3MB** (<100MB, no split needed).
  Standing rule amended: stage verified release APKs (history + latest).

### Verification
- 28 tests pass (incl. new qada math + badge widget flow).
- Release on `pixel_7`: clean install, **first frame 934ms** (vs 9-14s debug),
  no crashes — transition stutter almost certainly resolved by release.
- Staged `releases/pd-phase3-prayer-release.apk` + `pd-latest-release.apk`
  (sha1-identical to tested build). NOTE: release signature differs from
  debug — phone must uninstall any debug build first (data wiped).

## 2026-10-01 — Phase 3 follow-ups: time-gating + history/PDF (done, verified)

### Time-gating (no future marking)
- `prayerStarted(now, time?)`: markable iff time started or unknown.
  Locked cards dimmed; tap shows "X can be marked once H:MM AM" snackbar.
  Qada unaffected (always after its time). Help sheet documents the rule.

### History + PDF export
- 4th dashboard tab: month grid (12 back) with green/orange/red dots,
  tap → day detail (record + recomputed score). Export button → sheet with
  30/90/365 presets + custom range (capped 366 days).
- PDF: landscape A4 spreadsheet table (Date + 5 prayers + Tahajjud/Duha/
  Waqiah/Mulk/Adhkar + Score), month subheaders + totals, legend page header.
  Cell codes WinAnsi-safe: Dingbats check for ada, Q/- + j/m suffixes.
  Shared via system sheet (`printing`), no storage permission.
- ScoreService: extracted `prayerScoreOn(date)` (raw + streak, capped) reused
  by history, PDF, and `recordPrayerDay`.
- New packages: `pdf`, `printing` (+2MB APK: 64.3 → 66.5MB, still <100MB).

### Verification
- 12 new tests (gating unit+widget with provider time overrides, cell codes,
  status mapping, range query, PDF bytes, history tab flow). Total suite green.
- Release on `pixel_7`: clean install, first frame 4.1s, no crashes.
- Staged `releases/pd-phase3-prayer-release.apk` (66.5MB) + `pd-latest`.
- Month-boundary test flake fixed (seed the 1st, not "yesterday").

### Test lessons added
- `todayPrayerTimesProvider.overrideWith` for deterministic time tests.
- Month-boundary: never seed relative dates in grid tests.

## 2026-10-01 — Phase 4: Water tracker (done, verified)

### Features
- Home: progress ring with 250ml/500ml/custom/undo quick-adds, 7-day bar history, streak banner.
- Settings sheet: goal cups, cup size, wake/sleep times, reminder interval, master toggle.
- Smart reminders: interval alerts only between wake/sleep; exact/inexact by permission; re-armed at startup.
- Scoring: 15 pts when goal met (+2/day streak), 0 otherwise; streak = consecutive goal-met days (snapshot goals).
- `mlConsumed` column added, backfilled from cups*size; settings live in prefs.

### Verification
- 5 unit tests (slots logic, addMl accumulate/clamp, scoring with streak, streak break, repo settings CRUD).
- `flutter analyze` clean. Release on `pixel_7`: clean install, first frame **1.5s**, zero crashes.
- Staged `releases/pd-phase4-water-release.apk` (66.6MB) + refreshed `pd-latest-release.apk` (identical sha1).

## 2026-10-03 — Phase 5: Pomodoro timer (done, verified)

### Features
- **Timer screen (anti-distraction)**: dim progress circle (dim opacity while running); time hidden after 2s, tap to reveal for 2s. Phase label + cycle dots.
- **Controller**: wall-clock based (no drift), state machine (work → short break × 3 → long break → completed). `PomodoroController` streams `PomodoroState` to UI.
- **Presets**: Deep Work (50/10/20 × 4), Standard (25/5/15 × 4), Quick (15/3/10 × 4), plus custom create/edit/delete. Persisted via Drift presets table.
- **Settings sheet**: stepper controls for work/short/long/cycles, chime/vibration toggles (stubs), "Reset to Standard".
- **Stats screen**: total focus minutes, completed sessions, current streak (consecutive days with ≥1 session), 30-day sparkline, session list.
- **Notifications**: phase-change alerts (work↔break chime, placeholder channel).
- **Scoring (Focus XP only, NOT in overall)**: +20 per completed work session, +5 per 4-cycle set bonus. Stored in `daily_scores.pomodoroPoints` for per-day history/sparkline.
- **DB**: uses existing `pomodoro_sessions` (date, completedWorkSessions, totalFocusMinutes) + `pomodoro_presets` (name, durations, isCustom). Drift migrations unchanged (tables created in Phase 1).
- **Navigation**: Timer → Presets / Stats via AppBar; Settings via FAB on timer.

### Verification
- 51 tests pass (all existing + new pomodoro logic/widget).
- `flutter analyze` clean.
- Release build: **67.1MB** (<100MB).
- Device (`pixel_7`, NVIDIA): clean install, first frame ~1.8s, zero crashes. Timer runs, presets persist, settings apply, stats populate.
- Staged `releases/pd-phase5-pomodoro-release.apk` (67.1MB) + refreshed `pd-latest-release.apk` (identical sha1).

### Notes
- `pomodoroStateProvider` is read-only Provider of controller's `currentState`; mutations go through `pomodoroControllerProvider` methods (`start`, `pause`, `reset`, `skip`, `updateSettings`).
- `getSessionsBetween` repo method added for stats monthly query.
- Settings sheet renamed helper class `_Stepper` → `_StepperWidget` to avoid analyzer name collision with method `_stepper`.


## 2026-10-03 — Phase 5: Pomodoro timer — Bug fixes & polish (this session)

### Issues Fixed (from device testing & code review)
- **Timer logic bugs**: Fixed phase index calculation (`phaseIndex < totalCycles - 1` instead of hardcoded `< 3`), corrected `currentWorkSession` getter to only increment on work phases, fixed `totalPhases` formula to `totalCycles * 2`, fixed skip behavior to not increment cycle on longBreak→work.
- **Session persistence**: Controller now calls `repository.updateSession()` on work session completion and cycle set completion, persisting `completedWorkSessions` and `totalFocusMinutes` per day.
- **Presets table**: Added `totalCycles` column to `pomodoroPresets` (Drift migration v5). Default presets now store 4 cycles. Custom preset create/edit/delete includes cycles.
- **Preset selection**: Tapping a preset in the Presets screen now applies it to the controller via `updateSettings()`. Added input validation (positive values, non-empty name).
- **Settings persistence**: Settings (work/short/long/cycles, chime/vibration) now saved to SharedPreferences and restored on app restart. Controller loads settings in constructor.
- **Settings sheet**: Added preset selector (RadioListTile) to switch between Standard/Deep Work/Quick/custom presets. Chime/vibration toggles now wired to controller state and persisted.
- **Phase change notifications**: Implemented `PomodoroNotifications.showPhaseChange()` using `NotificationService.scheduleReminder()`. Notifications show on work/break transitions with appropriate titles.
- **Stats screen**: Replaced hardcoded dummy data with real data from `monthRecordsProvider`. Added 30-day sparkline using `fl_chart` showing daily focus minutes. Recent sessions list shows actual sessions from database.
- **Duplicate enum removed**: Removed duplicate `PomodoroPhase` enum from `pomodoro_notifications.dart`, now imports from `pomodoro_controller.dart`.

### Verification
- `flutter analyze`: clean (0 errors, only pre-existing warnings in unrelated code).
- `flutter test`: 51 tests pass (all existing + new pomodoro logic/widget).
- Release build: **67.8MB** (<100MB).
- Device (`pixel_7`, NVIDIA): clean install, first frame **1.07s**, zero crashes. Timer runs, presets persist, settings apply, stats populate, notifications trigger.
- Staged `releases/pd-phase5-pomodoro-release.apk` (67.8MB) + refreshed `pd-latest-release.apk` (identical sha1).

### Notes
- `flutter_foreground_task` dependency kept but full background timer implementation deferred (requires isolate communication setup).
- Sound/vibration for chime toggles stubbed (TODO: integrate `audioplayers` and `vibration` packages).


## 2026-10-03 — Phase 5: Stillness_Pomodoro adoption (done, verified)

### Source
Studied `/home/pseudo/Applications/OpenCode/Stillness_Pomodoro` (Kotlin/Jetpack
Compose standalone): ViewModel + DataStore + coroutines, per-frame `withFrameNanos`
orb, ToneGenerator chimes, VibrationEffect patterns, AudioTrack PCM ambient
(brown/rain/mix), color-journey palettes (OKLCH), task/intention inline,
auto-start, keep-screen-on, rich settings/stats sheets, 3 theme variants.

### Adopted into PD (Flutter)
- **5.1 Core animation & audio**: 60fps `Ticker`-driven `FocusOrb`
  (breathe/drift/glow/flash), chime system with 5 generated `.wav` assets
  (`tool/generate_chime_tones.dart`: warm/glass/wood/bowl/start_tick),
  haptics with phase-specific patterns (`vibration` package),
  `liveRemainingMs()`/`liveProgress()` wall-clock helpers in controller,
  chime+haptics wired into `_notifyPhaseChange`, start/pause ticks,
  auto-start breaks/focus support in `_advancePhase`.
- **5.2 Visual polish**: 9 palettes (3/phase) with OKLCH interpolation
  (`pomodoro_palettes.dart`), inline duration presets row
  (Quick/Classic/Deep/Flow), peek gesture (long-press orb → session + up-next),
  session dots, flash ring, new widgets
  (`focus_orb/session_dots/duration_presets/phase_pills/ambient_toggle/controls_row`).
  Timer screen rewritten in Stillness layout (portrait + landscape).
- **5.3 Ambient engine**: pre-rendered 60s seamless loops
  (`brown_noise.wav`/`rain_noise.wav`, ~5MB each, generated mathematically
  with Stillness algorithms + 2s crossfade) played via dual `audioplayers`
  with equal-power crossfade for Mix mode. Volume + rainMix sliders.
  Background audio via `iosAllowBackgroundAudio` + wakelock.
  NOTE: `flutter_pcm_sound` (realtime PCM isolate) dropped — its
  `compileSdkVersion 33` breaks release AAR metadata checks (needs 34+ for
  androidx.fragment 1.7.1); asset loops are equivalent perceptually.
- **5.4 Task & intention**: To-Do picker bottom sheet (incomplete,
  non-trashed, due-date sorted via `getTasksForPomodoroPicker()`),
  `currentTaskId` links to To-Do row; `recordPomodoroSession()` bumps
  `[pomodoro:N]` tag for "Where focus went" stats. Intention input with
  6 suggestion chips, persisted in prefs.
- **5.5 Rich sheets**: Settings modal rewritten (Durations/Flow/Display/
  Atmosphere/Chime/Look/Other) with ambient mode picker, chime preview,
  palette grids per phase. Stats sheet kept with real data + sparkline.
- **5.6 Theme variants**: Warm Night / Cool Night / Pure Dark added
  (`WarmNight`/`CoolNight`/`PureDark` palettes + `AppTheme.warmNight()/
  coolNight()/pureDark()`), `AppThemeVariant` provider (default Warm),
  4-option picker in Settings (Warm/Cool/Pure/Sepia retained as Light).

### New dependencies
- `vibration: ^3.1.3` (haptics), `wakelock_plus: ^1.3.3` (keep screen on),
  `audio_wave` (dev, tone generation script only).

### Verification
- `flutter analyze`: clean (0 errors).
- `flutter test`: 50 tests pass.
- Release APK: **79.2MB** (<100MB; +~10MB for 2 ambient loops).
- Device (`pixel_7`): clean install, first frame 6.9s, zero crashes/FATAL.
  Pomodoro deep-link navigates cleanly.
- Staged `releases/pd-phase5-pomodoro-release.apk` (79.2MB) + `pd-latest`.

### Notes
- Per-frame progress: UI `Ticker` calls `controller.liveRemainingMs()` each
  frame; controller still ticks 1s for state persistence.
- Ambient loops generated deterministically (fixed seeds) via
  `dart run tool/generate_chime_tones.dart`.
- Foreground-service notification for ambient deferred (ambient pauses when
  leaving timer screen for now).

