import 'package:eng_soft_contacts_list/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: loadUser(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Olá, ${getUserName()}"),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: Center(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 2.5, right: 2.5, bottom: 5.5),
                      width: screenWidth,
                      height: screenHeight * 0.085,
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        child: Row(
                          children: [],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      }
    );
  }

  Future<bool> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  String? getUserName() {
    if (FirebaseAuth.instance.currentUser!.displayName == null && FirebaseAuth.instance.currentUser!.displayName == "") {
      return FirebaseAuth.instance.currentUser!.email;
    } else {
      FirebaseAuth.instance.currentUser!.displayName;
    }
  }
}