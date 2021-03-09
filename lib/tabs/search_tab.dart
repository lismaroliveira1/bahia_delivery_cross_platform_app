import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _searchText;
  bool isTextActive = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
              flexibleSpace: Stack(children: [
                Positioned(
                  top: 100,
                  child: Container(
                    height: 80,
                    color: Colors.white,
                  ),
                )
              ]),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (text) {
                    if (text.length == 0) {
                      setState(() {
                        isTextActive = false;
                        _searchText = text;
                      });
                    } else {
                      setState(() {
                        isTextActive = true;
                        _searchText = text;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    labelText: "Pesquisar",
                    hintText: "Pesquise por produtos e lojas",
                  ),
                ),
              ),
              isTextActive
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("stores")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Lojas",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Column(
                                children: snapshot.data.docs.map((queryDoc) {
                                  if (_searchText.length > 2 &&
                                      queryDoc
                                          .get("name")
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                            _searchText.toLowerCase(),
                                          )) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            StoreData storeData;
                                            for (StoreData storeDataFromList
                                                in UserModel.of(context)
                                                    .storeHomeList) {
                                              if (queryDoc.id ==
                                                  storeDataFromList.id) {
                                                storeData = storeDataFromList;
                                                break;
                                              }
                                            }

                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: WelcomeStoreScreen(
                                                  storeData: storeData,
                                                ),
                                                inheritTheme: true,
                                                duration: Duration(
                                                  milliseconds: 350,
                                                ),
                                                ctx: context,
                                              ),
                                            );
                                          },
                                          title: Text(queryDoc.get("name")),
                                          subtitle:
                                              Text(queryDoc.get("description")),
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  queryDoc.get("image"),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 0,
                                      width: 0,
                                    );
                                  }
                                }).toList(),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
