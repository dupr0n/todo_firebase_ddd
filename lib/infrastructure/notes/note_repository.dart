import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

import './note_dtos.dart';
import '../../domain/notes/i_note_repository.dart';
import '../../domain/notes/note.dart';
import '../../domain/notes/note_failure.dart';
import '../core/firestore_helpers.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    //* Use snapshots instead of getDocuments, so only new values are downloaded instead of everything
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snap) => right<NoteFailure, KtList<Note>>(
            snap.docs.map((doc) => NoteDTO.fromFirestore(doc).toDomain()).toImmutableList()))
        .onErrorReturnWith((error) {
      if (error is FirebaseException && error.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => NoteDTO.fromFirestore(doc).toDomain()))
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(
            notes
                .where((note) => note.todos.getOrCrash().any((todoItem) => !todoItem.done))
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((error) {
      if (error is FirebaseException && error.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);
      //* Using [.doc(noteDTO.id).set(noteDTO.toJson())] instead of
      //* [.add(noteDTO.toJson())] as 'add' auto-generates an ID and we want our own id.
      await userDoc.noteCollection.doc(noteDTO.id).set(noteDTO.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);
      await userDoc.noteCollection.doc(noteDTO.id).update(noteDTO.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message.contains('NOT_FOUND')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
