import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() callback;
  Widget btnChild;
  Color btnColor;
  double verticalPadding;
  double horizontalPadding;

  CustomButton(this.callback, this.btnChild, this.btnColor, this.horizontalPadding, this.verticalPadding);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: btnChild,
      ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(btnColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                )
            )
        )
    );
  }
}
