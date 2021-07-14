import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_soft_contacts_list/ui/data/contact.dart';
import 'package:eng_soft_contacts_list/ui/data/group.dart';
import 'package:eng_soft_contacts_list/utils/providers/contact_provider.dart';
import 'package:eng_soft_contacts_list/utils/providers/group_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditContactOrGroupScreen extends StatelessWidget {
  var userName;
  var contact;
  var group;

  EditContactOrGroupScreen(this.userName, this.contact, this.group);

  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: contact == null
          ? FirebaseFirestore.instance
              .collection('${userName}_grupos')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('${userName}_contatos')
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> firstStream) {
        if (firstStream.connectionState == ConnectionState.active) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              title: Text(
                "Edição de ${contact == null ? "Grupo" : "Contato"}",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("${userName}_contatos")
                        .doc('${contact!.number}')
                        .delete();

                    contact != null
                        ? FirebaseFirestore.instance
                            .collection("${userName}_contatos")
                            .doc('${secondController.text.isEmpty ? contact!.number : secondController.text}')
                            .set({
                            'nome do contato':
                                '${firstController.text.isEmpty ? contact!.name : firstController.text}',
                            'número do contato':
                                '${secondController.text.isEmpty ? contact!.number : secondController.text}',
                            'notas sobre contato':
                                '${thirdController.text.isEmpty ? contact!.notes : thirdController.text}',
                            'CEP':
                                '${fourthController.text.isEmpty ? contact!.birthday : fourthController.text}'
                          })
                        : FirebaseFirestore.instance
                            .collection("${userName}_contatos")
                            .doc('${contact!.number}')
                            .set({
                            'nome do contato':
                                '${firstController.text.isEmpty ? group!.name : firstController.text}',
                            'número do contato':
                                '${secondController.text.isEmpty ? group!.description : secondController.text}',
                          });
                    // Navigator.pop(context);
                  },
                  child: Text(
                    "Salvar  ",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: firstController,
                          decoration: InputDecoration(
                              hintText: contact == null
                                  ? group!.name
                                  : contact!.name),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: secondController,
                          decoration: InputDecoration(
                              hintText: contact == null
                                  ? group!.description
                                  : contact!.number),
                        ),
                      ),
                    ),
                    Card(
                      child: Visibility(
                        visible:
                            contact == null ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: thirdController,
                            decoration: InputDecoration(
                                hintText: contact == null
                                    ? ""
                                    : contact!.notes),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Visibility(
                        visible:
                            contact == null ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: fourthController,
                            decoration: InputDecoration(
                                hintText: contact == null
                                    ? ""
                                    : contact!.birthday),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: contact == null,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('${userName}_contatos')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> secondStream) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ListView(
                              children: List.generate(
                                  secondStream.data!.docs.length,
                                  (index) => Card(
                                        elevation: 14.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1.0,
                                                  vertical: 0.0),
                                          child: ListTile(
                                            key: Key(index.toString()),
                                            leading: StatefulBuilder(
                                                builder: (widgetContext,
                                                    widgetSetState) {
                                              return Checkbox(
                                                onChanged: (bool? value) {
                                                  widgetSetState(() {
                                                    if (value == true) {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "${userName}_grupos")
                                                          .doc(
                                                              "${group!.name}")
                                                          .update({
                                                        'nome do grupo':
                                                            '${group!.name}',
                                                        'descrição do grupo':
                                                            '${group!.description}',
                                                        'membros': FieldValue
                                                            .arrayUnion([ "${secondStream.data!.docs[index]['nome do contato']} - ${secondStream.data!.docs[index]['número do contato']}"
                                                        ])
                                                      });
                                                    } else {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "${userName}_grupos")
                                                          .doc(
                                                              "${group!.name}")
                                                          .update({
                                                        'nome do grupo':
                                                            '${group!.name}',
                                                        'descrição do grupo':
                                                            '${group!.description}',
                                                        'membros': FieldValue
                                                            .arrayRemove([ "${secondStream.data!.docs[index]['nome do contato']} - ${secondStream.data!.docs[index]['número do contato']}"
                                                        ])
                                                      });
                                                    }
                                                  });
                                                },
                                                value: firstStream.data!.docs[index]['membros'].contains("${secondStream.data!.docs[index]['nome do contato']} - ${secondStream.data!.docs[index]['número do contato']}"),
                                              );
                                            }),
                                            title: Text(secondStream
                                                    .data!.docs[index]
                                                ['nome do contato']),
                                            subtitle: Text(secondStream
                                                    .data!.docs[index]
                                                ['número do contato']),
                                          ),
                                        ),
                                      )),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
    );
  }
}
