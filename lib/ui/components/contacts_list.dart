import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_soft_contacts_list/ui/data/contact.dart';
import 'package:eng_soft_contacts_list/ui/screens/edit_contact_or_group_screen.dart';
import 'package:eng_soft_contacts_list/utils/providers/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsList extends StatefulWidget {
  var contactNameOrEmail;

  ContactsList(this.contactNameOrEmail);

  @override
  ContactsListState createState() => ContactsListState();
}

class ContactsListState extends State<ContactsList> {
  var contactsList = [];
  var contactsAuxList = [];
  var lastExpanded = -1;
  var searchController = TextEditingController();

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
            contactsAuxList = contactsList;
            if (searchController.text.isNotEmpty) {
              contactsAuxList = contactsList.where((element) {
                return element['nome do contato']
                        .toString()
                        .toLowerCase()
                        .contains(searchController.text) ||
                    element['número do contato']
                        .toString()
                        .toLowerCase()
                        .contains(searchController.text) ||
                    element['notas sobre contato']
                        .toString()
                        .toLowerCase()
                        .contains(searchController.text) ||
                    element['CEP']
                        .toString()
                        .toLowerCase()
                        .contains(searchController.text);
              }).toList();
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.search), border: InputBorder.none),
                        controller: searchController,
                        onEditingComplete: () {
                          setState(() {
                            contactsAuxList = contactsList.where((element) {
                              return element['nome do contato']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  element['número do contato']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  element['notas sobre contato']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  element['CEP']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text);
                            }).toList();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    child: ListView.builder(
                      itemCount: contactsAuxList.length,
                      itemBuilder: (ctx, index) => StatefulBuilder(
                          builder: (widgetContext, widgetSetState) {
                        return GestureDetector(
                          onLongPress: () {
                            var contactProvider =
                                Provider.of<ContactProvider>(context);
                            contactProvider.globalContact.name =
                                contactsAuxList[index]['nome do contato'];
                            contactProvider.globalContact.number =
                                contactsAuxList[index]['número do contato'];
                            contactProvider.globalContact.notes =
                                contactsAuxList[index]['notas sobre contato'];
                            contactProvider.globalContact.birthday =
                                contactsAuxList[index]['CEP'];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditContactOrGroupScreen(
                                            widget.contactNameOrEmail)));
                          },
                          onTap: () {
                            widgetSetState(() {
                              if (lastExpanded == index) {
                                lastExpanded = -1;
                              } else {
                                lastExpanded = index;
                              }
                            });
                          },
                          child: Dismissible(
                            key: Key(index.toString()),
                            onDismissed: (direction) {
                              FirebaseFirestore.instance
                                  .collection(
                                      "${widget.contactNameOrEmail}_contatos")
                                  .doc(
                                      '${contactsAuxList[index]['número do contato']}')
                                  .delete();
                            },
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.decelerate,
                              width: screenWidth * 0.85,
                              height: lastExpanded == index
                                  ? screenHeight * 0.2
                                  : screenHeight * 0.120,
                              child: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 7.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                              contactsAuxList[index]
                                                  ['nome do contato'],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            "Nº ${contactsAuxList[index]['número do contato'] == null ? "Número não atribuído." : contactsAuxList[index]['número do contato'].toString()}",
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
                                                      "${contactsAuxList[index]['notas sobre contato']}",
                                                  style: TextStyle(
                                                      color: Colors.black87))
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
                                                text: "CEP do contato: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                  text:
                                                      "${contactsAuxList[index]['CEP']}",
                                                  style: TextStyle(
                                                      color: Colors.black87))
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
                      }),
                    ),
                  ),
                ),
              ],
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
