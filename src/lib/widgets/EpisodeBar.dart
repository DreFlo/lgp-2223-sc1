import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class EpisodeBar extends StatelessWidget {
  final String code, title;

  EpisodeBar({Key? key, required this.code, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Container(
        color: lightGray,
        height: 65,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Text(code,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600))
        ]));
  }
}
