import 'package:flutter/material.dart';

class ChatDeliveryManTab extends StatefulWidget {
  @override
  _ChatDeliveryManTabState createState() => _ChatDeliveryManTabState();
}

class _ChatDeliveryManTabState extends State<ChatDeliveryManTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBosIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("Chats"),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ];
        },
        body: Container(),
      ),
    );
  }
}
