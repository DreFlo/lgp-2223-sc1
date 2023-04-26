import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/pages/events/choose_activity_form.dart';
import 'package:src/utils/formatters.dart';
import 'package:src/utils/service_locator.dart';

import 'activities_list.dart';

class TasksList extends ActivitiesList {
  const TasksList(
      {super.key,
      required super.activities,
      required super.addActivity,
      required super.removeActivity,
      required super.errors});

  @override
  Future<List<ChooseActivity>> getActivities() async {
    // TODO(events): and filter only the tasks from the user logged in
    List<ChooseActivity> tasksActivities = [];
    List<Task> tasks = await serviceLocator<TaskDao>()
        .findTasksActivities(DateTime.now().millisecondsSinceEpoch);

    for (Task t in tasks) {
      if (activities.every((element) => element.id != t.id)) {
        tasksActivities.add(ChooseActivity(
          id: t.id!,
          title: t.name,
          description: '(${formatDeadline(t.deadline)}) ${t.description}',
          isSelected: false,
        ));
      }
    }

    return tasksActivities;
  }

  @override
  ChooseActivityForm getChooseActivityForm(
    BuildContext context,
    ScrollController scrollController,
    List<ChooseActivity> snapshot,
  ) {
    return ChooseActivityForm(
      title: AppLocalizations.of(context).choose_tasks,
      noActivitiesMsg: AppLocalizations.of(context).no_tasks,
      icon: Icons.task_rounded,
      scrollController: scrollController,
      activities: snapshot,
      addActivityCallback: addActivity,
    );
  }
}
