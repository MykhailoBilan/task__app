part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class TaskAdd extends TaskEvent {
  TaskModel task;
  TaskAdd(this.task);
}

class TaskChangeIsCompleteEvent extends TaskEvent {
  Box<TaskModel> box;
  bool isComplete;
  int index;
  TaskChangeIsCompleteEvent(this.box, this.isComplete, this.index);
}

class TaskRemove extends TaskEvent {
  Box<TaskModel> box;
  int index;
  TaskRemove(this.box, this.index);
}

class TaskLoad extends TaskEvent {}

class TaskFilterEvent extends TaskEvent {
  Box<TaskModel> box;
  String category;
  String isComplete;
  TaskFilterEvent(this.box, this.category, this.isComplete);
}

class TaskRemoveAllFilters extends TaskEvent {
  Box<TaskModel> box;
  TaskRemoveAllFilters(this.box);
}
