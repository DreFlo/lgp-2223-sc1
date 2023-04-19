import 'package:flutter/material.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

import 'event_card.dart';

class MyEventListView extends StatefulWidget {
  final List<TimeslotMediaTimeslotSuperEntity?>? mediaEvents;
  final List<TimeslotStudentTimeslotSuperEntity?>? studentEvents;

  const MyEventListView({Key? key, this.mediaEvents, this.studentEvents})
      : super(key: key);

  @override
  State<MyEventListView> createState() => _MyEventListViewState();
}

class _MyEventListViewState extends State<MyEventListView> {
  List<dynamic> get items {
    final List<dynamic> combined = [];
    if (widget.mediaEvents != null) {
      combined.addAll(widget.mediaEvents!);
    }
    if (widget.studentEvents != null) {
      combined.addAll(widget.studentEvents!);
    }
    return combined;
  }

  showCard(dynamic item) {
    if (widget.studentEvents != null &&
       item is TimeslotStudentTimeslotSuperEntity) {
      return MyEventCard(module: 'Student', studentEvent: item);
    } else if (widget.mediaEvents != null &&
        item is TimeslotMediaTimeslotSuperEntity) {
      return MyEventCard(module: 'Leisure', mediaEvent: item);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            for (var item in items)
              showCard(item),
          ],
        ));
  }
}
