import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_soft_contacts_list/ui/data/group.dart';
import 'package:eng_soft_contacts_list/ui/screens/edit_contact_or_group_screen.dart';
import 'package:eng_soft_contacts_list/utils/providers/contact_provider.dart';
import 'package:eng_soft_contacts_list/utils/providers/group_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsList extends StatefulWidget {
  var contactNameOrEmail;

  GroupsList(this.contactNameOrEmail);

  @override
  GroupsListState createState() => GroupsListState();
}

class GroupsListState extends State<GroupsList> {
  var groupsList = [];
  var groupsAuxList = [];
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
            .collection('${widget.contactNameOrEmail}_grupos')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.active) {
            groupsList = streamSnapshot.data!.docs;
            groupsAuxList = groupsList;
            if (searchController.text.isNotEmpty) {
              groupsAuxList = groupsList.where((element) {
                return element['nome do grupo']
                        .toString()
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()) ||
                    element['descrição do grupo']
                        .toString()
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
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
                            border: InputBorder.none, icon: Icon(Icons.search)),
                        controller: searchController,
                        onEditingComplete: () {
                          setState(() {
                            groupsAuxList = groupsList.where((element) {
                              return element['nome do grupo']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text) ||
                                  element['descrição do grupo']
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
                  child: StatefulBuilder(builder: (widgetContext, widgetSetState) {
                    return Container(
                      width: screenWidth,
                      height: screenHeight,
                      child: ListView.builder(
                        itemCount: groupsAuxList.length,
                        itemBuilder: (ctx, index) => GestureDetector(
                          onLongPress: () {
                            var group = Group();
                            group.name =
                                groupsAuxList[index]['nome do grupo'];
                            group.description =
                                groupsAuxList[index]['descrição do grupo'];
                            group.contactsList =
                                groupsAuxList[index]['membros'];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (widgetContext) => EditContactOrGroupScreen(
                                    widget.contactNameOrEmail, null, group),
                              ),
                            );
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
                                      "${widget.contactNameOrEmail}_grupos")
                                  .doc(
                                      '${groupsAuxList[index]['nome do grupo']}')
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
                                              "${groupsAuxList[index]['nome do grupo']}",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            "${groupsAuxList[index]['descrição do grupo'] == null ? "" : groupsAuxList[index]['descrição do grupo'].toString()}",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: Visibility(
                                          visible: lastExpanded == index,
                                          child: Column(
                                            children: List.generate(
                                                groupsAuxList[index]['membros']
                                                    .length,
                                                (subIndex) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          "${groupsAuxList[subIndex]['membros'][subIndex]}"),
                                                    )),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
