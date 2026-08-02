import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lessons_provider.dart';
import '../../providers/progress_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final allLessonsAsync = ref.watch(allLessonsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (progress) {
          if (progress.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 48, color: cs.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('No bookmarks yet',
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 6),
                  Text('Tap the bookmark icon on any lesson to save it here.',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return allLessonsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (allLessons) {
              final bookmarked = allLessons
                  .where((l) => progress.bookmarks.contains(l.id))
                  .toList();
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarked.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final lesson = bookmarked[i];
                  return ListTile(
                    tileColor: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: cs.outline),
                    ),
                    leading: Icon(Icons.bookmark,
                        color: cs.primary, size: 20),
                    title: Text(lesson.title,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${lesson.section} • ${lesson.level}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: cs.onSurfaceVariant),
                    onTap: () => context.go(
                        '/learn/${lesson.section}/${lesson.id}'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
