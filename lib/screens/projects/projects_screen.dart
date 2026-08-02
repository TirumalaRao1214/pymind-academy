import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lessons_provider.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Beginner'),
            Tab(text: 'Intermediate'),
            Tab(text: 'Advanced'),
          ],
        ),
      ),
      body: projectsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error loading projects: $e')),
        data: (projects) {
          final beginnerProjects =
              projects.where((p) => p['level'] == 'Beginner').toList();
          final intermediateProjects = projects
              .where((p) => p['level'] == 'Intermediate')
              .toList();
          final advancedProjects =
              projects.where((p) => p['level'] == 'Advanced').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _ProjectList(
                  projects: beginnerProjects,
                  color: const Color(0xFF3FB950)),
              _ProjectList(
                  projects: intermediateProjects,
                  color: const Color(0xFFD29922)),
              _ProjectList(
                  projects: advancedProjects,
                  color: const Color(0xFFF85149)),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  final Color color;

  const _ProjectList(
      {required this.projects, required this.color});

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return Center(
        child: Text('No projects available',
          style: Theme.of(context).textTheme.bodyLarge),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) =>
          _ProjectCard(project: projects[i], color: color),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final Color color;
  const _ProjectCard(
      {required this.project, required this.color});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final steps = List<String>.from(
        (widget.project['steps'] as List?) ?? []);
    final codeSnippet =
        widget.project['code_snippet'] as String? ?? '';

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: widget.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.rocket_launch_outlined,
                      color: widget.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.project['title'] as String,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        widget.project['description'] as String,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(
                                color: cs.onSurfaceVariant),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: cs.onSurfaceVariant,
                  ),
                  onPressed: () =>
                      setState(() => _expanded = !_expanded),
                ),
              ],
            ),
          ),

          // Expandable steps
          if (_expanded) ...[
            Divider(color: cs.outline, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (steps.isNotEmpty) ...[
                    Text('Steps',
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...steps.asMap().entries.map(
                      (e) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(
                                  top: 2),
                              decoration: BoxDecoration(
                                color: widget.color
                                    .withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${e.key + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: widget.color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(e.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (codeSnippet.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Starter Code',
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1117),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF30363D)),
                      ),
                      child: SelectableText(
                        codeSnippet,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFFE6EDF3),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
