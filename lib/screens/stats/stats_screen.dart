import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/progress_provider.dart';
import '../../providers/lessons_provider.dart';
import '../../models/section.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final sectionsAsync = ref.watch(sectionsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress & Stats')),
      body: progressAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error: $e')),
        data: (progress) {
          final total = sectionsAsync.maybeWhen(
            data: (s) => s.fold<int>(0, (sum, sec) => sum + sec.lessonCount),
            orElse: () => 0,
          );
          final completed = progress.completedCount;
          final pct = total > 0
              ? (completed / total * 100).round()
              : 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview cards
                Row(children: [
                  Expanded(child: _StatCard(
                    label: 'Completed',
                    value: '$completed',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF3FB950),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(
                    label: 'Streak',
                    value: '${progress.streak}d',
                    icon: Icons.local_fire_department_outlined,
                    color: const Color(0xFFD29922),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(
                    label: 'Progress',
                    value: '$pct%',
                    icon: Icons.trending_up,
                    color: cs.primary,
                  )),
                ]),
                const SizedBox(height: 24),

                // Progress per section
                Text('Progress by Section',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),

                sectionsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (sections) => _SectionProgressChart(
                    sections: sections,
                    progress: progress,
                  ),
                ),

                const SizedBox(height: 24),

                // Bookmarks count
                _StatCard(
                  label: 'Bookmarked Lessons',
                  value: '${progress.bookmarks.length}',
                  icon: Icons.bookmark_outline,
                  color: cs.secondary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800, color: color)),
          Text(label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SectionProgressChart extends StatelessWidget {
  final List<Section> sections;
  final dynamic progress;

  const _SectionProgressChart(
      {required this.sections, required this.progress});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: sections.asMap().entries.map((entry) {
        final i = entry.key;
        final s = entry.value;
        final completed = progress.lessons.values
            .where((l) =>
                (l as dynamic).completed &&
                (l as dynamic).lessonId.toString().startsWith(s.id))
            .length;
        final ratio =
            s.lessonCount > 0 ? completed / s.lessonCount : 0.0;

        const colors = [
          Color(0xFF58A6FF),
          Color(0xFF3FB950),
          Color(0xFFD29922),
          Color(0xFFBC8CFF),
          Color(0xFFFFA657),
          Color(0xFF56D364),
          Color(0xFFF78166),
          Color(0xFF79C0FF),
          Color(0xFFFF7B72),
          Color(0xFFD2A8FF),
        ];
        final barColor = colors[i % colors.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    s.title,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$completed/${s.lessonCount}',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ]),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: cs.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
