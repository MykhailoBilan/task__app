import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:task_app/task_model/model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc()
      : super(
          TaskInitial(),
        ) {
    on<TaskAdd>((event, emit) {
      emit(TaskLoading());
      try {
        Box<TaskModel> task = Hive.box<TaskModel>("TaskBox");
        task.add(TaskModel(
            task: event.task.task,
            definition: event.task.definition,
            category: event.task.category,
            isComplete: event.task.isComplete));
        emit(TaskSuccess(task));
      } catch (e) {
        emit(TaskFailure());
      }
    });

    on<TaskChangeIsCompleteEvent>((event, emit) {
      event.box.getAt(event.index)!.isComplete =
          !event.box.getAt(event.index)!.isComplete;
      event.box.putAt(event.index, event.box.getAt(event.index)!);
      emit(TaskSuccess(event.box));
    });

    on<TaskRemove>(
      (event, emit) {
        event.box.deleteAt(event.index);
        emit(TaskSuccess(event.box));
      },
    );

    on<TaskLoad>((event, emit) {
      emit(TaskLoading());
      try {
        Box<TaskModel> taskBox = Hive.box<TaskModel>('TaskBox');
        emit(TaskSuccess(taskBox));
      } catch (e) {
        emit(TaskFailure());
      }
    });

    on<TaskFilterEvent>((event, emit) {
      emit(TaskLoading());
      try {
        bool? isComplete;
        if (event.isComplete == 'Complete') {
          isComplete = true;
        } else {
          if (event.isComplete == 'Incomplete') {
            isComplete = false;
          }
        }
        Box<TaskModel> filtered = Hive.box('FilteredBox1');
        var filter =
            event.box.values.where((value) => value.category == event.category);
        filtered.addAll(filter.toList());
        Box<TaskModel> filteredCategoryBox = filtered;
        var filterFinal =
            filtered.values.where((value) => value.isComplete == isComplete);
        Box<TaskModel> filteredFinal = Hive.box('FilteredBox2');
        filteredFinal.addAll(filterFinal.toList());
        emit(TaskSuccess(filteredFinal));
        filtered.clear();
        filteredFinal.clear();
      } catch (e) {
        emit(TaskFailure());
      }
    });
    on<TaskRemoveAllFilters>((event, emit) => emit(TaskSuccess(event.box)));
  }
}
