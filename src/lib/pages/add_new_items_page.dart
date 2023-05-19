import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:src/pages/events/event_form.dart';
import 'package:src/pages/tasks/institution_form.dart';
import 'package:src/pages/tasks/project_form.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/pages/timer/timer_form.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewItemsPage extends StatefulWidget {
  const AddNewItemsPage({Key? key}) : super(key: key);

  @override
  State<AddNewItemsPage> createState() => _AddNewItemsPageState();
}

class _AddNewItemsPageState extends State<AddNewItemsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[primaryColor.withOpacity(0.85), primaryColor.withOpacity(0)], begin: AlignmentDirectional.bottomCenter, end: AlignmentDirectional.topCenter)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: getFirstColumnButtons(),
              ),
              Column(
                children: getSecondColumnButtons(),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          )
        ],
      ),
    );
  }

  List<Widget> getFirstColumnButtons() {
    List<Widget> result = [];

    result.add(
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color(0xFF22252D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.70,
                    minChildSize: 0.70,
                    maxChildSize: 0.75,
                    builder: (context, scrollController) => SubjectForm(
                      scrollController: scrollController,
                    ),
                  )));
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 55),
          backgroundColor: grayButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.subject_rounded, color: Colors.white, size: 25.0),
            Text(AppLocalizations.of(context).subject),
          ],
          ),
      ),
    );

    result.add(Divider(height: 10.0,));

    result.add(
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color(0xFF22252D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    child: DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.9,
                        minChildSize: 0.9,
                        maxChildSize: 0.9,
                        builder: (context, scrollController) => EventForm(
                              scrollController: scrollController,
                              // id: 2,
                              // type: "student",
                              // OR (1, leisure)
                            )),
                  ));
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 55),
          backgroundColor: grayButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.event, color: Colors.white, size: 25.0),
            Text(AppLocalizations.of(context).event),
          ],
          ),
      ),
    );

    result.add(Divider(height: 10.0,));

    result.add(
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color(0xFF22252D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                    child: DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.80,
                        minChildSize: 0.80,
                        maxChildSize: 0.85,
                        builder: (context, scrollController) => TaskForm(
                            scrollController: scrollController, id: 1)),
                  ));
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 55),
          backgroundColor: grayButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.task, color: Colors.white, size: 25.0),
            Text(AppLocalizations.of(context).task),
          ],
          ),
      ),
    );

    return result;
  }

  List<Widget> getSecondColumnButtons() {
    List<Widget> result = [];

    result.add(ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Color(0xFF22252D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            ),
            builder: (context) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 0.70,
                  builder: (context, scrollController) => InstitutionForm(
                    scrollController: scrollController,
                  ),
                )));
      },
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 55),
          backgroundColor: grayButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.account_balance_rounded, color: Colors.white, size: 25.0),
            Text(AppLocalizations.of(context).institution),
          ],
          ),
    ));

    result.add(Divider(height: 10.0,));

    result.add(
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color(0xFF22252D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.75,
                  minChildSize: 0.75,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) =>
                      ProjectForm(scrollController: scrollController, id: 1)));
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 55),
          backgroundColor: grayButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.list_rounded, color: Colors.white, size: 25.0),
            Text(AppLocalizations.of(context).project),
          ],
          ),
      ),
    );

    result.add(Divider(height: 10.0,));

    result.add(
      ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color(0xFF22252D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.6,
                    minChildSize: 0.6,
                    maxChildSize: 0.6,
                    builder: (context, scrollController) => TimerForm(
                      scrollController: scrollController,
                    ),
                  )));
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 55),
          backgroundColor: grayButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.access_time_rounded, color: Colors.white, size: 25.0),
            Text(AppLocalizations.of(context).timer_short),
          ],
          ),
      ),
    );

    return result;
  }
}
