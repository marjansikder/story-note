import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:story_notes/models/notes_model.dart';


class NotesRepository {
  NotesRepository({FirebaseFirestore? fireStore})
      : _fireStore = fireStore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _fireStore;

  CollectionReference<Map<String, dynamic>> _notesCollection(String uid) {
    return _fireStore.collection('users').doc(uid).collection('notes');
  }

  Stream<List<Note>> watchNotes(String uid) {
    return _notesCollection(uid)
        .orderBy('modifiedTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Note.fromDocument).toList());
  }

  Future<void> upsertNote(String uid, Note note) async {
    if (note.id.isEmpty) {
      throw ArgumentError('Cannot update a note without an id.');
    }
    await _notesCollection(uid).doc(note.id).set(note.toMap());
  }

  Future<void> deleteNote(String uid, Note note) async {
    if (note.id.isEmpty) return;
    await _notesCollection(uid).doc(note.id).delete();
  }

  Future<Note> createNote(String uid, Note note) async {
    final docRef = await _notesCollection(uid).add(note.toMap());
    final doc = await docRef.get();
    return Note.fromDocument(doc);
  }
}
