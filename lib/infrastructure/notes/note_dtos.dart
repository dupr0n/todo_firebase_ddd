import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

import '../../domain/core/value_object.dart';
import '../../domain/notes/note.dart';
import '../../domain/notes/todo_item.dart';
import '../../domain/notes/value_objects.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class NoteDTO implements _$NoteDTO {
  const NoteDTO._();

  const factory NoteDTO({
    @JsonKey(ignore: true) String id,
    @required String body,
    @required int color,
    @required List<TodoItemDTO> todos,
    @required @ServerTimeStampConverter() FieldValue serverTimeStamp,
  }) = _NoteDTO;

  factory NoteDTO.fromDomain(Note note) => NoteDTO(
        body: note.body.getOrCrash(),
        color: note.color.getOrCrash().value,
        todos: note.todos.getOrCrash().map((todoItem) => TodoItemDTO.fromDomain(todoItem)).asList(),
        serverTimeStamp: FieldValue.serverTimestamp(),
        id: note.id.getOrCrash(),
      );

  factory NoteDTO.fromJson(Map<String, dynamic> json) => _$NoteDTOFromJson(json);

  factory NoteDTO.fromFirestore(DocumentSnapshot doc) =>
      NoteDTO.fromJson(doc.data()).copyWith(id: doc.id);

  Note toDomain() => Note(
        id: UniqueId.fromUniqueString(id),
        body: NoteBody(body),
        color: NoteColor(Color(color)),
        todos: List3(todos.map((dto) => dto.toDomain()).toImmutableList()),
      );
}

class ServerTimeStampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimeStampConverter(); //* Required to make this an annotation class

  @override
  FieldValue fromJson(Object json) => FieldValue.serverTimestamp();

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
abstract class TodoItemDTO implements _$TodoItemDTO {
  const TodoItemDTO._();

  const factory TodoItemDTO({
    @required String id,
    @required String name,
    @required bool done,
  }) = _TodoItemDTO;

  factory TodoItemDTO.fromDomain(TodoItem todoItem) => TodoItemDTO(
        id: todoItem.id.getOrCrash(),
        name: todoItem.name.getOrCrash(),
        done: todoItem.done,
      );

  TodoItem toDomain() => TodoItem(
        id: UniqueId.fromUniqueString(id),
        name: TodoName(name),
        done: done,
      );

  factory TodoItemDTO.fromJson(Map<String, dynamic> json) => _$TodoItemDTOFromJson(json);
}
