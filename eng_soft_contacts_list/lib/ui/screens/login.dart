import 'dart:ui';

import 'package:eng_soft_contacts_list/ui/components/custom_button.dart';
import 'package:eng_soft_contacts_list/ui/components/login_field.dart';
import 'package:eng_soft_contacts_list/utils/styles.dart';
import 'package:eng_soft_contacts_list/utils/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
              LoginField(FieldType.text, "Email", Colors.orangeAccent,
                  CustomStyles.defaultWhiteText, 0.725),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoginField(FieldType.password, "Senha", Colors.orange,
                        CustomStyles.defaultWhiteText, 0.425),
                    SizedBox(
                      width: 5,
                    ),
                    CustomButton(
                        () {}, Text("Confirmar"), Colors.orange, 20, 10),
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
              CustomButton(
                () {},
                Text(
                  "Esqueci minha senha",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 17,
                  ),
                ),
                Colors.white,
                5,
                5,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
