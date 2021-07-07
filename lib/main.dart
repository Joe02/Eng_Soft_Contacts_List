import 'package:eng_soft_contacts_list/ui/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (FirebaseAuth.instance.currentUser != null) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            } else {
              return Container();
            }
          },
        ));
  }
}
