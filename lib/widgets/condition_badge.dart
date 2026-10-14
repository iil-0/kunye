import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/book_condition.dart';

/// Kitabın durumunu üç noktayla gösterir: ●●● yeni gibi, ●●○ iyi, ●○○ yıpranmış.
class ConditionBadge extends StatelessWidget {
  const ConditionBadge({super.key, required this.condition, this.compact = false});

  final BookCondition condition;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: condition.label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 3; i++)
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i <= condition.level ? KunyeColors.gold : KunyeColors.border,
              ),
            ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              condition.label,
              style: const TextStyle(fontSize: 13, color: KunyeColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
