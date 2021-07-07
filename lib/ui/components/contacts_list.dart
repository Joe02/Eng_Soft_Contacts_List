import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  var contactNameOrEmail;

  ContactsList(this.contactNameOrEmail);

  @override
  ContactsListState createState() => ContactsListState();
}

class ContactsListState extends State<ContactsList> {
  var contactsList = [];
  var lastExpanded = -1;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('${widget.contactNameOrEmail}_contatos')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.active) {
            contactsList = streamSnapshot.data!.docs;
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    if (lastExpanded == index) {
                      lastExpanded = -1;
                    } else {
                      lastExpanded = index;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 10),
                  curve: Curves.decelerate,
                  width: screenWidth * 0.85,
                  height: lastExpanded == index
                      ? screenHeight * 0.2
                      : screenHeight * 0.120,
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 7.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                  streamSnapshot.data!.docs[index]
                                      ['nome do contato'],
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "Nº ${streamSnapshot.data!.docs[index]['número do contato'] == null ? "Número não atribuído." : streamSnapshot.data!.docs[index]['número do contato'].toString()}",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Visibility(
                              visible: lastExpanded == index,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Notas sobre o contato: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                      text:
                                          "${streamSnapshot.data!.docs[index]['notas sobre contato']}",
                                      style: TextStyle(color: Colors.black87))
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Visibility(
                              visible: lastExpanded == index,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Data de nascimento do contato: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                      text:
                                          "${streamSnapshot.data!.docs[index]['data de nascimento']}",
                                      style: TextStyle(color: Colors.black87))
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              width: screenWidth,
              height: screenHeight,
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
