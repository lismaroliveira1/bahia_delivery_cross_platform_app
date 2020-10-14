import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/text_message_composer.dart';
import 'package:flutter/material.dart';

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
      body: TextMessageComposer((text) {
        UserModel.of(context).sendtextMessage(text);
      }),
    );
  }
}
