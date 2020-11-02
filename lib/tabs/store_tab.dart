import 'package:bahia_delivery/screens/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class StoreTab extends StatefulWidget {
  final DocumentSnapshot snapshot;

  StoreTab(this.snapshot);

  @override
  _StoreTabState createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            expandedHeight: 200.0,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(widget.snapshot.data["title"]),
                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  child: Image.network(
                    widget.snapshot.data["image"],
                    fit: BoxFit.cover,
                  ),
                )),
          )
        ];
      },
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("stores")
            .document(widget.snapshot.documentID)
            .collection("products")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              child: Column(
                children: [
                  Expanded(
                    child: GroupedListView<dynamic, String>(
                      elements: snapshot.data.documents,
                      groupBy: (doc) => doc.data["group"],
                      useStickyGroupSeparators: false,
                      groupSeparatorBuilder: (String value) => Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                10.0,
                                10.0,
                                2.0,
                                6.0,
                              ),
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (c, doc) {
                        return Card(
                          elevation: 8.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: EdgeInsets.only(top: 4, bottom: 4.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => new ProductScreen(
                                        doc,
                                        widget.snapshot.documentID,
                                      ),
                                    ),
                                  );
                                },
                                dense: false,
                                leading: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      doc.data["image"],
                                      fit: BoxFit.fill,
                                      height: 80,
                                      width: 60,
                                    ),
                                  ),
                                ),
                                title: Text(doc.data["title"]),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.data["description"]
                                                  .toString()
                                                  .length <
                                              40
                                          ? doc.data["description"]
                                          : doc.data["description"]
                                                  .toString()
                                                  .substring(0, 40) +
                                              "...",
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'R' +
                                              '\$ ' +
                                              doc.data["price"]
                                                  .toString()
                                                  .replaceAll(".", ","),
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
