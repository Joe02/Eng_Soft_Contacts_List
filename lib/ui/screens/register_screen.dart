import 'dart:ui';

import 'package:eng_soft_contacts_list/ui/components/custom_login_button.dart';
import 'package:eng_soft_contacts_list/ui/components/login_field.dart';
import 'package:eng_soft_contacts_list/utils/custom_snackbar.dart';
import 'package:eng_soft_contacts_list/utils/enums.dart';
import 'package:eng_soft_contacts_list/utils/firebaseAuthHelper.dart';
import 'package:eng_soft_contacts_list/utils/strings.dart';
import 'package:eng_soft_contacts_list/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _currentlyLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.orangeAccent.withOpacity(0.25), BlendMode.dstATop),
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.45,
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 15,
                        blurRadius: 50,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/contacts_list_icon.png',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                LoginField(
                    FieldType.text,
                    CustomStrings.emailLabel,
                    Colors.orange[400],
                    CustomStyles.defaultWhiteText,
                    0.725,
                    userController),
                LoginField(
                    FieldType.password,
                    CustomStrings.passwordLabel,
                    Colors.orange[500],
                    CustomStyles.defaultWhiteText,
                    0.725,
                    passwordController),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoginField(
                        FieldType.password,
                        CustomStrings.confirmPasswordLabel,
                        Colors.orange[600],
                        CustomStyles.defaultWhiteText,
                        0.425,
                        confirmPasswordController,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      displayLoginButton(),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  displayLoginButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          this._currentlyLoading = true;
        });
        onLoginEvent();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      child: _currentlyLoading
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 5.5),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
              child: Text(CustomStrings.confirmLabel),
            ),
    );
  }

  onLoginEvent() async {
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(userController.text);
    if (emailValid) {
      if (passwordController.text.length >= 6) {
        UserCredential? user = await FirebaseAuthHelper().registerUser(
          userController.text,
          passwordController.text,
        );
        if (user != null) {
          await FirebaseAuthHelper().signInWith(
            userController.text,
            passwordController.text,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          CustomSnackBar().fastSnackBar(context, CustomStrings.onLoginError);
          _currentlyLoading = false;
        }
      } else {
        CustomSnackBar().fastSnackBar(context, CustomStrings.onSmallPassword);
        _currentlyLoading = false;
      }
    } else {
      CustomSnackBar().fastSnackBar(context, CustomStrings.onIncorrectEmail);
      _currentlyLoading = false;
    }
  }
}
