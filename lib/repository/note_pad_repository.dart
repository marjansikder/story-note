import 'package:date_calculator/models/notes_model.dart';
import 'package:hive/hive.dart';

class NotesRepository {
  late final Box<Note> _notesBox;

  Future<void> init() async {
    _notesBox = await Hive.openBox<Note>('notes_box');
  }

  List<Note> getAllNotes() {
    return _notesBox.values.toList()..sort((a, b) => b.modifiedTime.compareTo(a.modifiedTime));
  }

  Future<void> addNote(Note note) async {
    await _notesBox.add(note);
  }

  Future<void> updateNote(Note note) async {
    await note.save();
  }

  Future<void> deleteNote(Note note) async {
    await note.delete();
  }

  Future<void> close() async {
    await _notesBox.close();
  }
}
