import 'package:flutter/material.dart';

class Media extends StatelessWidget {
  final String image;

  const Media(
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
          child: Image.network(
            'https://image.tmdb.org/t/p/w500$image',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
