/// Date-only helpers shared across features.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool isToday(DateTime d, [DateTime? now]) => isSameDay(d, now ?? DateTime.now());

bool isTomorrow(DateTime d, [DateTime? now]) {
  final n = now ?? DateTime.now();
  return isSameDay(d, n.add(const Duration(days: 1)));
}

/// Minutes since midnight, e.g. 10:00 -> 600.
int timeToMinutes(int hour, int minute) => hour * 60 + minute;

String formatMinutes(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  final period = h >= 12 ? 'PM' : 'AM';
  final h12 = h % 12 == 0 ? 12 : h % 12;
  return '$h12:${m.toString().padLeft(2, '0')} $period';
}
