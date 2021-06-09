import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import '../../../domain/notes/i_note_repository.dart';
import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';

part 'note_watcher_bloc.freezed.dart';
part 'note_watcher_event.dart';
part 'note_watcher_state.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>> noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository) : super(const NoteWatcherState.initial());

  @override
  Stream<NoteWatcherState> mapEventToState(
    NoteWatcherEvent event,
  ) async* {
    yield const NoteWatcherState.loadInProgress();
    yield* event.map(
      watchAllStarted: (e) async* {
        //! DO NOT MOVE THIS LINE TO BEFORE event.map() TO SAVE CODE
        await noteStreamSubscription?.cancel();
        noteStreamSubscription = _noteRepository
            .watchAll()
            .listen((notes) => add(NoteWatcherEvent.notesReceived(notes)));
      },
      watchUncopletedStarted: (e) async* {
        await noteStreamSubscription?.cancel();
        noteStreamSubscription = _noteRepository
            .watchUncompleted()
            .listen((notes) => add(NoteWatcherEvent.notesReceived(notes)));
      },
      notesReceived: (e) async* {
        yield e.failureOrNotes.fold(
          (f) => NoteWatcherState.loadFailure(f),
          (notes) => NoteWatcherState.loadSuccess(notes),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await noteStreamSubscription.cancel();
    return super.close();
  }
}
