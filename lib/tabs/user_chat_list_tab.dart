import 'package:bd_app_full/models/user_model.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserChatListTab extends StatefulWidget {
  @override
  _UserChatListTabState createState() => _UserChatListTabState();
}

class _UserChatListTabState extends State<UserChatListTab> {
  List<List<ChatMessage>> chatUserList = [];
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
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              model.listUserOrders.forEach(
                (order) {
                  if (order.chatMessage.length != 0) {
                    chatUserList.add(order.chatMessage);
                  }
                },
              );
              print(chatUserList.length);
              return Column();
            },
          ),
        ),
      ),
    );
  }
}
