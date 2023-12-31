import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class ActivityBarShow extends StatefulWidget {
  final String title;
  final String description;

  const ActivityBarShow(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<ActivityBarShow> createState() => _ActivityBarShowState();
}

class _ActivityBarShowState extends State<ActivityBarShow> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 10),
        child: InkWell(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: lightGray),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(widget.title,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600))),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(widget.description,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 127, 127, 127),
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                )
              ])
            ]),
          ]),
        )));
  }
}
