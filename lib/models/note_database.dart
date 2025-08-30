import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  final List<Note> currentNotes = [];

  // CREATE
  Future<void> createNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() async {
      await isar.notes.put(newNote);
    });
    await fetchNotes();
  }

  // READ
  Future<void> fetchNotes() async {
    if (!isar.isOpen) {
      await initialize();
    }
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);

    notifyListeners();
  }

  // UPDATE
  Future<void> updateNote(String newText, int id) async {
    final currentNote = await isar.notes.get(id);
    if (currentNote != null) {
      currentNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(currentNote));
      await fetchNotes();
    }
  }

  // DELETE
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
