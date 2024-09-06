part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class LoadTodoEvent extends TodoEvent {
  final int id;

  LoadTodoEvent({required this.id});
}

class AddTodoEvent extends TodoEvent {
  late final TodoModel todoModel;

  AddTodoEvent({required String title, required String desc}) {
    todoModel = TodoModel(
        title: title,
        desc: desc,
        dateAndTime: DateFormat('yMd').add_jm().format(DateTime.now()));
  }
}

class UpdateTodoEvent extends TodoEvent {
  late final TodoModel todoModel;

  UpdateTodoEvent(
      {required int id, required String title, required String desc, required dateAndTime}) {
    todoModel = TodoModel(id: id, title: title, desc: desc, dateAndTime: dateAndTime);
  }
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  DeleteTodoEvent({required this.id});
}
