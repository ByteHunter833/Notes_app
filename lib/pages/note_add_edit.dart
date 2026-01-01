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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarkDownPreview()),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                theme.colorScheme.primary,
              ),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            icon: const Icon(Icons.visibility_outlined),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            TextField(
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 32,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                inputFormatters: [CapitalizeFirstLetterFormatter()],
                controller: _bodyController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
