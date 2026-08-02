import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/lessons_provider.dart';

class ProgressSummaryCard extends ConsumerWidget {
  const ProgressSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final sectionsAsync = ref.watch(sectionsProvider);
    final cs = Theme.of(context).colorScheme;

    return progressAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final completed = progress.completedCount;
        final streak    = progress.streak;
        final total = sectionsAsync.maybeWhen(
          data: (s) => s.fold<int>(0, (sum, sec) => sum + sec.lessonCount),
          orElse: () => 0,
        );
        final ratio = total > 0 ? completed / total : 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Progress',
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                  _StreakBadge(streak: streak),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: cs.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text('$completed / $total lessons completed',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        );
      },
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD29922).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD29922).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text('$streak day${streak == 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: const Color(0xFFD29922),
                    fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
