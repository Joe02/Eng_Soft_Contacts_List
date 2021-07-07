import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_soft_contacts_list/ui/components/FancyFab.dart';
import 'package:eng_soft_contacts_list/ui/components/contacts_list.dart';
import 'package:eng_soft_contacts_list/ui/screens/login_screen.dart';
import 'package:eng_soft_contacts_list/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var userName = "";
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController contactBirthday = TextEditingController();
  final TextEditingController contactNotes = TextEditingController();
  bool isLoadingARequest = false;
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: loadUser(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: buildAppBar(),
          floatingActionButton: FancyFab(
            onPressed: () {},
            icon: Icons.add,
            tooltip: 'Adicionar contato ou grupo.',
            contactCallback: showContactModal,
            groupCallback: showGroupModal,
          ),
          body: Center(
            child: Container(
              child: ContactsList(userName),
            ),
          ),
        );
      },
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      title: Text("Olá, ${getUserName()}", style: TextStyle(color: Colors.white),),
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
    );
  }

  buildSearchBar(screenWidth, screenHeight) {
    return Container(
      padding: EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5.5),
      width: screenWidth,
      height: screenHeight * 0.085,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.search),
            )
          ],
        ),
      ),
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
    if (FirebaseAuth.instance.currentUser!.displayName == null ||
        FirebaseAuth.instance.currentUser!.displayName == "") {
      userName = FirebaseAuth.instance.currentUser!.email!;
      return userName;
    } else {
      userName = FirebaseAuth.instance.currentUser!.email!;
      return FirebaseAuth.instance.currentUser!.displayName!;
    }
  }

  void showContactModal() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Wrap(
                children: <Widget>[
                  TextField(
                    controller: contactName,
                    decoration: InputDecoration(hintText: "Nome do contato"),
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                    ],
                    controller: contactNumber,
                    decoration: InputDecoration(hintText: "Número do contato"),
                  ),
                  TextField(
                    controller: contactNotes,
                    decoration:
                        InputDecoration(hintText: "Notas sobre o contato"),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                      ],
                      controller: contactBirthday,
                      decoration: InputDecoration(hintText: "Data de nascimento"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection(
                              "${FirebaseAuth.instance.currentUser!.email}_contatos")
                          .add({
                        'nome do contato': '${contactName.text.isEmpty ? "" : contactName.text}',
                        'número do contato': '${contactNumber.text.isEmpty ? "" : contactNumber.text}',
                        'notas sobre contato': '${contactNotes.text.isEmpty ? "" : contactNotes.text}',
                        'data de nascimento': '${contactBirthday.text.isEmpty ? "" : contactBirthday.text}'
                      });
                      contactName.clear();
                      contactNumber.clear();
                      contactNotes.clear();
                      contactBirthday.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text(CustomStrings.confirmLabel),
                  )
                ],
              ),
            ),
          );
        },
        isScrollControlled: true);
  }

  void showGroupModal() {
    final TextEditingController groupName = TextEditingController();
    final TextEditingController groupDescription = TextEditingController();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    controller: groupName,
                    decoration: InputDecoration(hintText: "Nome do grupo"),
                  ),
                  TextField(
                    controller: groupDescription,
                    decoration: InputDecoration(hintText: "Descrição do grupo"),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection(
                              "${FirebaseAuth.instance.currentUser!.email}_grupos")
                          .add({
                        'nome do grupo': '${groupName.text}',
                        'descrição do grupo': '${groupDescription.text}'
                      });
                      groupName.clear();
                      groupDescription.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text(CustomStrings.confirmLabel),
                  )
                ],
              ),
            ),
          );
        },
        isScrollControlled: true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        contactBirthday.text = "${picked.day}/${picked.month}/${picked.year}";
        selectedDate = picked;
      });
  }
}
