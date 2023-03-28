import 'dart:ui';
import 'package:image_gradient/image_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/utils/service_locator.dart';

class MyMediaPage extends StatelessWidget {
  final String title, synopsis;
  final List<String> tags, notes, data;

  const MyMediaPage(
      {Key? key,
      required this.title,
      required this.synopsis,
      required this.tags,
      required this.notes,
      required this.data})
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
    return DraggableScrollableSheet(
        minChildSize: 0.5,
        maxChildSize: 0.7,
        initialChildSize: 0.5,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.325,
                    width: MediaQuery.of(context).size.width,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF22252D), Colors.transparent, Color(0xFF22252D)],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstOut,
                      child: Image.asset(
                        'assets/images/poster.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
