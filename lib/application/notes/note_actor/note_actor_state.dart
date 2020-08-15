part of 'note_actor_bloc.dart';

@freezed
abstract class NoteActorState with _$NoteActorState {
  const factory NoteActorState.initail() = _Initail;
  const factory NoteActorState.actionInProgress() = _ActionInProgress;
  const factory NoteActorState.deleteFailure(NoteFailure noteFailure) = _DeleteFailure;
  const factory NoteActorState.deleteSuccess() = _DeleteSuccess;
}
