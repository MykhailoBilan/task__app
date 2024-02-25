import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_app/blocs/task_bloc/task_bloc.dart';
import 'package:task_app/task_model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textControllerTask = TextEditingController();
  TextEditingController textControllerDefinition = TextEditingController();
  TextEditingController textControllerCategory = TextEditingController();
  String selectedCategory = '';
  List<String> categories = ['Work', 'Personal', 'Hot'];
  String isComplete = '';
  List<String> isCompleteList = ['Complete', 'Incomplete'];

  @override
  void dispose() {
    textControllerTask.clear();
    textControllerDefinition.clear();
    textControllerCategory.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.isNotEmpty ? categories.first : '';
    isComplete = isCompleteList.isNotEmpty ? isCompleteList.first : '';
    context.read<TaskBloc>()..add(TaskLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TaskApp")),
      body: Center(
        child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
          if (state is TaskSuccess) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            selectedCategory = newValue!;
                          },
                        );
                      },
                    ),
                    DropdownButton<String>(
                      value: isComplete,
                      items: isCompleteList.map((String isComplete) {
                        return DropdownMenuItem<String>(
                          value: isComplete ?? '',
                          child: Text(isComplete),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            isComplete = newValue!;
                          },
                        );
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          context.read<TaskBloc>()
                            ..add(TaskFilterEvent(Hive.box('TaskBox'),
                                selectedCategory, isComplete));
                        },
                        icon: Icon(Icons.filter_alt_rounded)),
                    IconButton(
                        onPressed: () => context.read<TaskBloc>()
                          ..add(TaskRemoveAllFilters(Hive.box('TaskBox'))),
                        icon: Icon(Icons.clear))
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.box.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        leading: Text(
                          state.box.getAt(index)!.category,
                          style: TextStyle(fontSize: 18),
                        ),
                        title: Text(
                          state.box.getAt(index)!.task,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          state.box.getAt(index)!.definition,
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  context.read<TaskBloc>()
                                    ..add(TaskRemove(state.box, index));
                                },
                                icon: Icon(
                                  color: Colors.blue,
                                  Icons.delete,
                                )),
                            Checkbox(
                              value: state.box.getAt(index)!.isComplete,
                              onChanged: (value) => context.read<TaskBloc>()
                                ..add(
                                  TaskChangeIsCompleteEvent(
                                      state.box, value!, index),
                                ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("List is empty"),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: [
                      TextField(
                        controller: textControllerTask,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Task"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: textControllerDefinition,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: textControllerCategory,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Category"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>()
                        ..add(TaskAdd(TaskModel(
                            task: textControllerTask.text,
                            definition: textControllerDefinition.text,
                            category: textControllerCategory.text,
                            isComplete: false)));
                      textControllerCategory.text = "";
                      textControllerDefinition.text = "";
                      textControllerTask.text = "";

                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"))
                ],
              );
            },
          );
        },
      ),
    );
  }
}
