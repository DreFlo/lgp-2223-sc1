import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class PasswordRecovPage extends StatelessWidget {
  PasswordRecovPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text("Pass Recov Page!",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
