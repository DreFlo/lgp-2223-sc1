import 'package:flutter/material.dart';
import 'package:src/pages/home/my_horizontal_scrollview.dart';
import 'package:src/pages/home/my_profile_pic.dart';
import 'package:src/pages/home/my_task_listview.dart';
import 'package:src/pages/home/my_welcome_message.dart';

import '../../models/student/task.dart';
import '../../utils/enums.dart';
import 'my_badge_placeholder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String name = "Joaquim Almeida"; // TODO Get name from database

  // TODO - get tasks from database
  // TODO - change logic when we have events (leisure) - for now everything is tasks and description is being used to distinguish between modules
  List<Task> items = [
    Task(
        id: 1,
        name: 'Ginásio',
        description: 'Student',
        deadline: DateTime(2023, 3, 31, 5),
        priority: Priority.high,
        taskGroupId: 1),
    Task(
        id: 1,
        name: 'Kirby & The Forgotten Land',
        description: 'Leisure',
        deadline: DateTime(2023, 4, 3, 10),
        priority: Priority.medium,
        taskGroupId: 1),
    Task(
        id: 1,
        name: 'Caminhar',
        description: 'Personal',
        deadline: DateTime(2023, 4, 4, 5),
        priority: Priority.low,
        taskGroupId: 1),
    Task(
        id: 1,
        name: 'Treino 5 Minutos',
        description: 'Fitness',
        deadline: DateTime(2023, 4, 5, 8),
        priority: Priority.high,
        taskGroupId: 1),
  ];

  List<Task> filterItems() {
    switch (_selectedIndex) {
      case 1:
        return items.where((element) => element.description == 'Student').toList();
      case 2:
        return items.where((element) => element.description == 'Leisure').toList();
      case 3:
        return items.where((element) => element.description == 'Fitness').toList();
      case 4:
        return items.where((element) => element.description == 'Personal').toList();
      default:
        return items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 36, top: 36),
            child: MyProfilePic()
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 36, top: 90),
                  child: MyWelcomeMessage(name: name)),
              const MyBadgePlaceholder(),
              MyHorizontalScrollView(
                selectedIndex: _selectedIndex,
                setSelectedIndex: (int index) =>
                    setState(() => _selectedIndex = index),
              ),
              SizedBox(
                height: 215,
                child: MyTaskListView(items: filterItems()),
              )
            ],
          ),
        ],
      ),
    );
  }
}
