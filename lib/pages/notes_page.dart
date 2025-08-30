import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/components/my_drawer.dart';
import 'package:notes_app/components/note_tile.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NoteDatabase>().fetchNotes();
  }

  //create Note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Type something...'),
        ),
        actions: [
          MaterialButton(
            child: const Text('Create'),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                context.read<NoteDatabase>().createNote(_textController.text);
                _textController.clear();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  // update note
  void updateNote(Note note) {
    _textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: _textController),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteDatabase>().updateNote(
                _textController.text,
                note.id,
              );
              _textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // delete note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesDatabse = context.watch<NoteDatabase>();
    final currentNotes = notesDatabse.currentNotes;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: currentNotes.isEmpty
                ? const Center(child: Text('No Notes'))
                : ListView.builder(
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      final note = currentNotes[index];
                      return NoteTile(
                        text: note.text,
                        onDeletePressed: () => deleteNote(note.id),
                        onEditPressed: () => updateNote(note),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
