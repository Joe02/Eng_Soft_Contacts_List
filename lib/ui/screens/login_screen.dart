import 'dart:ui';

import 'package:eng_soft_contacts_list/ui/components/custom_login_button.dart';
import 'package:eng_soft_contacts_list/ui/components/login_field.dart';
import 'package:eng_soft_contacts_list/ui/screens/register_screen.dart';
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

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
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
                Colors.orangeAccent,
                CustomStyles.defaultWhiteText,
                0.725,
                userController,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoginField(
                      FieldType.password,
                      CustomStrings.passwordLabel,
                      Colors.orange,
                      CustomStyles.defaultWhiteText,
                      0.425,
                      passwordController,
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
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLoginButton(
                    () {
                      showResetDialog(context);
                    },
                    Text(
                      CustomStrings.forgotPasswordLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 17,
                      ),
                    ),
                    Colors.white,
                    5,
                    5,
                    [15, 0, 0, 15],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomLoginButton(() {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                      Text(
                        CustomStrings.createAccountLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 17,
                        ),
                      ),
                      Colors.white,
                      5,
                      5,
                      [0, 15, 15, 0])
                ],
              ))
            ],
          ),
        ),
      ),
    ));
  }

  displayLoginButton() {
    return StatefulBuilder(builder: (context, widgetSetState) {
      return ElevatedButton(
        onPressed: () {
          widgetSetState(() {
            this._currentlyLoading = true;
          });
          if (onLoginEvent(widgetSetState) == false) {
            widgetSetState(() {
              this._currentlyLoading = false;
            });
          }
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
    });
  }

  onLoginEvent(widgetSetState) async {
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(userController.text);
    if (emailValid) {
      if (passwordController.text.length >= 6) {
        User? user = await FirebaseAuthHelper().signInWith(
          userController.text,
          passwordController.text,
        );
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          CustomSnackBar().fastSnackBar(context, CustomStrings.onLoginError);
          return false;
        }
      } else {
        CustomSnackBar().fastSnackBar(context, CustomStrings.onSmallPassword);
        return false;
      }
    } else {
      CustomSnackBar().fastSnackBar(context, CustomStrings.onIncorrectEmail);
      return false;
    }
  }

  showResetDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    Widget cancelButton = TextButton(
      child: Text(CustomStrings.cancelLabel),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = TextButton(
      child: Text(CustomStrings.continueLabel),
      onPressed: () {
        bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(emailController.text);
        if (emailValid) {
          FirebaseAuthHelper().sendResetEmail(userController.text);
          Navigator.pop(context);
          CustomSnackBar()
              .fastSnackBar(context, CustomStrings.onResetPasswordSuccess);
        } else {
          CustomSnackBar()
              .fastSnackBar(context, CustomStrings.onResetPasswordError);
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(CustomStrings.resetPasswordLabel),
      content: TextField(
        controller: emailController,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
