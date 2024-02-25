part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

class TaskSuccess extends TaskState {
  Box<TaskModel> box;
  TaskSuccess(this.box);
}

class TaskChangedIsCompleteState extends TaskState {
  Box<TaskModel> box;
  bool changed;
  int index;
  TaskChangedIsCompleteState(this.box, this.changed, this.index);
}

class TaskFailure extends TaskState {}

class TaskLoading extends TaskState {}
