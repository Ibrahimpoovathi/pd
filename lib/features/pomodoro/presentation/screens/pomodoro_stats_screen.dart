import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Statistics screen for Pomodoro: daily/weekly/monthly charts.
class PomodoroStatsScreen extends ConsumerWidget {
  const PomodoroStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(pomodoroStreakProvider);
    final totalFocus = ref.watch(totalFocusMinutesProvider);
    final completedSessions = ref.watch(completedSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Stats')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statCard(context, 'Current Streak', '${streak.value ?? 0} days',
              Icons.local_fire_department, Colors.orange),
          _statCard(context, 'Total Focus Time', _formatMinutes(totalFocus.value ?? 0),
              Icons.timer, Colors.blue),
          _statCard(context, 'Completed Sessions', '${completedSessions.value ?? 0}',
              Icons.check_circle, Colors.green),
          const SizedBox(height: 24),
          _sectionHeader(context, 'Last 30 Days Focus'),
          _FocusSparkline(),
          const SizedBox(height: 24),
          _sectionHeader(context, 'Recent Sessions'),
          _RecentSessionsList(),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes} min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }
}

/// Sparkline showing daily focus minutes for the last 30 days.
class _FocusSparkline extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This would need a provider that fetches daily focus minutes for last 30 days
    // For now, show a placeholder with the existing totalFocusMinutesProvider
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Focus Minutes (Last 30 Days)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: _buildSparklineChart(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparklineChart(BuildContext context, WidgetRef ref) {
    // Use monthRecordsProvider to get sessions for last 30 days
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    
    final monthData = ref.watch(monthRecordsProvider(monthStart));
    
    return monthData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (sessions) {
        // Aggregate by day
        final dailyFocus = <int, int>{};
        for (final session in sessions) {
          final dayKey = session.date.day;
          dailyFocus[dayKey] = (dailyFocus[dayKey] ?? 0) + (session.totalFocusMinutes ?? 0);
        }
        
        // Create spots for the last 30 days
        final spots = <FlSpot>[];
        final today = now.day;
        for (int i = 29; i >= 0; i--) {
          final day = today - i;
          final focus = dailyFocus[day] ?? 0;
          spots.add(FlSpot((29 - i).toDouble(), focus.toDouble()));
        }
        
        if (spots.every((s) => s.y == 0)) {
          return const Center(
            child: Text('No focus data yet', style: TextStyle(color: Colors.grey)),
          );
        }
        
        final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
        
        return LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value == 0 || value == maxY) {
                      return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                    }
                    return const Text('');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() % 5 == 0) {
                      return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 29,
            minY: 0,
            maxY: maxY > 0 ? maxY * 1.2 : 10,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Recent sessions list with real data.
class _RecentSessionsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    
    final monthData = ref.watch(monthRecordsProvider(monthStart));
    
    return monthData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e'))),
      data: (sessions) {
        if (sessions.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No sessions yet'),
            ),
          );
        }
        
        // Sort by date descending
        sessions.sort((a, b) => b.date.compareTo(a.date));
        
        return Card(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: sessions.take(10).map((session) {
              final date = session.date;
              final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
              final dateLabel = isToday 
                  ? 'Today' 
                  : (date.day == now.day - 1 && date.month == now.month && date.year == now.year)
                      ? 'Yesterday'
                      : '${date.day}/${date.month}';
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  child: Icon(Icons.timer, color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(
                  session.workMinutes > 0 ? 'Custom' : 'Session',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${session.workMinutes}/${session.shortBreakMinutes}/${session.longBreakMinutes} • ${session.completedWorkSessions ?? 0} sessions',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${session.totalFocusMinutes ?? 0} min',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
