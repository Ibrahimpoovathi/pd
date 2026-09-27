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
