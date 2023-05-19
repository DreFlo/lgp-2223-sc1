import 'package:flutter/material.dart';
import 'package:src/pages/events/event_form.dart';
import 'package:src/pages/tasks/institution_form.dart';
import 'package:src/pages/tasks/project_form.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/pages/timer/timer_form.dart';
import 'package:src/themes/colors.dart';

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
      color: primaryColor.withOpacity(0.65),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: getFirstColumnButtons()
            ,
          ),
          Column(
            children: getSecondColumnButtons()
            ,
          )
        ],
      ),
    );
  }
  
  List<ElevatedButton> getFirstColumnButtons() {
    List<ElevatedButton> result = [];
          
            result.add(ElevatedButton(
                child: Text("Subject"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.70,
                            minChildSize: 0.70,
                            maxChildSize: 0.75,
                            builder: (context, scrollController) => SubjectForm(
                              scrollController: scrollController,
                            ),
                          )));
                }),);
            result.add(ElevatedButton(
                child: Text("Event"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            child: DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.9,
                                minChildSize: 0.9,
                                maxChildSize: 0.9,
                                builder: (context, scrollController) =>
                                    EventForm(
                                      scrollController: scrollController,
                                      // id: 2,
                                      // type: "student",
                                      // OR (1, leisure)
                                    )),
                          ));
                }),);

                result.add(ElevatedButton(
                child: Text("Task"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        30),
                            child: DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.80,
                                minChildSize: 0.80,
                                maxChildSize: 0.85,
                                builder: (context, scrollController) =>
                                    TaskForm(
                                        scrollController: scrollController,
                                        id: 1)),
                          ));
                }),);
            

    return result;
  }
  
  List<ElevatedButton> getSecondColumnButtons() {
    List<ElevatedButton> result = [];

    result.add(
      ElevatedButton(
                child: Text("Institution"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  30),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.65,
                            minChildSize: 0.65,
                            maxChildSize: 0.70,
                            builder: (context, scrollController) =>
                                InstitutionForm(
                              scrollController: scrollController,
                            ),
                          )));
                })
      );

      result.add(ElevatedButton(
                child: Text("Project"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.75,
                          minChildSize: 0.75,
                          maxChildSize: 0.75,
                          builder: (context, scrollController) => ProjectForm(
                              scrollController: scrollController, id: 1)));
                }),
        );

      result.add(ElevatedButton(
                child: Text("Timer"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  30),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.6,
                            minChildSize: 0.6,
                            maxChildSize: 0.6,
                            builder: (context, scrollController) => TimerForm(
                              scrollController: scrollController,
                            ),
                          )));
                }),
      );

    return result;
  }


}