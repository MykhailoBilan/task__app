import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_app/blocs/task_bloc/task_bloc.dart';
import 'package:task_app/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/task_model/model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/pages/weather_page.dart';
import 'blocs/weather_bloc/weather_bloc.dart';

void main() async {
  await Hive.initFlutter();
  Bloc.observer = AppBlocObserver();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>("TaskBox");
  await Hive.openBox<TaskModel>("FilteredBox1");
  await Hive.openBox<TaskModel>("FilteredBox2");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => TaskBloc(),
      ),
      BlocProvider(
        create: (context) => WeatherBloc(),
      )
    ],
    child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
  ));
}

class AppBlocObserver extends BlocObserver {
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List pages = [HomePage(), WeatherPage()];
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather')
          ],
          currentIndex: selectedPage,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          }),
    );
  }
}
