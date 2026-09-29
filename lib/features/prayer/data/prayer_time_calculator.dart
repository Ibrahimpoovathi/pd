import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';

/// Calculation methods offered in settings (key = stored value).
abstract final class PrayerMethods {
  static const entries = <String, String>{
    'muslim_world_league': 'Muslim World League',
    'north_america': 'ISNA (North America)',
    'egyptian': 'Egyptian Authority',
    'makkah': 'Umm al-Qura (Makkah)',
    'karachi': 'Karachi',
    'dubai': 'UAE / Gulf',
    'qatar': 'Qatar',
    'kuwait': 'Kuwait',
    'singapore': 'Singapore',
    'turkey': 'Turkey (Diyanet)',
    'tehran': 'Tehran',
  };

  static const defaultKey = 'muslim_world_league';

  static CalculationMethod resolve(String key) {
    switch (key) {
      case 'muslim_world_league':
        return CalculationMethod.muslim_world_league;
      case 'north_america':
        return CalculationMethod.north_america;
      case 'egyptian':
        return CalculationMethod.egyptian;
      case 'makkah':
        return CalculationMethod.umm_al_qura;
      case 'karachi':
        return CalculationMethod.karachi;
      case 'dubai':
        return CalculationMethod.dubai;
      case 'qatar':
        return CalculationMethod.qatar;
      case 'kuwait':
        return CalculationMethod.kuwait;
      case 'singapore':
        return CalculationMethod.singapore;
      case 'turkey':
        return CalculationMethod.turkey;
      case 'tehran':
        return CalculationMethod.tehran;
      default:
        return CalculationMethod.muslim_world_league;
    }
  }
}

abstract final class PrayerMadhabs {
  static const entries = <String, String>{
    'Shafi': 'Shafi',
    'Hanafi': 'Hanafi',
  };

  static const defaultKey = 'Shafi';

  static Madhab resolve(String key) =>
      key == 'Hanafi' ? Madhab.hanafi : Madhab.shafi;
}

/// Calculated prayer times for one day (local wall-clock times).
class DayPrayerTimes {
  final Map<PrayerName, DateTime> times;

  DayPrayerTimes(this.times);

  DateTime timeOf(PrayerName p) => times[p]!;
}

/// Thin wrapper around the `adhan` package. Applies manual per-prayer
/// minute offsets when [useManual] is true.
abstract final class PrayerTimeCalculator {
  static DayPrayerTimes calculate({
    required double latitude,
    required double longitude,
    required String methodKey,
    required String madhabKey,
    required DateTime date,
    bool useManual = false,
    Map<String, int> manualOffsets = const {},
  }) {
    final params = PrayerMethods.resolve(methodKey).getParameters()
      ..madhab = PrayerMadhabs.resolve(madhabKey);
    final times = PrayerTimes(
      Coordinates(latitude, longitude),
      DateComponents(date.year, date.month, date.day),
      params,
    );
    DateTime apply(PrayerName p, DateTime t) {
      if (!useManual) return t;
      return t.add(Duration(minutes: manualOffsets[p.label] ?? 0));
    }

    return DayPrayerTimes({
      PrayerName.fajr: apply(PrayerName.fajr, times.fajr),
      PrayerName.dhuhr: apply(PrayerName.dhuhr, times.dhuhr),
      PrayerName.asr: apply(PrayerName.asr, times.asr),
      PrayerName.maghrib: apply(PrayerName.maghrib, times.maghrib),
      PrayerName.isha: apply(PrayerName.isha, times.isha),
    });
  }

  /// Parses `{"Fajr": 2, "Isha": -3}` leniently; garbage returns {}.
  static Map<String, int> parseOffsets(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map) return {};
      return {
        for (final e in decoded.entries)
          if (e.value is int) e.key.toString(): e.value as int,
      };
    } catch (_) {
      return {};
    }
  }

  static String encodeOffsets(Map<String, int> offsets) =>
      jsonEncode(offsets);
}
