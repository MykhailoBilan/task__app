import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  String task;
  @HiveField(1)
  String definition;
  @HiveField(2)
  String category;
  @HiveField(3)
  bool isComplete;

  TaskModel(
      {required this.task,
      required this.definition,
      required this.category,
      required this.isComplete});
}
