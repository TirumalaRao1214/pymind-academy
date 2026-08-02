import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lessons_provider.dart';
import '../../providers/progress_provider.dart';

class LessonListScreen extends ConsumerWidget {
  final String sectionId;
  const LessonListScreen({super.key, required this.sectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsForSectionProvider(sectionId));
    final progressAsync = ref.watch(progressProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(sectionId
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isEmpty
                ? w
                : w[0].toUpperCase() + w.substring(1))
            .join(' ')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/learn'),
        ),
      ),
      body: lessonsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Failed to load lessons: $e')),
        data: (lessons) {
          if (lessons.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 48, color: cs.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('No lessons found',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            );
          }
          final progress = progressAsync.valueOrNull;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final lesson = lessons[i];
              final isComplete =
                  progress?.isCompleted(lesson.id) ?? false;
              final bestScore = progress?.bestScore(lesson.id) ?? 0;
              final totalQ =
                  progress?.totalQuestions(lesson.id) ?? 0;

              return InkWell(
                onTap: () => context.go(
                    '/learn/$sectionId/${lesson.id}'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isComplete
                          ? cs.primary.withOpacity(0.4)
                          : cs.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isComplete
                              ? cs.primary.withOpacity(0.15)
                              : cs.outline.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isComplete
                              ? Icons.check
                              : Icons.circle_outlined,
                          size: 16,
                          color: isComplete
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${i + 1}. ${lesson.title}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isComplete
                                        ? cs.primary
                                        : cs.onSurface,
                                  ),
                            ),
                            if (totalQ > 0) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Quiz: $bestScore/$totalQ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: cs.onSurfaceVariant),
                              ),
                            ],
                          ],
                        ),
                      ),
                      _LevelChip(level: lesson.level),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 18, color: cs.onSurfaceVariant),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String level;
  const _LevelChip({required this.level});

  Color get _color {
    switch (level.toLowerCase()) {
      case 'beginner':   return const Color(0xFF3FB950);
      case 'intermediate': return const Color(0xFFD29922);
      case 'advanced':   return const Color(0xFFF85149);
      default:           return const Color(0xFF58A6FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 10,
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
