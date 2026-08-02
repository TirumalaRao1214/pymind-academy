import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lessons_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final filteredAsync = ref.watch(filteredLessonsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search lessons…',
            border: InputBorder.none,
            hintStyle: TextStyle(color: cs.onSurfaceVariant),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: (v) =>
              ref.read(searchQueryProvider.notifier).state = v,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            context.go('/');
          },
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () =>
                  ref.read(searchQueryProvider.notifier).state = '',
            ),
        ],
      ),
      body: filteredAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error loading lessons: $e')),
        data: (lessons) {
          if (query.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 48, color: cs.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('Start typing to search lessons',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            );
          }
          if (lessons.isEmpty) {
            return Center(
              child: Text(
                'No results for "$query"',
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final lesson = lessons[i];
              return ListTile(
                tileColor: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: cs.outline),
                ),
                leading: Icon(Icons.menu_book_outlined,
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
      ),
    );
  }
}
