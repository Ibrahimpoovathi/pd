import 'package:drift/drift.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';

/// Defaults for a fresh prayer-settings row.
abstract final class PrayerSettingsDefaults {
  static const method = PrayerMethods.defaultKey;
  static const madhab = PrayerMadhabs.defaultKey;
}

/// Daily prayer records + the singleton settings row.
class PrayerRepository {
  final AppDatabase _db;

  PrayerRepository(this._db);

  // -- Records -------------------------------------------------------------

  Future<PrayerRecord> getOrCreateToday([DateTime? now]) async {
    final day = dateOnly(now ?? DateTime.now());
    final existing = await (_db.select(_db.prayerRecords)
          ..where((t) => t.date.equals(day)))
        .getSingleOrNull();
    if (existing != null) return existing;
    final id = await _db.into(_db.prayerRecords).insert(
          PrayerRecordsCompanion.insert(date: day),
        );
    return (_db.select(_db.prayerRecords)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Stream<PrayerRecord?> watchToday([DateTime? now]) {
    final day = dateOnly(now ?? DateTime.now());
    return (_db.select(_db.prayerRecords)..where((t) => t.date.equals(day)))
        .watchSingleOrNull();
  }

  /// Watches today, creating the row on first subscribe.
  Stream<PrayerRecord?> watchTodayEnsured([DateTime? now]) async* {
    await getOrCreateToday(now);
    yield* watchToday(now);
  }

  Future<PrayerRecord?> recordOn(DateTime day) {
    return (_db.select(_db.prayerRecords)
          ..where((t) => t.date.equals(dateOnly(day))))
        .getSingleOrNull();
  }

  /// Writes the given fields for [id] (only non-absent values change).
  Future<void> updateRecord(int id, PrayerRecordsCompanion entry) {
    return (_db.update(_db.prayerRecords)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(updatedAt: Value(DateTime.now())));
  }

  /// Consecutive all-ada days strictly before [today].
  /// A miss or any qada breaks the chain, so the streak resets to 0.
  Future<int> fardStreak(DateTime today) async {
    final day = dateOnly(today);
    final rows = await (_db.select(_db.prayerRecords)
          ..where((t) => t.date.isSmallerThanValue(day))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(366))
        .get();
    var streak = 0;
    var cursor = day.subtract(const Duration(days: 1));
    for (final r in rows) {
      if (!isSameDay(r.date, cursor)) break;
      if (!r.allAdaDone) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // -- Settings ------------------------------------------------------------

  Future<PrayerSetting> getSettings() async {
    final existing =
        await (_db.select(_db.prayerSettings)..limit(1)).getSingleOrNull();
    if (existing != null) return existing;
    final id = await _db.into(_db.prayerSettings).insert(
          PrayerSettingsCompanion.insert(),
        );
    return (_db.select(_db.prayerSettings)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Stream<PrayerSetting> watchSettings() async* {
    await getSettings(); // ensure the singleton row exists
    yield* (_db.select(_db.prayerSettings)..limit(1))
        .watch()
        .map((rows) => rows.first);
  }

  Future<void> updateSettings(PrayerSettingsCompanion entry) async {
    final current = await getSettings();
    await (_db.update(_db.prayerSettings)
          ..where((t) => t.id.equals(current.id)))
        .write(entry);
  }

  /// "Reset to App Default": drop manual overrides, keep method/madhab.
  Future<void> resetManual() async {
    final current = await getSettings();
    await (_db.update(_db.prayerSettings)
          ..where((t) => t.id.equals(current.id)))
        .write(const PrayerSettingsCompanion(
          useManual: Value(false),
          manualOffsetsJson: Value('{}'),
        ));
  }
}
