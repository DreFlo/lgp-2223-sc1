import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  final String image;

  const Book(
    {Key?key, required this.image})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
