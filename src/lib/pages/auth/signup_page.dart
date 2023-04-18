import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class SignUpPage extends StatefulWidget {

  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController controller = TextEditingController();
  int _pageCount = 0;

  List<Widget> getAllSignUpPages(BuildContext context) {
    List<Widget> result = [];

    result.add(
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Hello!",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              Text(
                "Let's start your journey",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Row(children: [
                Text(
                  "YOUR NAME",
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400),
                )
              ]),
              const SizedBox(height: 7.5),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 100,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textField,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _pageCount++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.25, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text("Next",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
          ),
        ),
      ),
    );

    result.add(
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Tell us your email",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              Text(
                "We promise not to send you annoying emails!",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Row(children: [
                Text(
                  "YOUR E-MAIL",
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400),
                )
              ]),
              const SizedBox(height: 7.5),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 100,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textField,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _pageCount++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.25, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text("Next",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
          ),
        ),
      ),
    );

    result.add(
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Password",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              Text(
                "And no... 'password123' is not a good one.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Row(children: [
                Text(
                  "YOUR PASSWORD",
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400),
                )
              ]),
              const SizedBox(height: 7.5),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 100,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textField,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print("END! :)");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.25, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text("Next",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
          ),
        ),
      ),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Implement signUp page
    List<Widget> pages = getAllSignUpPages(context);

    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            child: Text(
              "Dots!",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: pages[_pageCount]
          ),
        ],
      ),
    );
  }
}
