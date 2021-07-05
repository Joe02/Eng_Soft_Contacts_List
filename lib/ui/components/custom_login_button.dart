import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoginButton extends StatelessWidget {
  final void Function() callback;
  Widget btnChild;
  Color btnColor;
  double verticalPadding;
  double horizontalPadding;
  List<double> borders = [];

  CustomLoginButton(this.callback, this.btnChild, this.btnColor,
      this.horizontalPadding, this.verticalPadding, this.borders);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: btnChild,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(btnColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borders[0]),
              topRight: Radius.circular(borders[1]),
              bottomRight: Radius.circular(borders[2]),
              bottomLeft: Radius.circular(borders[3]),
            ),
          ),
        ),
      ),
    );
  }
}
