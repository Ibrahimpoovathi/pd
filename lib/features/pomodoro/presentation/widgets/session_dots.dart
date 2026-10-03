import 'package:flutter/material.dart';

/// Session dots showing focus streak progress toward long break
/// (Stillness-inspired). Colors follow the app [ThemeData] so both
/// GitHub Dark and Sepia Light render correctly.
class SessionDots extends StatelessWidget {
  final int streak;
  final int total;

  const SessionDots({super.key, required this.streak, required this.total});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filled = total > 0 ? streak % total : 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < total; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled
                  ? scheme.primary.withValues(alpha: 0.9)
                  : scheme.onSurface.withValues(alpha: 0.14),
            ),
          ),
        if (streak > 0)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '$streak',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.4),
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }
}
