import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class SubSectionStoreTab extends StatefulWidget {
  final List<SubSectionData> subsections;
  final String sectionId;
  final bool isFirstSection;
  SubSectionStoreTab(
    this.subsections,
    this.sectionId,
    this.isFirstSection,
  );
  @override
  _SubSectionStoreTabState createState() => _SubSectionStoreTabState();
}

class _SubSectionStoreTabState extends State<SubSectionStoreTab> {
  List<SubSectionData> subsections = [];
  @override
  void initState() {
    subsections = widget.subsections;
    FirebaseFirestore.instance
        .collection("stores")
        .doc(UserModel.of(context).userData.storeId)
        .collection("categories")
        .doc(widget.sectionId)
        .collection("subcategories")
        .snapshots()
        .listen(
      (querySnapshot) {
        subsections.clear();
        querySnapshot.docs
            .map(
              (queryDoc) => subsections.add(
                SubSectionData.fromQuerDocument(
                  queryDoc,
                  widget.sectionId,
                ),
              ),
            )
            .toList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
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
                padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 35,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () => pageTransition(
                      context: context,
                      screen: new InsertNewSubSectionScreen(
                        widget.subsections,
                        widget.sectionId,
                        widget.isFirstSection,
                      ),
                    ),
                    dense: true,
                    leading: Icon(Icons.add_circle),
                    title: Text("Nova Subseção"),
                    subtitle: Text(
                      "Insira uma nova subseção nesta seção",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: widget.subsections.map((subsection) {
                    return ListTile(
                      title: Text(
                        subsection.title,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        subsection.order.toString(),
                        textAlign: TextAlign.end,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
