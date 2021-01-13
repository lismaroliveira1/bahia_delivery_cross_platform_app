import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserChatListTab extends StatefulWidget {
  @override
  _UserChatListTabState createState() => _UserChatListTabState();
}

class ChatData {
  OrderData order;
  List<ChatMessage> chats = [];
  ChatData({
    @required this.order,
    @required this.chats,
  });
}

class _UserChatListTabState extends State<UserChatListTab> {
  List<ChatData> chatUserList = [];
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
              chatUserList.clear();
              model.listUserOrders.forEach(
                (order) {
                  if (order.chatMessage.length != 0) {
                    final chatData =
                        ChatData(order: order, chats: order.chatMessage);
                    chatUserList.add(chatData);
                  }
                },
              );
              return Column(
                children: chatUserList
                    .map((chat) => Container(
                          height: 50,
                          color: Colors.black,
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
