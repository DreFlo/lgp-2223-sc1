import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';

class DashboardTask {
  final Task task;
  final String subject;
  final String institution;

  DashboardTask(this.task, [this.subject = "", this.institution = ""]);
}

class DashboardTaskGroup {
  final TaskGroup taskGroup;
  final String subject;
  final String institution;
  final int nTasks;

  DashboardTaskGroup(this.taskGroup,
      [this.nTasks = 0, this.subject = "", this.institution = ""]);
}

class DashboardEvent {
  final TimeslotMediaTimeslotSuperEntity event;
  final String type;

  DashboardEvent(this.event, [this.type = ""]);
}
