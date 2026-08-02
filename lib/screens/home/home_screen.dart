import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lessons_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/theme_provider.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/daily_quote_card.dart';
import 'widgets/progress_summary_card.dart';
import 'widgets/category_grid.dart';
import 'widgets/continue_learning_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text('P', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                )),
              ),
            ),
            const SizedBox(width: 10),
            const Text('PyMind Academy'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => context.go('/search'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.go('/bookmarks'),
            tooltip: 'Bookmarks',
          ),
          Consumer(builder: (context, ref, _) {
            final mode = ref.watch(themeModeProvider);
            return IconButton(
              icon: Icon(mode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
              tooltip: 'Toggle theme',
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(sectionsProvider);
          ref.invalidate(quotesProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const DailyQuoteCard(),
                  const SizedBox(height: 16),
                  const ContinueLearningCard(),
                  const SizedBox(height: 16),
                  const ProgressSummaryCard(),
                  const SizedBox(height: 20),
                  Text(
                    'Learning Modules',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CategoryGrid(),
                  const SizedBox(height: 24),
                  _QuickActionsRow(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: _QuickAction(
          icon: Icons.code_outlined,
          label: 'Playground',
          color: AppColors.accentGreen,
          onTap: () => context.go('/playground'),
        )),
        const SizedBox(width: 10),
        Expanded(child: _QuickAction(
          icon: Icons.map_outlined,
          label: 'AI Roadmap',
          color: AppColors.accentPurple,
          onTap: () => context.go('/roadmap'),
        )),
        const SizedBox(width: 10),
        Expanded(child: _QuickAction(
          icon: Icons.rocket_launch_outlined,
          label: 'Projects',
          color: AppColors.accentOrange,
          onTap: () => context.go('/projects'),
        )),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
