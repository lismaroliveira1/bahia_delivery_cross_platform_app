import 'dart:io';

import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextMessageUserComposer extends StatefulWidget {
  final Function(String) sendMessage;
  TextMessageUserComposer(this.sendMessage);
  @override
  _TextMessageUserComposerState createState() =>
      _TextMessageUserComposerState();
}

class _TextMessageUserComposerState extends State<TextMessageUserComposer> {
  bool isComposing = false;
  final picker = ImagePicker();
  File imageFile;
  TextEditingController _textMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.black45,
            ),
            onPressed: () async {
              final _pickedFile = await picker.getImage(
                source: ImageSource.gallery,
                maxHeight: 500,
                maxWidth: 500,
              );
              if (_pickedFile == null) return;
              imageFile = File(_pickedFile.path);
              UserModel.of(context).sendImageMessageByUser(imageFile);
            },
          ),
          Expanded(
            child: TextField(
              controller: _textMessageController,
              decoration: InputDecoration.collapsed(
                hintText: "Enviar uma Mensagem",
              ),
              onChanged: (text) {
                setState(() {
                  isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text);
                _textMessageController.clear();
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: isComposing ? Colors.red : Colors.black26,
            ),
            onPressed: isComposing
                ? () {
                    widget.sendMessage(_textMessageController.text);
                    _textMessageController.clear();
                    _reset();
                  }
                : null,
          )
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      isComposing = false;
    });
  }
}
