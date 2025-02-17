import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/notes/note_watcher/note_watcher_bloc.dart';
import 'critical_failure_display_widget.dart';
import 'error_note_card_widget.dart';
import 'note_card_widget.dart';

class NotesOverviewBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) => state.map(
        initial: (_) => Container(),
        loadInProgress: (_) => const Center(child: CircularProgressIndicator()),
        loadSuccess: (state) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final note = state.notes[index];
              if (note.failureOption.isSome()) {
                return ErrorNoteCard(note: note);
              } else {
                return NoteCard(note: note);
              }
            },
            itemCount: state.notes.size,
          );
        },
        loadFailure: (state) => CriticalFailureWidget(failure: state.noteFailure),
      ),
    );
  }
}
