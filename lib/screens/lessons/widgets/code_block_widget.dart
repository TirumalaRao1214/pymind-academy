import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBlockWidget extends StatefulWidget {
  final String code;
  const CodeBlockWidget({super.key, required this.code});

  @override
  State<CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

class _CodeBlockWidgetState extends State<CodeBlockWidget> {
  bool _copied = false;

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0D1117)
            : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? const Color(0xFF30363D)
              : const Color(0xFFD0D7DE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF30363D)
                      : const Color(0xFFD0D7DE),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF85149),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD29922),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3FB950),
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                Text('python',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                    fontFamily: 'JetBrainsMono',
                  )),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _copyCode,
                  child: Row(
                    children: [
                      Icon(
                        _copied
                            ? Icons.check
                            : Icons.copy_outlined,
                        size: 14,
                        color: _copied
                            ? const Color(0xFF3FB950)
                            : cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _copied ? 'Copied!' : 'Copy',
                        style: TextStyle(
                          fontSize: 11,
                          color: _copied
                              ? const Color(0xFF3FB950)
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SelectableText(
                widget.code,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13,
                  height: 1.6,
                  color: isDark
                      ? const Color(0xFFE6EDF3)
                      : const Color(0xFF1F2328),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
