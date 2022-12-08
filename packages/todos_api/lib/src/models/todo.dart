///The first thing of note is that the Todoo model doesn't live in our app — it's part of the todos_api package. This is because the TodosApi defines APIs that return/accept Todoo objects. The model is a Dart representation of the raw Todoo object that will be stored/retrieved.
///
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:todos_api/todos_api.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

/// A single todoo item.
/// Contains a [title], [description] and [id], in addition to a [isCompleted] flag.
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one will be generated.
/// [Todoo]s are immutable and can be copied using [copyWith], in addition to being serialized and deserialized using [toJson] and [fromJson] respectively.

@immutable
@JsonSerializable()
class Todo extends Equatable {
  /// The unique identifier of the todoo.
  /// Cannot be empty.
  final String id;

  /// The title of the todoo.
  /// Note that the title may be empty.
  final String title;

  /// The description of the todoo.
  /// Defaults to an empty string.
  final String description;

  /// Whether the todoo is completed.
  /// Defaults to `false`.
  final bool isCompleted;

  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// Returns a copy of this todoo with the given values updated.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Deserializes the given [JsonMap] into a [Todoo].
  static Todo fromJson(JsonMap json) => _$TodoFromJson(json);

  /// Converts this [Todoo] into a [JsonMap].
  JsonMap toJson() => _$TodoToJson(this);

  @override
  List<Object> get props => [id, title, description, isCompleted];
}

/// The type definition for a JSON-serializable [Map].
typedef JsonMap = Map<String, dynamic>;
