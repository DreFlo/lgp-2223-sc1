import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class MyOutlinedButton extends StatefulWidget {
  final void Function() onPressed;
  final String title;

  const MyOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  State<MyOutlinedButton> createState() => _MyOutlinedButtonState();
}

class _MyOutlinedButtonState extends State<MyOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          widget.onPressed();
        },
        style: OutlinedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 55),
          backgroundColor: appBackground,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(widget.title,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: primaryColor)));
  }
}
