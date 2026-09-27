// Frozen scoring rules (see PLAN v3).
//
// Overall daily score (0-100):
//   0.40 * prayer + 0.30 * todo + 0.15 * screenTime + 0.15 * water
// Each section is normalized to 0-100 before weighting.
// Pomodoro completion points are tracked as Focus XP (shown separately,
// counted in lifetime XP) and do NOT affect the overall score.

abstract final class ScoreWeights {
  static const prayer = 0.40;
  static const todo = 0.30;
  static const screenTime = 0.15;
  static const water = 0.15;
}

abstract final class ScorePoints {
  // To-do
  static const todoCompleted = 10;
  static const todoStreakBonusPerDay = 2;
  static const todoStreakBonusCap = 20;
  static const todoDailyCap = 100;
  static const todoOverdueFactor = 0.5;

  // Prayer (fard)
  static const prayerOnTime = 15;
  static const prayerMosqueBonus = 5;
  static const prayerJamaatBonus = 3;
  static const prayerStreakBonusPerDay = 3;
  static const prayerStreakBonusCap = 30;

  // Extra ibadah
  static const tahajjud = 25;
  static const duha = 15;
  static const quranWaqiah = 20;
  static const quranMulk = 20;
  static const quranPage = 2;
  static const quranOtherCap = 20;
  static const adhkarEach = 10;
  static const dhikrDoneBase = 5;
  static const dhikrPerTen = 2;
  static const dhikrCap = 20;

  // Water
  static const waterGoalMet = 15;
  static const waterStreakBonusPerDay = 2;

  // Screen time
  static const screenTimeUnderLimit = 25;
  static const screenTimeStreakBonusPerDay = 5;

  // Pomodoro (Focus XP only, excluded from overall score)
  static const pomodoroSession = 20;
  static const pomodoroCycleBonus = 5;
}

abstract final class ScoreDefaults {
  static const waterGoalCups = 8;
  static const waterCupSizeMl = 250;
  static const waterWakeMinutes = 7 * 60; // 07:00
  static const waterSleepMinutes = 23 * 60; // 23:00
  static const waterReminderIntervalMinutes = 120;
  static const screenTimeDailyLimitMinutes = 180;
  static const todoTrashKeepDays = 7;
}
