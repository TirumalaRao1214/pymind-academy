import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/lessons_provider.dart';

class ContinueLearningCard extends ConsumerWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final cs = Theme.of(context).colorScheme;

    return progressAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final lastLessonId  = progress.lastLessonId;
        final lastSectionId = progress.lastSectionId;
        if (lastLessonId == null || lastSectionId == null) {
          return _WelcomeCard();
        }
        final lessonAsync = ref.watch(
            lessonProvider((lastSectionId, lastLessonId)));
        return lessonAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => _WelcomeCard(),
          data: (lesson) {
            if (lesson == null) return _WelcomeCard();
            return InkWell(
              onTap: () => context.go(
                  '/learn/$lastSectionId/$lastLessonId'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.play_arrow, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Continue Learning',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: cs.primary)),
                          const SizedBox(height: 2),
                          Text(lesson.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                          Text(lesson.level,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.waving_hand_outlined, color: cs.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome to PyMind Academy!',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
                Text('Start learning Python from the basics.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
