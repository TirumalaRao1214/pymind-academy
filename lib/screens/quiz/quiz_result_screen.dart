import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String lessonId;
  final String lessonTitle;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.lessonId,
    required this.lessonTitle,
  });

  String get _grade {
    final pct = total > 0 ? score / total : 0.0;
    if (pct >= 0.9) return 'Excellent!';
    if (pct >= 0.7) return 'Good Job!';
    if (pct >= 0.5) return 'Keep Practicing';
    return 'Try Again';
  }

  Color get _gradeColor {
    final pct = total > 0 ? score / total : 0.0;
    if (pct >= 0.9) return const Color(0xFF3FB950);
    if (pct >= 0.7) return const Color(0xFFD29922);
    if (pct >= 0.5) return const Color(0xFFFFA657);
    return const Color(0xFFF85149);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pct = total > 0 ? (score / total * 100).round() : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/learn'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Score circle
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gradeColor.withOpacity(0.12),
                  border: Border.all(color: _gradeColor, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score/$total',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: _gradeColor,
                          ),
                    ),
                    Text(
                      '$pct%',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _grade,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _gradeColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                lessonTitle,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/learn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Back to Lessons'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/learn'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('View More Lessons'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
