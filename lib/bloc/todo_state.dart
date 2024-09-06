part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoLoadedState extends TodoState {
  final TodoModel todoModel;

  TodoLoadedState({required this.todoModel});
}