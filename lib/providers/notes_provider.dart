import 'package:date_calculator/models/notes_model.dart';
import 'package:date_calculator/providers/auth_provider.dart';
import 'package:date_calculator/repository/note_pad_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
