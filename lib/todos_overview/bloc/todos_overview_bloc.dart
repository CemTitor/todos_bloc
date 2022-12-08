import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_bloc/todos_overview/todos_overview.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

///The bloc does not create an instance of the TodosRepository internally. Instead, it relies on an instance of the repository to be injected via constructor.(Bloc, dahili olarak TodosRepository'nin bir örneğini oluşturmaz. Bunun yerine, constructor yoluyla enjekte edilecek bir repository örneğine dayanır.)
class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodosOverviewTodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodosOverviewTodoDeleted>(_onTodoDeleted);
    on<TodosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TodosOverviewFilterChanged>(_onFilterChanged);
    on<TodosOverviewToggleAllRequested>(_onToggleAllRequested);
    on<TodosOverviewClearCompletedRequested>(_onClearCompletedRequested);
  }
  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    ///When TodosOverviewSubscriptionRequested is added, the bloc starts by emitting a loading state. In response, the UI can then render a loading indicator.
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));

    ///Creates a subscription on the todos stream from the TodosRepository.
    ///emit.forEach() is not the same forEach() used by lists. This forEach enables the bloc to subscribe to a Stream and emit a new state for each update from the stream.
    ///stream.listen is never called directly in this tutorial. Using await emit.forEach() is a newer pattern for subscribing to a stream which allows the bloc to MANAGE the subscription INTERNALLY.
    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosOverviewStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodosOverviewStatus.failure,
      ),
    );
  }

  ///emit is never called from within onTodoCompletionToggled(onTodoSaved) and many other event handlers. Instead, they notify the repository which emits an updated list via the todos stream. See the data flow section for more information.
  Future<void> _onTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  ///_onTodoDeleted does two things.
  Future<void> _onTodoDeleted(
    TodosOverviewTodoDeleted event,
    Emitter<TodosOverviewState> emit,
  ) async {
    ///First, it emits a new state with the Todoo to be deleted.
    emit(state.copyWith(lastDeletedTodo: () => event.todo));

    ///Then, it deletes the Todoo via a call to the repository
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
    TodosOverviewUndoDeletionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    ///Temporarily saves a copy of the last deleted todoo.
    final todo = state.lastDeletedTodo!;

    /// Updates the state by removing the lastDeletedTodo.
    emit(state.copyWith(lastDeletedTodo: () => null));

    /// Reverts the deletion.
    await _todosRepository.saveTodo(todo);
  }

  ///_onFilterChanged emits a new state with the new event filter.
  void _onFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodosOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    TodosOverviewToggleAllRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
    TodosOverviewClearCompletedRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    await _todosRepository.clearCompleted();
  }
}
