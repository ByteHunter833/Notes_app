import 'package:flutter/material.dart';
import 'package:notes_app/helpers/capitalize_first_letter.dart';
import 'package:notes_app/pages/mark_down_preview.dart';

class NoteAddEdit extends StatefulWidget {
  const NoteAddEdit({super.key});

  @override
  State<NoteAddEdit> createState() => _NoteAddEditState();
}

class _NoteAddEditState extends State<NoteAddEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();

  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateContentState);
    _bodyController.addListener(_updateContentState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  void _updateContentState() {
    setState(() {
      _hasContent =
          _titleController.text.trim().isNotEmpty ||
          _bodyController.text.trim().isNotEmpty;
    });
  }

  void _showPreview() {
    if (!_hasContent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add some content first'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkDownPreview(
          markdowText: {
            'title': '# ${_titleController.text.trim()}',
            'body': _bodyController.text.trim(),
          },
        ),
      ),
    );
  }

  void _applyMarkdown(String prefix, String suffix, {String? placeholder}) {
    final controller = _bodyController;
    final selection = controller.selection;
    final text = controller.text;

    if (!selection.isValid) {
      // If no selection, insert placeholder text
      final insertText = '$prefix${placeholder ?? 'text'}$suffix';
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        insertText,
      );
      final newCursorPos = selection.start + prefix.length;

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: newCursorPos,
          extentOffset: newCursorPos + (placeholder?.length ?? 4),
        ),
      );
      return;
    }

    // Get selected text
    final selectedText = text.substring(selection.start, selection.end);

    if (selectedText.isEmpty) {
      // No text selected, insert placeholder
      final insertText = '$prefix${placeholder ?? 'text'}$suffix';
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        insertText,
      );
      final newCursorPos = selection.start + prefix.length;

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: newCursorPos,
          extentOffset: newCursorPos + (placeholder?.length ?? 4),
        ),
      );
    } else {
      // Apply formatting to selected text
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset:
              selection.start +
              prefix.length +
              selectedText.length +
              suffix.length,
        ),
      );
    }
  }

  void _applyLinePrefix(String prefix) {
    final controller = _bodyController;
    final selection = controller.selection;
    final text = controller.text;

    if (!selection.isValid) return;

    // Find the start of the current line
    int lineStart = selection.start;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    // Insert prefix at the start of the line
    final newText = text.replaceRange(lineStart, lineStart, prefix);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + prefix.length,
      ),
    );
  }

  void _showLinkDialog() async {
    final controller = _bodyController;
    final selection = controller.selection;
    final selectedText = selection.isValid && selection.start != selection.end
        ? controller.text.substring(selection.start, selection.end)
        : '';

    final urlController = TextEditingController();
    final textController = TextEditingController(text: selectedText);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Link Text',
                hintText: 'Enter text to display',
                border: OutlineInputBorder(),
              ),
              autofocus: selectedText.isEmpty,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              autofocus: selectedText.isNotEmpty,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (textController.text.isNotEmpty &&
                  urlController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'text': textController.text,
                  'url': urlController.text,
                });
              }
            },
            child: const Text('Insert'),
          ),
        ],
      ),
    );

    if (result != null) {
      final linkMarkdown = '[${result['text']}](${result['url']})';
      final text = controller.text;
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        linkMarkdown,
      );

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + linkMarkdown.length,
        ),
      );
    }
  }

  void _showCodeBlockDialog() async {
    final controller = _bodyController;
    final selection = controller.selection;
    final selectedText = selection.isValid && selection.start != selection.end
        ? controller.text.substring(selection.start, selection.end)
        : '';

    final codeController = TextEditingController(text: selectedText);
    final languageController = TextEditingController(text: 'dart');

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Code Block'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: languageController,
              decoration: const InputDecoration(
                labelText: 'Language',
                hintText: 'dart, javascript, python, etc.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Code',
                hintText: 'Enter your code here',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, {
                'language': languageController.text,
                'code': codeController.text,
              });
            },
            child: const Text('Insert'),
          ),
        ],
      ),
    );

    if (result != null) {
      final codeBlock = '\n```${result['language']}\n${result['code']}\n```\n';
      final text = controller.text;
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        codeBlock,
      );

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + codeBlock.length,
        ),
      );
    }
  }

  void _loadExample() {
    _titleController.text = 'Markdown Features Demo';
    _bodyController.text = '''## Getting Started with Markdown

Markdown is a lightweight markup language that you can use to format text.

### Text Formatting

You can make text **bold** or *italic*. You can also combine them: ***bold and italic***.

### Lists

Here's an unordered list:
- First item
- Second item
- Third item
  - Nested item
  - Another nested item

And a numbered list:
1. First step
2. Second step
3. Third step

### Code

Inline code looks like this: `console.log("Hello World")`

Code blocks look like this:
```dart
void main() {
  print('Hello, Flutter!');
}
```

### Quotes

> "The best way to predict the future is to invent it."
> — Alan Kay

### Links

Check out [Flutter documentation](https://flutter.dev) for more info.

### Horizontal Rule

---

That's it! Start creating your own notes now.
''';
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Note',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadExample,
            tooltip: 'Load Example',
            icon: Icon(
              Icons.lightbulb_outline,
              color: theme.colorScheme.primary,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _showPreview,
              style: FilledButton.styleFrom(
                backgroundColor: _hasContent
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                foregroundColor: _hasContent
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              icon: const Icon(Icons.visibility_outlined, size: 20),
              label: const Text('Preview'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: TextField(
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              controller: _titleController,
              focusNode: _titleFocusNode,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _bodyFocusNode.requestFocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  letterSpacing: -0.5,
                ),
              ),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Divider(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
              height: 1,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surfaceContainerHigh,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MarkdownButton(
                    icon: Icons.format_bold,
                    tooltip: 'Bold (select text first)',
                    onPressed: () =>
                        _applyMarkdown('**', '**', placeholder: 'bold text'),
                  ),
                  _MarkdownButton(
                    icon: Icons.format_italic,
                    tooltip: 'Italic (select text first)',
                    onPressed: () =>
                        _applyMarkdown('*', '*', placeholder: 'italic text'),
                  ),
                  _MarkdownButton(
                    icon: Icons.strikethrough_s,
                    tooltip: 'Strikethrough (select text first)',
                    onPressed: () => _applyMarkdown(
                      '~~',
                      '~~',
                      placeholder: 'strikethrough',
                    ),
                  ),
                  const VerticalDivider(width: 20),
                  _MarkdownButton(
                    icon: Icons.format_list_bulleted,
                    tooltip: 'Bullet List',
                    onPressed: () => _applyLinePrefix('- '),
                  ),
                  _MarkdownButton(
                    icon: Icons.format_list_numbered,
                    tooltip: 'Numbered List',
                    onPressed: () => _applyLinePrefix('1. '),
                  ),
                  _MarkdownButton(
                    icon: Icons.checklist,
                    tooltip: 'Checkbox',
                    onPressed: () => _applyLinePrefix('- [ ] '),
                  ),
                  const VerticalDivider(width: 20),
                  _MarkdownButton(
                    icon: Icons.title,
                    tooltip: 'Heading',
                    onPressed: () => _applyLinePrefix('## '),
                  ),
                  _MarkdownButton(
                    icon: Icons.format_quote,
                    tooltip: 'Quote',
                    onPressed: () => _applyLinePrefix('> '),
                  ),
                  const VerticalDivider(width: 20),
                  _MarkdownButton(
                    icon: Icons.code,
                    tooltip: 'Inline Code (select text first)',
                    onPressed: () =>
                        _applyMarkdown('`', '`', placeholder: 'code'),
                  ),
                  _MarkdownButton(
                    icon: Icons.code_outlined,
                    tooltip: 'Code Block',
                    onPressed: _showCodeBlockDialog,
                  ),
                  _MarkdownButton(
                    icon: Icons.link,
                    tooltip: 'Insert Link',
                    onPressed: _showLinkDialog,
                  ),
                  _MarkdownButton(
                    icon: Icons.horizontal_rule,
                    tooltip: 'Horizontal Rule',
                    onPressed: () {
                      final controller = _bodyController;
                      final text = controller.text;
                      final pos = controller.selection.start;
                      final newText = text.replaceRange(pos, pos, '\n---\n');
                      controller.value = TextEditingValue(
                        text: newText,
                        selection: TextSelection.collapsed(offset: pos + 5),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TextField(
                inputFormatters: [CapitalizeFirstLetterFormatter()],
                controller: _bodyController,
                focusNode: _bodyFocusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Start typing your note...\n\nTip: Select text and use toolbar buttons to format',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    height: 1.6,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  height: 1.6,
                  letterSpacing: 0.1,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkdownButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _MarkdownButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, size: 20),
        style: IconButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
