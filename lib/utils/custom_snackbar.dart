import 'package:flutter/material.dart';

class CustomSnackBar {
  void fastSnackBar(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}