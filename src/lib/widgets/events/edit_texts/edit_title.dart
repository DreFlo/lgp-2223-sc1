import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class EditTitle extends StatefulWidget {
  final TextEditingController titleController;
  final Map<String, String> errors;

  const EditTitle(
      {Key? key, required this.titleController, required this.errors})
      : super(key: key);

  @override
  State<EditTitle> createState() => _EditTitleState();
}

class _EditTitleState extends State<EditTitle> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 11,
        child: Row(children: [
          Flexible(
              flex: 10,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                        controller: widget.titleController,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grayBackground)),
                          hintText: AppLocalizations.of(context).title,
                          hintStyle: const TextStyle(
                              fontSize: 20,
                              color: grayText,
                              fontWeight: FontWeight.w400),
                        )),
                    widget.errors.containsKey('title')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                            child: Text(widget.errors['title']!,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)))
                        : const SizedBox(height: 0),
                  ])),
          const SizedBox(width: 5),
          Flexible(
              flex: 1,
              child: IconButton(
                  color: Colors.white,
                  splashRadius: 0.01,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.titleController.clear();
                  }))
        ]));
  }
}
