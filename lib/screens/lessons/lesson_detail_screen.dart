import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lessons_provider.dart';
import '../../providers/progress_provider.dart';
import '../lessons/widgets/code_block_widget.dart';
import 'widgets/lesson_section_tile.dart';

class LessonDetailScreen extends ConsumerWidget {
  final String sectionId;
  final String lessonId;
  const LessonDetailScreen(
      {super.key, required this.sectionId, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync =
        ref.watch(lessonProvider((sectionId, lessonId)));
    final progressAsync = ref.watch(progressProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/learn/$sectionId'),
        ),
        actions: [
          lessonAsync.whenOrNull(
            data: (lesson) {
              if (lesson == null) return const SizedBox.shrink();
              final bookmarked =
                  progressAsync.valueOrNull?.isBookmarked(lesson.id) ??
                      false;
              return IconButton(
                icon: Icon(
                  bookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: bookmarked ? cs.primary : null,
                ),
                onPressed: () => ref
                    .read(progressProvider.notifier)
                    .toggleBookmark(lesson.id),
                tooltip: 'Bookmark',
              );
            },
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: lessonAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Failed to load lesson: $e')),
        data: (lesson) {
          if (lesson == null) {
            return const Center(child: Text('Lesson not found'));
          }
          // Track last accessed lesson
          ref
              .read(progressProvider.notifier)
              .setLastLesson(lesson.id, sectionId);

          final isComplete =
              progressAsync.valueOrNull?.isCompleted(lesson.id) ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(children: [
                  _LevelBadge(level: lesson.level),
                  const SizedBox(width: 8),
                  Text(lesson.section,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
                ]),
                const SizedBox(height: 10),
                Text(lesson.title,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),

                // Explanation
                LessonSectionTile(
                  icon: Icons.lightbulb_outline,
                  title: 'Explanation',
                  child: MarkdownBody(
                    data: lesson.explanation,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context)).copyWith(
                      p: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Real-world usage
                LessonSectionTile(
                  icon: Icons.work_outline,
                  title: 'Real-World Usage',
                  child: Text(lesson.realWorldUsage,
                    style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SizedBox(height: 16),

                // Code example
                LessonSectionTile(
                  icon: Icons.code,
                  title: 'Code Example',
                  child: CodeBlockWidget(code: lesson.codeExample),
                ),
                const SizedBox(height: 16),

                // Common mistakes
                if (lesson.commonMistakes.isNotEmpty)
                  LessonSectionTile(
                    icon: Icons.warning_amber_outlined,
                    title: 'Common Mistakes',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: lesson.commonMistakes
                          .map((m) => _BulletItem(text: m,
                              color: const Color(0xFFF85149)))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 16),

                // Mini exercise
                LessonSectionTile(
                  icon: Icons.edit_outlined,
                  title: 'Mini Exercise',
                  color: const Color(0xFF3FB950),
                  child: Text(lesson.miniExercise,
                    style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SizedBox(height: 16),

                // Interview questions
                if (lesson.interviewQuestions.isNotEmpty)
                  LessonSectionTile(
                    icon: Icons.quiz_outlined,
                    title: 'Interview Questions',
                    color: const Color(0xFFBC8CFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: lesson.interviewQuestions
                          .asMap()
                          .entries
                          .map((e) => _BulletItem(
                              text: '${e.key + 1}. ${e.value}',
                              color: const Color(0xFFBC8CFF)))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 16),

                // Summary
                LessonSectionTile(
                  icon: Icons.summarize_outlined,
                  title: 'Summary',
                  child: MarkdownBody(
                    data: lesson.summary,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context)).copyWith(
                      p: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quiz & complete buttons
                Row(children: [
                  if (lesson.quiz.isNotEmpty)
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.quiz_outlined),
                        label: const Text('Take Quiz'),
                        onPressed: () =>
                            context.go('/quiz/${lesson.id}',
                                extra: lesson),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  if (lesson.quiz.isNotEmpty) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(isComplete
                          ? Icons.check_circle
                          : Icons.check_circle_outline),
                      label: Text(isComplete
                          ? 'Completed'
                          : 'Mark Complete'),
                      onPressed: isComplete
                          ? null
                          : () => ref
                              .read(progressProvider.notifier)
                              .markComplete(lesson.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isComplete ? cs.primary.withOpacity(0.3) : cs.primary,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  Color get _color {
    switch (level.toLowerCase()) {
      case 'beginner':     return const Color(0xFF3FB950);
      case 'intermediate': return const Color(0xFFD29922);
      case 'advanced':     return const Color(0xFFF85149);
      default:             return const Color(0xFF58A6FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(level,
          style: TextStyle(
              color: _color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;
  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
