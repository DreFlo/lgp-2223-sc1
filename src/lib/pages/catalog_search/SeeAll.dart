import 'package:flutter/material.dart';
import 'Media.dart';

class SeeAll extends StatelessWidget {
  final List media;
  final String title;

  const SeeAll({Key? key, required this.title, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(10 * fem, 50 * fem, 0, 0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
             title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      /*SizedBox(
              height: MediaQuery.of(context).size.height - 100, // or any other height that fits your design
              child:  SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * fem),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 22.0 * fem,
                    crossAxisSpacing: 10.0 * fem,
                    children: List.generate(media.length, (index) {
                      return Media(image: media[index]['poster_path']);
                    }),
                  ))))*/
    ]));
  }
}
