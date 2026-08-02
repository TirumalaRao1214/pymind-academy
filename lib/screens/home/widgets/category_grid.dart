import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/lessons_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../models/section.dart';
import '../../../core/constants/app_colors.dart';

class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(sectionsProvider);
    final progressAsync = ref.watch(progressProvider);

    return sectionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(child: Text('Error loading sections: $e')),
      data: (sections) {
        final progress = progressAsync.valueOrNull;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemCount: sections.length,
          itemBuilder: (context, i) {
            return _SectionCard(
              section: sections[i],
              completedCount: progress?.lessons.values
                  .where((l) => l.completed &&
                      l.lessonId.startsWith(sections[i].id))
                  .length ?? 0,
            );
          },
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Section section;
  final int completedCount;

  const _SectionCard({required this.section, required this.completedCount});

  Color get _sectionColor {
    final hex = section.color.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _sectionColor;
    final progress = section.lessonCount > 0
        ? completedCount / section.lessonCount
        : 0.0;

    return InkWell(
      onTap: () => context.go('/learn/${section.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_iconFromString(section.icon),
                      color: color, size: 18),
                ),
                const Spacer(),
                Text(
                  '$completedCount/${section.lessonCount}',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const Spacer(),
            Text(section.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 3,
                backgroundColor: cs.outline,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromString(String icon) {
    const map = {
      'python':         Icons.code,
      'control':        Icons.alt_route,
      'functions':      Icons.functions,
      'data':           Icons.storage,
      'oop':            Icons.account_tree,
      'file':           Icons.folder_open,
      'api':            Icons.cloud_outlined,
      'automation':     Icons.settings_suggest,
      'ml':             Icons.psychology_outlined,
      'ai':             Icons.smart_toy_outlined,
      'code':           Icons.code,
    };
    return map[icon] ?? Icons.circle;
  }
}
