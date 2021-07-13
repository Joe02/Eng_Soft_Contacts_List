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

  EditContactOrGroupScreen(this.userName);

  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context);
    var contactProvider = Provider.of<ContactProvider>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: contactProvider.globalContact == null
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
                "Edição de ${contactProvider.globalContact == null ? "Grupo" : "Contato"}",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("${userName}_contatos")
                        .doc('${contactProvider.globalContact!.number}')
                        .delete();

                    contactProvider.globalContact != null
                        ? FirebaseFirestore.instance
                            .collection("${userName}_contatos")
                            .doc(
                                '${secondController.text != contactProvider.globalContact!.number ? secondController.text : contactProvider.globalContact!.number}')
                            .set({
                            'nome do contato':
                                '${firstController.text.isEmpty ? contactProvider.globalContact!.name != null ? contactProvider.globalContact!.name : "" : firstController.text}',
                            'número do contato':
                                '${secondController.text.isEmpty ? contactProvider.globalContact!.number != null ? contactProvider.globalContact!.number : "" : secondController.text}',
                            'notas sobre contato':
                                '${thirdController.text.isEmpty ? contactProvider.globalContact!.notes != null ? contactProvider.globalContact!.notes : "" : thirdController.text}',
                            'data de nascimento':
                                '${fourthController.text.isEmpty ? contactProvider.globalContact!.birthday != null ? contactProvider.globalContact!.birthday : "" : fourthController.text}'
                          })
                        : FirebaseFirestore.instance
                            .collection("${userName}_contatos")
                            .doc('${contactProvider.globalContact!.number}')
                            .set({
                            'nome do contato':
                                '${firstController.text.isEmpty ? groupProvider.globalGroup.name : firstController.text}',
                            'número do contato':
                                '${secondController.text.isEmpty ? groupProvider.globalGroup.description : secondController.text}',
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
                              hintText: contactProvider.globalContact == null
                                  ? groupProvider.globalGroup.name
                                  : contactProvider.globalContact!.name),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: secondController,
                          decoration: InputDecoration(
                              hintText: contactProvider.globalContact == null
                                  ? groupProvider.globalGroup.description
                                  : contactProvider.globalContact!.number),
                        ),
                      ),
                    ),
                    Card(
                      child: Visibility(
                        visible:
                            contactProvider.globalContact == null ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: thirdController,
                            decoration: InputDecoration(
                                hintText: contactProvider.globalContact == null
                                    ? ""
                                    : contactProvider.globalContact!.notes),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Visibility(
                        visible:
                            contactProvider.globalContact == null ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: fourthController,
                            decoration: InputDecoration(
                                hintText: contactProvider.globalContact == null
                                    ? ""
                                    : contactProvider.globalContact!.birthday),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: contactProvider.globalContact == null,
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
                                                builder: (context,
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
                                                              "${groupProvider.globalGroup.name}")
                                                          .update({
                                                        'nome do grupo':
                                                            '${groupProvider.globalGroup.name}',
                                                        'descrição do grupo':
                                                            '${groupProvider.globalGroup.description}',
                                                        'membros': FieldValue
                                                            .arrayUnion([ "${contactProvider.globalContact.name} - ${contactProvider.globalContact.number}"
                                                        ])
                                                      });
                                                    } else {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "${userName}_grupos")
                                                          .doc(
                                                              "${groupProvider.globalGroup.name}")
                                                          .update({
                                                        'nome do grupo':
                                                            '${groupProvider.globalGroup.name}',
                                                        'descrição do grupo':
                                                            '${groupProvider.globalGroup.description}',
                                                        'membros': FieldValue
                                                            .arrayUnion([ "${contactProvider.globalContact.name} - ${contactProvider.globalContact.number}"
                                                        ])
                                                      });
                                                    }
                                                  });
                                                },
                                                value: firstStream.data!
                                                    .docs[index]['membros']
                                                    .contains(
                                                        "${secondStream.data!.docs[index]['nome do contato']} - ${secondStream.data!.docs[index]['número do contato']}"),
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
