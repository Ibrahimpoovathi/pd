import 'package:flutter/material.dart';

/// Bottom-sheet legend for the prayer tracker symbols.
/// Single place to document every emoji/badge used in the module.
class PrayerHelpSheet extends StatelessWidget {
  const PrayerHelpSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => const PrayerHelpSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What the symbols mean',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _row(context, '👥', "Jama'at",
                'Prayed together with the congregation.'),
            _row(context, '🕌', 'Mosque', 'Prayed inside the mosque.'),
            _badgeRow(
              context,
              'ad',
              Theme.of(context).colorScheme.primary,
              'Ada — prayed on time (default when you tick a prayer).',
            ),
            _badgeRow(
              context,
              'qd',
              Theme.of(context).colorScheme.tertiary,
              'Qada — made up after its time (half points). Tap the badge to switch.',
            ),
            const SizedBox(height: 12),
            Text(
              'Tap anywhere on a prayer row to mark it — no need to aim for the checkbox. '
              'A prayer unlocks only once its time starts; earlier taps tell you when it begins. '
              'Streak: only days where all five are Ada continue it; a miss or any Qada resets it to zero.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
      BuildContext context, String emoji, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$title — ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: detail),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeRow(
      BuildContext context, String text, Color color, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              detail,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
