import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/lessons_provider.dart';
import '../../providers/progress_provider.dart';
import '../../models/lesson.dart';

class QuizScreen extends ConsumerWidget {
  final String lessonId;
  const QuizScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find the section for this lesson by scanning all sections
    // We pass the Lesson via router extra, but also support lookup
    final extra = GoRouterState.of(context).extra;
    final lesson = extra is Lesson ? extra : null;

    if (lesson != null) {
      return _QuizBody(lesson: lesson);
    }

    // Fallback: search all lessons
    final allAsync = ref.watch(allLessonsProvider);
    return allAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Error: $e'))),
      data: (lessons) {
        final found = lessons.cast<dynamic>().firstWhere(
          (l) => (l as dynamic).id == lessonId,
          orElse: () => null,
        );
        if (found == null) {
          return const Scaffold(
              body: Center(child: Text('Lesson not found')));
        }
        return _QuizBody(lesson: found as Lesson);
      },
    );
  }
}

class _QuizBody extends ConsumerWidget {
  final Lesson lesson;
  const _QuizBody({required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider(lesson.quiz));
    final notifier = ref.read(quizNotifierProvider(lesson.quiz).notifier);
    final cs = Theme.of(context).colorScheme;

    if (quizState.finished) {
      // Navigate to result and save score
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(progressProvider.notifier).saveQuizScore(
          lesson.id,
          quizState.score,
          quizState.questions.length,
        );
        context.go('/quiz-result', extra: {
          'score': quizState.score,
          'total': quizState.questions.length,
          'lessonId': lesson.id,
          'lessonTitle': lesson.title,
        });
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = quizState.currentQuestion;
    if (q == null) {
      return const Scaffold(
          body: Center(child: Text('No quiz questions available.')));
    }

    final answered = quizState.selectedAnswers.containsKey(quizState.currentIndex);
    final selectedIdx = quizState.selectedAnswers[quizState.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${lesson.title}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/learn'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Row(children: [
              Text(
                'Question ${quizState.currentIndex + 1}/${quizState.questions.length}',
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              Text(
                'Score: ${quizState.score}',
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: cs.primary),
              ),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (quizState.currentIndex + 1) /
                    quizState.questions.length,
                minHeight: 4,
                backgroundColor: cs.outline,
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
              ),
            ),
            const SizedBox(height: 24),

            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outline),
              ),
              child: Text(
                q.question,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),

            // Options
            ...q.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              Color? bgColor;
              Color? borderColor;
              IconData? trailingIcon;

              if (answered) {
                if (idx == q.correctIndex) {
                  bgColor = const Color(0xFF1A7F37).withOpacity(0.15);
                  borderColor = const Color(0xFF3FB950);
                  trailingIcon = Icons.check_circle;
                } else if (idx == selectedIdx) {
                  bgColor = const Color(0xFFCF222E).withOpacity(0.12);
                  borderColor = const Color(0xFFF85149);
                  trailingIcon = Icons.cancel;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: answered
                      ? null
                      : () => notifier.selectAnswer(idx),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor ?? cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: borderColor ?? cs.outline),
                    ),
                    child: Row(children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor ?? cs.outline),
                          color: borderColor?.withOpacity(0.15),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + idx),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: borderColor ?? cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(opt,
                          style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      if (trailingIcon != null)
                        Icon(trailingIcon,
                            color: borderColor, size: 18),
                    ]),
                  ),
                ),
              );
            }),

            // Explanation feedback
            if (answered && q.explanation.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.primary.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(q.explanation,
                        style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // Next button
            if (answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: notifier.nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(quizState.isLastQuestion
                      ? 'See Results'
                      : 'Next Question'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
