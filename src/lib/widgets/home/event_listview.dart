import 'package:flutter/material.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

import 'package:src/widgets/home/event_card.dart';

class MyEventListView extends StatefulWidget {
  final List<TimeslotMediaTimeslotSuperEntity?>? mediaEvents;
  final List<TimeslotStudentTimeslotSuperEntity?>? studentEvents;
  final Function() callback;

  const MyEventListView(
      {Key? key, this.mediaEvents, this.studentEvents, required this.callback})
      : super(key: key);

  @override
  State<MyEventListView> createState() => _MyEventListViewState();
}

class _MyEventListViewState extends State<MyEventListView> {
  int startDateTimeComparator(TimeslotStudentTimeslotSuperEntity a,
          TimeslotMediaTimeslotSuperEntity b) =>
      a.startDateTime.compareTo(b.startDateTime);

  List get items {
    final List combined = [];
    if (widget.mediaEvents != null) {
      combined.addAll(widget.mediaEvents!);
    }
    if (widget.studentEvents != null) {
      combined.addAll(widget.studentEvents!);
    }

    // Sort events by startDateTime
    combined.sort((a, b) {
      if (a is TimeslotStudentTimeslotSuperEntity &&
          b is TimeslotStudentTimeslotSuperEntity) {
        return a.startDateTime.compareTo(b.startDateTime);
      } else if (a is TimeslotMediaTimeslotSuperEntity &&
          b is TimeslotMediaTimeslotSuperEntity) {
        return a.startDateTime.compareTo(b.startDateTime);
      } else if (a is TimeslotMediaTimeslotSuperEntity &&
          b is TimeslotStudentTimeslotSuperEntity) {
        return a.startDateTime.compareTo(b.startDateTime);
      } else if (a is TimeslotStudentTimeslotSuperEntity &&
          b is TimeslotMediaTimeslotSuperEntity) {
        return a.startDateTime.compareTo(b.startDateTime);
      }
      return 0;
    });

    return combined;
  }

  showCard(Object? item) {
    if (widget.studentEvents != null &&
        item is TimeslotStudentTimeslotSuperEntity) {
      return MyEventCard(
        module: 'Student',
        studentEvent: item,
        callback: widget.callback,
      );
    } else if (widget.mediaEvents != null &&
        item is TimeslotMediaTimeslotSuperEntity) {
      return MyEventCard(
        module: 'Leisure',
        mediaEvent: item,
        callback: widget.callback,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Expanded(
            child: Column(
          children: [
            for (var item in items) showCard(item),
          ],
        )));
  }
}
