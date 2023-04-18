import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/daos/student/subject_dao.dart';

class DashboardCard extends StatefulWidget {
  final Task? task; //student
  final TaskGroup? taskGroup; //student
  final TimeslotMediaTimeslotSuperEntity? mediaEvent; //media
  final String module;

  const DashboardCard(
      {Key? key,
      required this.module,
      this.task,
      this.taskGroup,
      this.mediaEvent})
      : super(key: key);

//nTasks and institution can be added I guess? Only for student
//Possible to check what's the type of media for media events?

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  final Map<String, Color> moduleColors = {
    'Student': studentColor,
    'Leisure': leisureColor,
    'Personal': personalColor,
    'Fitness': fitnessColor,
  };
  String subjectOrDate = '';

  @override
  void initState() {
    super.initState();
    getSubjectOrDate().then((value) => setState(() {
      subjectOrDate = value;
    }));
  }

  String getTitle() {
    if (widget.task != null) {
      return widget.task!.name;
    } else if (widget.taskGroup != null) {
      return widget.taskGroup!.name;
    } else if (widget.mediaEvent != null) {
      return widget.mediaEvent!.title;
    } else {
      return '';
    }
  }

  Future<String> getSubjectOrDate() async{
    if (widget.task != null) {
      return await loadSubject();
    } else if (widget.taskGroup != null) {
      return await loadSubject();
    } else if (widget.mediaEvent != null) {
      String startDate = "${widget.mediaEvent!.startDateTime.day.toString()}/${widget.mediaEvent!.startDateTime.month.toString()}";
      String endDate = "${widget.mediaEvent!.endDateTime.day.toString()}/${widget.mediaEvent!.endDateTime.month.toString()}";
      return "$startDate-$endDate";
    } else {
      return '';
    }
  }

  Future<String> loadSubject() async {
    int? id;
    if (widget.task != null) {
      id = widget.task?.subjectId;
    } //else if (widget.taskGroup != null) {
      //id = widget.taskGroup?.subjectId; //when student-backend is merged with this branch
    //}
    if(id != null){
      final subjectStream = serviceLocator<SubjectDao>().findSubjectById(id!);
      Subject? firstNonNullSubject = await subjectStream.firstWhere((subject) => subject != null, orElse: () => null);
      return firstNonNullSubject?.name ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // TODO: Navigate to project page
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: grayButton,
            ),
            child: Container(
                margin: const EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(bottom: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: moduleColors[widget.module],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          child: Text(
                            getTitle(),
                            style: Theme.of(context).textTheme.labelLarge,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*widget.institution != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: grayBackground,
                                      ),
                                      child: Text(
                                        widget.institution,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                              color:
                                                  moduleColors[widget.module],
                                            ),
                                      ),
                                    )
                                  :*/
                              Container(),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: grayBackground,
                                ),
                                child: Text(
                                  subjectOrDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        color: moduleColors[widget.module],
                                      ),
                                ),
                              ),
                            ],
                          ),
                          /*widget.nTasks != 0
                              ? Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                      child: Text(widget.nTasks.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge)),
                                )
                              :*/
                          Container(),
                        ],
                      )
                    ]))));
  }
}
