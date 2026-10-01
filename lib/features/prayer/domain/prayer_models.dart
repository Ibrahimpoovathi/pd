import 'package:pd/core/storage/database.dart';

/// The five daily fard prayers.
enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

extension PrayerNameX on PrayerName {
  String get label {
    switch (this) {
      case PrayerName.fajr:
        return 'Fajr';
      case PrayerName.dhuhr:
        return 'Dhuhr';
      case PrayerName.asr:
        return 'Asr';
      case PrayerName.maghrib:
        return 'Maghrib';
      case PrayerName.isha:
        return 'Isha';
    }
  }

  /// Stable notification id for this prayer (5001-5005).
  int get notificationId => 5001 + index;

  static PrayerName? fromPayload(String? payload) {
    if (payload == null || !payload.startsWith('prayer:')) return null;
    final name = payload.substring('prayer:'.length).toLowerCase();
    for (final p in PrayerName.values) {
      if (p.name == name) return p;
    }
    return null;
  }
}

extension PrayerRecordX on PrayerRecord {
  bool prayed(PrayerName p) {
    switch (p) {
      case PrayerName.fajr:
        return fajr;
      case PrayerName.dhuhr:
        return dhuhr;
      case PrayerName.asr:
        return asr;
      case PrayerName.maghrib:
        return maghrib;
      case PrayerName.isha:
        return isha;
    }
  }

  bool jamaat(PrayerName p) {
    switch (p) {
      case PrayerName.fajr:
        return fajrJamaat;
      case PrayerName.dhuhr:
        return dhuhrJamaat;
      case PrayerName.asr:
        return asrJamaat;
      case PrayerName.maghrib:
        return maghribJamaat;
      case PrayerName.isha:
        return ishaJamaat;
    }
  }

  bool mosque(PrayerName p) {
    switch (p) {
      case PrayerName.fajr:
        return fajrMosque;
      case PrayerName.dhuhr:
        return dhuhrMosque;
      case PrayerName.asr:
        return asrMosque;
      case PrayerName.maghrib:
        return maghribMosque;
      case PrayerName.isha:
        return ishaMosque;
    }
  }

  /// Made up after its time (qada) rather than on time (ada).
  bool qada(PrayerName p) {
    switch (p) {
      case PrayerName.fajr:
        return fajrQada;
      case PrayerName.dhuhr:
        return dhuhrQada;
      case PrayerName.asr:
        return asrQada;
      case PrayerName.maghrib:
        return maghribQada;
      case PrayerName.isha:
        return ishaQada;
    }
  }

  /// True when all five fard prayers are marked.
  bool get allFardDone =>
      fajr && dhuhr && asr && maghrib && isha;

  /// True when all five were prayed on time (no qada). Only all-ada days
  /// continue the streak.
  bool get allAdaDone =>
      allFardDone &&
      !fajrQada &&
      !dhuhrQada &&
      !asrQada &&
      !maghribQada &&
      !ishaQada;
}
