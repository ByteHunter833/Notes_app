import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkDownPreview extends StatelessWidget {
  final Map<String, String> markdowText;

  const MarkDownPreview({super.key, required this.markdowText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        title: const Text(
          'Preview',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Add share functionality
            },
            tooltip: 'Share',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Title Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: MarkdownBody(
                  data: markdowText['title'] ?? '',
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    h2: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: theme.colorScheme.onSurface,
                    ),
                    h3: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),

            // Body Section
            SliverToBoxAdapter(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Markdown(
                  data: markdowText['body'] ?? '',
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  selectable: true,
                  padding: EdgeInsets.zero,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 0.1,
                    ),
                    h1: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    h2: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: theme.colorScheme.onSurface,
                    ),
                    h3: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: theme.colorScheme.onSurface,
                    ),
                    h4: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: theme.colorScheme.onSurface,
                    ),
                    listBullet: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                    ),
                    listBulletPadding: const EdgeInsets.only(right: 8),
                    listIndent: 24,
                    blockquote: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 16,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 4,
                        ),
                      ),
                    ),
                    blockquotePadding: const EdgeInsets.all(16),
                    code: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                      backgroundColor: isDark
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.surfaceContainerHigh,
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                    codeblockPadding: const EdgeInsets.all(16),
                    horizontalRuleDecoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                    ),
                    a: TextStyle(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.primary.withOpacity(
                        0.4,
                      ),
                    ),
                    strong: const TextStyle(fontWeight: FontWeight.w700),
                    em: const TextStyle(fontStyle: FontStyle.italic),
                    blockSpacing: 16,
                    h1Padding: const EdgeInsets.only(top: 24, bottom: 16),
                    h2Padding: const EdgeInsets.only(top: 20, bottom: 12),
                    h3Padding: const EdgeInsets.only(top: 16, bottom: 10),
                  ),
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
