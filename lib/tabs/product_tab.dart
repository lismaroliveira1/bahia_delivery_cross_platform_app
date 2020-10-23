import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class ProductTab extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String storeId;
  ProductTab(this.snapshot, this.storeId);
  @override
  _ProductTabState createState() => _ProductTabState(snapshot, storeId);
}

class _ProductTabState extends State<ProductTab> {
  final DocumentSnapshot snapshot;
  final String storeId;
  _ProductTabState(this.snapshot, this.storeId);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            expandedHeight: 200,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  snapshot.data["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ];
      },
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              snapshot.data["title"],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Text(
              snapshot.data["fullDescription"],
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("stores")
                .document(storeId)
                .collection("products")
                .document(snapshot.documentID)
                .collection("incrementalOptions")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(height: 0);
              } else {
                return Expanded(
                  child: GroupedListView<dynamic, String>(
                    elements: snapshot.data.documents,
                    groupBy: (doc) => doc.data["session"],
                    useStickyGroupSeparators: false,
                    groupSeparatorBuilder: (String value) => Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              10.0,
                              5.0,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          child: ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(doc.data["title"]),
                            subtitle: Text(doc.data["description"]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  doc.data["image"],
                                  fit: BoxFit.fill,
                                  height: 40,
                                  width: 40,
                                  isAntiAlias: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
