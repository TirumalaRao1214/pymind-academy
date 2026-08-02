import 'package:flutter/material.dart';

class LessonSectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Color? color;

  const LessonSectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tileColor = color ?? cs.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: tileColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: tileColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
