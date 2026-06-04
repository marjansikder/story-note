
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_notes/models/notes_model.dart';
import 'package:story_notes/repository/note_pad_repository.dart';

import 'auth_provider.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository();
});

final notesStreamProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream<List<Note>>.value(const []);
      }
      return ref.watch(notesRepositoryProvider).watchNotes(user.uid);
    },
    error: (_, __) => Stream<List<Note>>.value(const []),
    loading: () => Stream<List<Note>>.value(const []),
  );
});
