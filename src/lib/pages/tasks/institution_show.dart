import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/pages/tasks/institution_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/subject_bar_show.dart';

class InstitutionShow extends StatefulWidget {
  final int id;
  final ScrollController scrollController;

  const InstitutionShow(
      {Key? key, required this.scrollController, required this.id})
      : super(key: key);

  @override
  State<InstitutionShow> createState() => _InstitutionShowState();
}

class _InstitutionShowState extends State<InstitutionShow> {
  late String name, type;
  late List<Subject> subjects;

  bool init = false;

  @override
  initState() {
    super.initState();
  }

  Future<int> fillInstitutionFields() async {
    if (init) {
      return 0;
    }

    Institution? institution = await serviceLocator<InstitutionDao>()
        .findInstitutionById(widget.id)
        .first;

    name = institution!.name;

    if (context.mounted) {
      if (institution.type == InstitutionType.work) {
        type = AppLocalizations.of(context).work;
      } else if (institution.type == InstitutionType.other) {
        type = AppLocalizations.of(context).other;
      } else if (institution.type == InstitutionType.education) {
        type = AppLocalizations.of(context).education;
      }
    }

    subjects = await serviceLocator<SubjectDao>()
        .findSubjectByInstitutionId(widget.id);

    init = true;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fillInstitutionFields(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Wrap(spacing: 10, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            width: 115,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF414554),
                            ),
                          ))
                    ]),
                    Row(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xFF17181C),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10)),
                          child: Wrap(children: [
                            Row(children: [
                              const Icon(Icons.account_balance_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(AppLocalizations.of(context).institution,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ])
                          ]))
                    ]),
                    const SizedBox(height: 15),
                    Row(children: [
                      Text(
                        AppLocalizations.of(context).name,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF71788D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ]),
                    const SizedBox(height: 7.5),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 10,
                              child: Text(name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)))
                        ]),
                    const SizedBox(height: 30),
                    Row(children: [
                      Text(
                        AppLocalizations.of(context).type,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF71788D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ]),
                    const SizedBox(height: 7.5),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 10,
                              child: Text(type,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)))
                        ]),
                    const SizedBox(height: 30),
                    Row(children: [
                      Text(
                        AppLocalizations.of(context).subjects,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF71788D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ]),
                    const SizedBox(height: 7.5),
                    displaySubjects(),
                    const SizedBox(height: 30),
                    displayEndButtons(),
                  ]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget displaySubjects() {
    if (subjects.isEmpty) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(AppLocalizations.of(context).no_subjects,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)));
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: subjects
              .map((e) => SubjectBarShow(
                    subject: e,
                  ))
              .toList());
    }
  }

  Widget displayEndButtons() {
    return ElevatedButton(
        key: const Key('editInstitutionButton'),
        onPressed: () async {
          await edit();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(AppLocalizations.of(context).edit,
            style: Theme.of(context).textTheme.headlineSmall));
  }

  edit() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF22252D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        builder: (context) => Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 50),
            child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.75,
                minChildSize: 0.75,
                maxChildSize: 0.75,
                builder: (context, scrollController) => InstitutionForm(
                      scrollController: scrollController,
                      id: widget.id,
                      callback: onEdit,
                    ))));
  }

  onEdit() {
    setState(() {
      init = false;
    });
  }
}
