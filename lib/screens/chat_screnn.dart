import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/text_message_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                      .document(UserModel.of(context).chatOrderData.orderId)
                      .collection("chat")
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
                            return ListTile(
                                title: Text(documents[index].data['text']));
                          },
                        );
                    }
                  },
                );
              }
            },
          )),
          TextMessageComposer((text) {
            UserModel.of(context).sendtextMessage(text);
          }),
        ],
      ),
    );
  }
}
