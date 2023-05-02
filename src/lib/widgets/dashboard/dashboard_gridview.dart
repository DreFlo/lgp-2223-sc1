import 'package:flutter/material.dart';
import 'package:src/widgets/dashboard/dashboard_card.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';

class DashBoardGridView extends StatefulWidget {
  final List<Task>? tasks; //student
  final List<TaskGroup>? taskGroups; //student
  final List<TimeslotMediaTimeslotSuperEntity>? mediaEvents; //media

  const DashBoardGridView(
      {Key? key, this.tasks, this.taskGroups, this.mediaEvents})
      : super(key: key);

  @override
  State<DashBoardGridView> createState() => _DashBoardGridViewState();
}

class _DashBoardGridViewState extends State<DashBoardGridView> {
  late List<Task> tasks;
  late List<TaskGroup> taskGroups;
  late List<TimeslotMediaTimeslotSuperEntity> mediaEvents;
  List get items {
    final List combined = [];
    combined.addAll(tasks);
    combined.addAll(taskGroups);
    combined.addAll(mediaEvents);

    return combined;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tasks = widget.tasks ?? [];
    taskGroups = widget.taskGroups ?? [];
    mediaEvents = widget.mediaEvents ?? [];
  }

  int getLength() {
    // sum of lengths of all lists
    return tasks.length + taskGroups.length + mediaEvents.length;
  }

  showCard(int index) {
    if (tasks.isNotEmpty && items[index] is Task) {
      return DashboardCard(
        module: 'Student',
        task: items[index],
        deleteCallback: deleteTask(items[index]),
      );
    } else if (taskGroups.isNotEmpty && items[index] is TaskGroup) {
      return DashboardCard(
        module: 'Student',
        taskGroup: items[index],
        deleteCallback: deleteTaskGroup(items[index]),
      );
    } else if (mediaEvents.isNotEmpty &&
        items[index] is TimeslotMediaTimeslotSuperEntity) {
      return DashboardCard(
        module: 'Leisure',
        mediaEvent: items[index],
        deleteCallback: deleteMediaEvent(items[index]),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 23, right: 23),
        child: GridView.builder(
          itemCount: getLength(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.81,
          ),
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 5), () {}),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return showCard(index);
                }
              },
            );
          },
        ));
  }

  deleteTask(Task oldTask) {
    return () {
      setState(() {
        tasks.remove(oldTask);
      });
    };
  }

  deleteTaskGroup(TaskGroup oldTaskGroup) {
    return () {
      setState(() {
        taskGroups.remove(oldTaskGroup);
      });
    };
  }

  deleteMediaEvent(TimeslotMediaTimeslotSuperEntity oldMediaEvent) {
    return () {
      setState(() {
        mediaEvents.remove(oldMediaEvent);
      });
    };
  }
}
