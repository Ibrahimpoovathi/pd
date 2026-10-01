import 'package:flutter_test/flutter_test.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';

void main() {
  group('PrayerMethods', () {
    test('resolves known keys, defaults unknown', () {
      expect(
        PrayerMethods.resolve('makkah').toString(),
        contains('umm_al_qura'),
      );
      expect(
        PrayerMethods.resolve('nope').toString(),
        contains('muslim_world_league'),
      );
      expect(PrayerMethods.entries.length, greaterThan(8));
    });
  });

  group('PrayerMadhabs', () {
    test('hanafi vs shafi default', () {
      expect(PrayerMadhabs.resolve('Hanafi').toString(), contains('hanafi'));
      expect(PrayerMadhabs.resolve('Shafi').toString(), contains('shafi'));
      expect(PrayerMadhabs.resolve('??').toString(), contains('shafi'));
    });
  });

  group('PrayerTimeCalculator', () {
    // Makkah, fixed date: times must order correctly in any timezone.
    DayPrayerTimes makkah() => PrayerTimeCalculator.calculate(
          latitude: 21.4225,
          longitude: 39.8262,
          methodKey: 'makkah',
          madhabKey: 'Shafi',
          date: DateTime(2026, 1, 15),
        );

    test('times are ordered fajr < dhuhr < asr < maghrib < isha', () {
      final t = makkah();
      final ordered = PrayerName.values.map(t.timeOf).toList();
      for (var i = 0; i < ordered.length - 1; i++) {
        expect(ordered[i].isBefore(ordered[i + 1]), isTrue,
            reason: '${PrayerName.values[i]} should precede '
                '${PrayerName.values[i + 1]}');
      }
    });

    test('madhab changes asr time', () {
      PrayerTimeCalculator.calculate(
        latitude: 21.4225,
        longitude: 39.8262,
        methodKey: 'makkah',
        madhabKey: 'Shafi',
        date: DateTime(2026, 1, 15),
      );
      final shafi = makkah().timeOf(PrayerName.asr);
      final hanafi = PrayerTimeCalculator.calculate(
        latitude: 21.4225,
        longitude: 39.8262,
        methodKey: 'makkah',
        madhabKey: 'Hanafi',
        date: DateTime(2026, 1, 15),
      ).timeOf(PrayerName.asr);
      // Hanafi Asr is later than Shafi Asr.
      expect(hanafi.isAfter(shafi), isTrue);
    });

    test('manual offsets shift exact minutes', () {
      final base = makkah().timeOf(PrayerName.fajr);
      final shifted = PrayerTimeCalculator.calculate(
        latitude: 21.4225,
        longitude: 39.8262,
        methodKey: 'makkah',
        madhabKey: 'Shafi',
        date: DateTime(2026, 1, 15),
        useManual: true,
        manualOffsets: const {'Fajr': 7, 'Isha': -3},
      );
      expect(
        shifted.timeOf(PrayerName.fajr).difference(base).inMinutes,
        7,
      );
      expect(
        shifted.timeOf(PrayerName.dhuhr),
        makkah().timeOf(PrayerName.dhuhr),
      );
    });

    test('offsets ignored unless useManual', () {
      final withOffsets = PrayerTimeCalculator.calculate(
        latitude: 21.4225,
        longitude: 39.8262,
        methodKey: 'makkah',
        madhabKey: 'Shafi',
        date: DateTime(2026, 1, 15),
        useManual: false,
        manualOffsets: const {'Fajr': 60},
      );
      expect(withOffsets.timeOf(PrayerName.fajr),
          makkah().timeOf(PrayerName.fajr));
    });

    test('parseOffsets is lenient', () {
      expect(
        PrayerTimeCalculator.parseOffsets('{"Fajr": 2, "Isha": -3}'),
        {'Fajr': 2, 'Isha': -3},
      );
      expect(PrayerTimeCalculator.parseOffsets('garbage'), isEmpty);
      expect(PrayerTimeCalculator.parseOffsets('{"Fajr": "x"}'), isEmpty);
      expect(PrayerTimeCalculator.parseOffsets('[]'), isEmpty);
    });
  });

  group('prayerStarted', () {
    test('before/at/after/null', () {
      final t = DateTime(2026, 5, 1, 12, 0);
      expect(prayerStarted(t.subtract(const Duration(minutes: 1)), t),
          isFalse);
      expect(prayerStarted(t, t), isTrue);
      expect(
          prayerStarted(t.add(const Duration(minutes: 1)), t), isTrue);
      expect(prayerStarted(t, null), isTrue);
    });
  });

  group('PrayerNameX', () {
    test('payload round-trip + notification ids unique', () {
      final ids = PrayerName.values.map((p) => p.notificationId).toSet();
      expect(ids.length, PrayerName.values.length);
      expect(
        PrayerNameX.fromPayload('prayer:maghrib'),
        PrayerName.maghrib,
      );
      expect(PrayerNameX.fromPayload('todo:3'), isNull);
      expect(PrayerNameX.fromPayload(null), isNull);
    });
  });
}
