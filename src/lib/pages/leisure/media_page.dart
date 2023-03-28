import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/utils/service_locator.dart';

class MyMediaPage extends StatelessWidget {
  final String title, synopsis, type;
  final List<String> tags, notes, data;

  const MyMediaPage(
      {Key? key,
      required this.title,
      required this.synopsis,
      required this.tags,
      required this.notes,
      required this.data,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      child: Row(
        children: [
          Stack(clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topCenter, children: [
            Positioned(
                top: 20,
                child: Container(
                  width: 115,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:Color(0xFF414554),
                  ),
                  child: Text(this.type.toUpperCase(), style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.01, 0.5, 0.9],
                    colors: [
                      Color(0xFF22252D),
                      Colors.transparent,
                      Color(0xFF22252D)
                    ],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstOut,
                child: Image.asset(
                  'assets/images/poster.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(this.title,
            style: TextStyle(color: Colors.white, fontSize: l))
          ]),
        ],
      ),
    );
  }
}
