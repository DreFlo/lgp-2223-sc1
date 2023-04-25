import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  TextEditingController inputNameController = TextEditingController();
  TextEditingController inputEmailController = TextEditingController();
  TextEditingController inputPasswordController = TextEditingController();
  late AnimationController _animationController;

  int _pageCount = 0;
  String _name = "";
  String _email = "";
  String _password = "";

  String _nameErrText = "";
  String _emailErrText = "";
  String _passwordErrText = "";

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
    inputNameController.dispose();
    inputEmailController.dispose();
    inputPasswordController.dispose();
    super.dispose();
  }

  List<Widget> getAllSignUpPages(BuildContext context) {
    List<Widget> result = [];

    result.add(
      SizedBox(
        key: const ValueKey("signUp-page1"),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05)),
                  TextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    controller: inputNameController,
                    onChanged: (value) => {
                          _nameErrText = ""
                    },
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'YOUR NAME',
                      labelStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF5E6272),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      contentPadding: const EdgeInsets.only(bottom: 2.5),
                      errorText: _nameErrText != "" ? _nameErrText : null,
                      errorStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: leisureColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05)),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        String nameInput = inputNameController.text;
                        
                        if(nameInput == ""){
                          _nameErrText = "Please insert a name!";
                        } else {
                          _name = nameInput;

                          _pageCount++;
                          _animationController.forward(from: 0.0);
                        }
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
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05)),
                  TextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    controller: inputEmailController,
                    onChanged:(value) => {
                      _emailErrText = ""
                    },
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'YOUR E-MAIL',
                      labelStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF5E6272),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      contentPadding: const EdgeInsets.only(bottom: 2.5),
                      errorText: _emailErrText != "" ? _emailErrText : null,
                      errorStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: leisureColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _email = inputEmailController.text;

                        _pageCount--;
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
                    child: Text("Previous",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        String inputEmail = inputEmailController.text;

                        RegExp emailRE = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                        if(!emailRE.hasMatch(inputEmail)){
                          _emailErrText = "Please insert a valid email!";
                        } else {
                          _email = inputEmail;

                          _pageCount++;
                          _animationController.forward(from: 0.0);
                        }
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
                    ],),
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
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05)),
                  TextField(
                    style: Theme.of(context).textTheme.bodySmall,
                    obscureText: true,
                    controller: inputPasswordController,
                    onChanged: (value) => {
                      _passwordErrText = ""
                    },
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'YOUR PASSWORD',
                      labelStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF5E6272),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      contentPadding: const EdgeInsets.only(bottom: 2.5),
                      errorText: _passwordErrText != "" ? _passwordErrText : null,
                      errorStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: leisureColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _password = inputPasswordController.text;

                        _pageCount--;
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
                    child: Text("Previous",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        String passwordInput = inputPasswordController.text;

                        if(passwordInput.length < 8){
                          _passwordErrText = "Please insert a password with 8 or more digits!";
                        } else {
                          //TODO(auth): Encrypt password - before saving - i think there's a package for this

                          _password = passwordInput; 

                          // TODO(auth): Save things in database (_name, _email and _password)

                          inputNameController.text = "";
                          inputEmailController.text = "";
                          inputPasswordController.text = "";

                          //Pop the modal and send to Landing page
                          Navigator.pop(context);
                        }
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
                  ],),
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
          Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.07)),
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
