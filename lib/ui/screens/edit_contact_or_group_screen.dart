import 'package:eng_soft_contacts_list/ui/data/contact.dart';
import 'package:eng_soft_contacts_list/ui/data/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditContactOrGroupScreen extends StatefulWidget {
  Contact? contact;
  Group? group;
  var userName;

  EditContactOrGroupScreen(this.contact, this.group, this.userName);

  @override
  EditContactOrGroupScreenState createState() =>
      EditContactOrGroupScreenState();
}

class EditContactOrGroupScreenState extends State<EditContactOrGroupScreen> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('${widget.userName}_contatos')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) =>
          Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            "Edição de ${widget.contact == null ? "Grupo" : "Contato"}",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {

                FirebaseFirestore.instance
                    .collection("${widget.userName}_contatos")
                    .doc('${widget.contact!.number}').delete();

                widget.contact != null
                    ? FirebaseFirestore.instance
                        .collection("${widget.userName}_contatos")
                        .doc('${secondController.text != widget.contact!.number ? secondController.text : widget.contact!.number}')
                        .set({
                        'nome do contato':
                            '${firstController.text.isEmpty ? widget.contact!.name != null ? widget.contact!.name : "" : firstController.text}',
                        'número do contato':
                            '${secondController.text.isEmpty ? widget.contact!.number != null ? widget.contact!.number : "" : secondController.text}',
                        'notas sobre contato':
                            '${thirdController.text.isEmpty ? widget.contact!.notes != null ? widget.contact!.notes : "" : thirdController.text}',
                        'data de nascimento':
                            '${fourthController.text.isEmpty ? widget.contact!.birthday != null ? widget.contact!.birthday : "" : fourthController.text}'
                      })
                    : FirebaseFirestore.instance
                        .collection("${widget.userName}_contatos")
                        .doc('${widget.contact!.number}')
                        .set({
                        'nome do contato':
                            '${firstController.text.isEmpty ? widget.group!.name : firstController.text}',
                        'número do contato':
                            '${secondController.text.isEmpty ? widget.group!.description : secondController.text}',
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: firstController,
                    decoration: InputDecoration(
                        hintText: widget.contact == null
                            ? widget.group!.name
                            : widget.contact!.name),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: secondController,
                    decoration: InputDecoration(
                        hintText: widget.contact == null
                            ? widget.group!.description
                            : widget.contact!.number),
                  ),
                ),
              ),
              Card(
                child: Visibility(
                  visible: widget.contact == null ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: thirdController,
                      decoration: InputDecoration(
                          hintText: widget.contact == null
                              ? ""
                              : widget.contact!.notes),
                    ),
                  ),
                ),
              ),
              Card(
                child: Visibility(
                  visible: widget.contact == null ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fourthController,
                      decoration: InputDecoration(
                          hintText: widget.contact == null
                              ? ""
                              : widget.contact!.birthday),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
