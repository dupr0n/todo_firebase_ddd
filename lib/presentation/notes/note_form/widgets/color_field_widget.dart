import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/notes/note_form/note_form_bloc.dart';
import '../../../../domain/notes/value_objects.dart';

class ColorField extends StatelessWidget {
  const ColorField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (p, c) => p.note.color != c.note.color,
      builder: (context, state) {
        return SizedBox(
          height: 80.0,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final itemColor = NoteColor.predefinedColors[index];
              return GestureDetector(
                onTap: () =>
                    context.bloc<NoteFormBloc>().add(NoteFormEvent.colorChanged(itemColor)),
                child: Material(
                  color: itemColor,
                  elevation: 4,
                  shape: CircleBorder(
                      side: state.note.color.value.fold(
                    (_) => const BorderSide(width: 10),
                    (color) => color == itemColor ? const BorderSide(width: 1.5) : BorderSide.none,
                  )),
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: NoteColor.predefinedColors.length,
          ),
        );
      },
    );
  }
}
