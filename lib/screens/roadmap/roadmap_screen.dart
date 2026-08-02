import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lessons_provider.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(roadmapProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('AI/ML Learning Roadmap')),
      body: roadmapAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error loading roadmap: $e')),
        data: (nodes) => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: nodes.length,
          itemBuilder: (context, i) {
            final node = nodes[i];
            final isLast = i == nodes.length - 1;
            final color = _nodeColor(i);
            return _RoadmapNode(
              node: node,
              index: i,
              color: color,
              isLast: isLast,
            );
          },
        ),
      ),
    );
  }

  Color _nodeColor(int index) {
    const colors = [
      Color(0xFF58A6FF),
      Color(0xFF3FB950),
      Color(0xFFD29922),
      Color(0xFFBC8CFF),
      Color(0xFFFFA657),
      Color(0xFF56D364),
      Color(0xFFD2A8FF),
    ];
    return colors[index % colors.length];
  }
}

class _RoadmapNode extends StatelessWidget {
  final Map<String, dynamic> node;
  final int index;
  final Color color;
  final bool isLast;

  const _RoadmapNode({
    required this.node,
    required this.index,
    required this.color,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final skills = List<String>.from(
        (node['skills'] as List?) ?? []);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: cs.outline,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          node['title'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                        ),
                      ),
                      if (node['status'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: color.withOpacity(0.4)),
                          ),
                          child: Text(
                            node['status'] as String,
                            style: TextStyle(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    node['description'] as String? ?? '',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  if (skills.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: skills
                          .map((s) => Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      cs.surfaceContainerHighest,
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  border: Border.all(
                                      color: cs.outline),
                                ),
                                child: Text(s,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            cs.onSurfaceVariant)),
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
