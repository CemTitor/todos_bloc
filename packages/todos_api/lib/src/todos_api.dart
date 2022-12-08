import 'package:todos_api/todos_api.dart';

/// The interface for an API that provides access to a list of todos.
/// The todos_api package will export a generic interface for interacting/managing todos. Later we'll implement the TodosApi using shared_preferences. Having an abstraction will make it easy to support other implementations without having to change any other part of our application.
/// For example, we can later add a FirestoreTodosApi, which uses cloud_firestore instead of shared_preferences, with minimal code changes to the rest of the application.
abstract class TodosApi {
  /// {@macro todos_api}
  const TodosApi();

  /// Provides a [Stream] of all todos.
  /// Report real-time updates to all subscribers when the list of todos has changed.
  Stream<List<Todo>> getTodos();

  /// Saves a [todoo].
  ///
  /// If a [todoo] with the same id already exists, it will be replaced.
  Future<void> saveTodo(Todo todo);

  /// Deletes the todoo with the given id.
  ///
  /// If no todoo with the given id exists, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteTodo(String id);

  /// Deletes all completed todos.
  ///
  /// Returns the number of deleted todos.
  Future<int> clearCompleted();

  /// Sets the `isCompleted` state of all todos to the given value.
  ///
  /// Returns the number of updated todos.
  Future<int> completeAll({required bool isCompleted});
}

/// Error thrown when a [Todoo] with a given id is not found.
class TodoNotFoundException implements Exception {}

///Stream vs Future
///
///In a previous version of this tutorial, the TodosApi was Future-based rather than Stream-based.
/// For an example of a Future-based API see Brian Egan's implementation in his Architecture Samples.
/// A Future-based implementation could consist of two methods: loadTodos and saveTodos (note the plural). This means, a full list of todos must be provided to the method each time.
/// One limitation of this approach is that the standard CRUD (Create, Read, Update, and Delete) operation requires sending the full list of todos with each call. For example, on an Add Todoo screen, one cannot just send the added todoo item. Instead, we must keep track of the entire list and provide the entire new list of todos when persisting the updated list.
/// A second limitation is that loadTodos is a one-time delivery of data. The app must contain logic to ask for updates periodically.
/// In the current implementation, the TodosApi exposes a Stream<List<Todoo>> via getTodos() which will report real-time updates to all subscribers when the list of todos has changed.
/// In addition, todos can be created, deleted, or updated individually. For example, both deleting and saving a todoo are done with only the todoo as the argument. It's not necessary to provide the newly updated list of todos each time.
