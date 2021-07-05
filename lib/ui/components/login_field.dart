import 'package:eng_soft_contacts_list/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginField extends StatefulWidget {
  var fieldType;
  var hint;
  var containerColor;
  var fieldTextStyle;
  var fieldWidth;
  var userController;

  LoginField(this.fieldType, this.hint, this.containerColor,
      this.fieldTextStyle, this.fieldWidth, this.userController);

  @override
  LoginFieldState createState() => LoginFieldState(
      fieldType, hint, containerColor, fieldTextStyle, fieldWidth, userController);
}

class LoginFieldState extends State<LoginField> {
  var fieldType;
  var hint;
  var containerColor;
  var fieldTextStyle;
  var fieldWidth;
  var userController;

  LoginFieldState(
    this.fieldType,
    this.hint,
    this.containerColor,
    this.fieldTextStyle,
    this.fieldWidth,
    this.userController
  );

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * fieldWidth,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: BoxDecoration(
          color: containerColor, borderRadius: BorderRadius.circular(15.0)),
      child: TextField(
        controller: userController,
        style: fieldTextStyle,
        obscureText: fieldType == FieldType.text ? false : true,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: fieldTextStyle),
      ),
    );
  }
}
