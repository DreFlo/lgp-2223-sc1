import 'package:flutter/material.dart';
import 'package:src/pages/auth/login_page.dart';
import 'package:src/themes/colors.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  late AnimationController _animationController;

  int _pageCount = 0;
  String _name = "";
  String _email = "";
  String _password = "";

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Widget> getAllSignUpPages(BuildContext context) {
    List<Widget> result = [];

    result.add(
      SizedBox(
        key: const ValueKey("signUp-page1"),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 7.5),
                  Text(
                    "YOUR NAME",
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF71788D),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 7.5),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 100,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        controller: controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: textField,
                          helperStyle: Theme.of(context).textTheme.labelSmall,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onEditingComplete: () {
                          setState( () {
                            //TODO: Do checks for valid input

                            _name = controller.text;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.text = "";
                        _pageCount++;
                        _animationController.forward(from: 0.0);
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
            ],
          ),
        ),
      ),
    );

    result.add(
      SizedBox(
        key: const ValueKey("signUp-page2"),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 7.5),
                  Text(
                    "YOUR E-MAIL",
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF71788D),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 7.5),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 100,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        controller: controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: textField,
                          helperStyle: Theme.of(context).textTheme.labelSmall,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onEditingComplete: () {
                          setState( () {
                            //TODO: Do checks for valid input

                            _email = controller.text;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.text = "";
                        _pageCount++;
                        _animationController.forward(from: 0.0);
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
            ],
          ),
        ),
      ),
    );

    result.add(
      SizedBox(
        key: const ValueKey("signUp-page3"),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 7.5),
                  Text(
                    "YOUR PASSWORD",
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF71788D),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 7.5),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 100,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        obscureText: true,
                        controller: controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: textField,
                          helperStyle: Theme.of(context).textTheme.labelSmall,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onEditingComplete: () {
                          setState( () {
                            //TODO: Do checks for valid input

                            _password = controller.text; //TODO: Encript the password
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.text = "";

                        // TODO: Save things in database
                        print("Name: " + _name);
                        print("Email: " + _email);
                        print("Password: " + _password);

                        //Pop the modal and send to Landing page
                        Navigator.pop(context);
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_pageCount == 0 ? Icons.circle : Icons.circle_outlined,
                      color: _pageCount == 0 ? primaryColor : Colors.white,
                      size: 15.0),
                  Icon(_pageCount == 1 ? Icons.circle : Icons.circle_outlined,
                      color: _pageCount == 1 ? primaryColor : Colors.white,
                      size: 15.0),
                  Icon(_pageCount == 2 ? Icons.circle : Icons.circle_outlined,
                      color: _pageCount == 2 ? primaryColor : Colors.white,
                      size: 15.0),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(_animationController),
              child: pages[_pageCount],
            ),
          ),
        ],
      ),
    );
  }
}
