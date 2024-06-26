import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:myapp/models/notes.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier{
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  final List<Note> currentNotes = [];

  Future<void> addNote(String text, String heading ) async {
    final newNote = Note()..text = text ..heading = heading;

    await isar.writeTxn(() => isar.notes.put(newNote));

    fetchNotes();
  }

  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  Future<void> updateNote(int id, String newText, String newHeader)async{
    final existingNote = await isar.notes.get(id);
    if(existingNote != null){
      existingNote.text = newText;
      existingNote.heading = newHeader;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> deleteNote(int id)async{
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
