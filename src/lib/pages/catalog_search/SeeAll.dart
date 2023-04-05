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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
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
          Padding(
            padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 0, 0),
            child: Center(
              child: Container(
                width: 327 * fem,
                height: 50 * fem,
                child: Center(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xff5e6272),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      filled: true,
                      fillColor: const Color(0xffdadada),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
            padding: EdgeInsets.fromLTRB(40 * fem, 22 * fem, 0, 0),
            child:
            SingleChildScrollView(
              child: Wrap(
                spacing: 10.0 * fem,
                runSpacing: 22.0 * fem,
                children: List.generate(media.length, (index) {
                  return SizedBox(
                    width: 100.0 * fem,
                    height: 150.0 * fem,
                    child: Media(image: media[index]['poster_path']),
                  );
                }),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
