import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditDescription extends StatefulWidget {
  final TextEditingController descriptionController;

  const EditDescription(
      {Key? key, required this.descriptionController})
      : super(key: key);

  @override
  State<EditDescription> createState() => _EditTitleState();
}

class _EditTitleState extends State<EditDescription> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppLocalizations.of(context).description,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF71788D),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
          const SizedBox(height: 7.5),
          Flexible(
              flex: 1,
              child: TextField(
                controller: widget.descriptionController,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF17181C),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 5,
              ))
        ]));
  }
}
