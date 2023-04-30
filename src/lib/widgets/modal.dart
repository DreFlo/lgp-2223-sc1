import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final ScrollController scrollController;

  const Modal(
      {Key? key,
        required this.title,
        required this.icon,
        required this.children,
        required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
            controller: scrollController,
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xFF17181C),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)),
                    child: Wrap(children: [
                      Row(children: [
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ])
                    ]))
              ]),
              const SizedBox(height: 15),
              ...children
            ])));
  }
}