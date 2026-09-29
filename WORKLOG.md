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
