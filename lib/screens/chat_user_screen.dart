import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/text_message_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatUserScreen extends StatefulWidget {
  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá"),
      ),
      body: Column(
        children: [
          Expanded(child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("orders")
                      .document(UserModel.of(context).chatOrderData.client)
                      .collection("chat")
                      .orderBy(
                        'createdAt',
                        descending: false,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents =
                            snapshot.data.documents.reversed.toList();
                        return ListView.builder(
                          itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            if (documents[index].data["text"] != null) {
                              Timestamp dateTime =
                                  documents[index].data["createdAt"];
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(documents[index].data['text']),
                                    ],
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    dateTime != null
                                        ? Text(
                                            dateTime.toDate().hour.toString() +
                                                ":" +
                                                dateTime
                                                    .toDate()
                                                    .minute
                                                    .toString(),
                                          )
                                        : Container(
                                            height: 0.0,
                                            width: 0.0,
                                          ),
                                  ],
                                ),
                              );
                            } else {
                              Timestamp dateTime =
                                  documents[index].data["createdAt"];
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: documents[index].data["image"],
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    dateTime != null
                                        ? Text(
                                            dateTime.toDate().hour.toString() +
                                                ":" +
                                                dateTime
                                                    .toDate()
                                                    .minute
                                                    .toString(),
                                          )
                                        : Container(
                                            height: 0.0,
                                            width: 0.0,
                                          ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                    }
                  },
                );
              }
            },
          )),
          TextMessageComposer((text) {
            UserModel.of(context).sendtextMessageByUser(text);
          }),
        ],
      ),
    );
  }
}
