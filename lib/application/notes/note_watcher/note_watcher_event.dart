part of 'note_watcher_bloc.dart';

@freezed
abstract class NoteWatcherEvent with _$NoteWatcherEvent {
  const factory NoteWatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory NoteWatcherEvent.watchUncopletedStarted() = _WatchUncopletedStarted;
  //* This notesReceived event is used because an event would be listened to (in the block) constantly
  //*  and would not allow us to listen to another event. This solution enables us to mitigate that
  const factory NoteWatcherEvent.notesReceived(
    Either<NoteFailure, KtList<Note>> failureOrNotes,
  ) = _NotesReceived;
}
