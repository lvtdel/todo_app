import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/mode.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late final DBHelper dbHelper;

  TodoBloc() : super(TodoInitial()) {
    dbHelper = DBHelper();

    on<LoadTodoEvent>(_onFetchTodo);
    on<AddTodoEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  _onFetchTodo(LoadTodoEvent event, emit) async {
    try {
      emit(TodoLoading());
      final todo = await dbHelper.getTodo(event.id);
      emit(TodoLoadedState(todoModel: todo));
    } catch (e) {
      print("Load todo error!");
      print(e);
    }
  }

  _onUpdateTodo(UpdateTodoEvent event, emit) async {
    dbHelper.update(event.todoModel);
  }
}
