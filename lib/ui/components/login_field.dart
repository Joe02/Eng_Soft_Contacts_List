import 'package:eng_soft_contacts_list/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginField extends StatefulWidget {
  var fieldType;
  var hint;
  var containerColor;
  var fieldTextStyle;
  var fieldWidth;

  LoginField(this.fieldType, this.hint, this.containerColor,
      this.fieldTextStyle, this.fieldWidth);

  @override
  LoginFieldState createState() => LoginFieldState(
      fieldType, hint, containerColor, fieldTextStyle, fieldWidth);
}

class LoginFieldState extends State<LoginField> {
  var fieldType;
  var hint;
  var containerColor;
  var fieldTextStyle;
  var fieldWidth;

  LoginFieldState(
    this.fieldType,
    this.hint,
    this.containerColor,
    this.fieldTextStyle,
    this.fieldWidth,
  );

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * fieldWidth,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          color: containerColor, borderRadius: BorderRadius.circular(15.0)),
      child: TextField(
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
