import 'package:flutter/material.dart';

class TextMessageComposer extends StatefulWidget {
  Function(String) sendMessage;
  TextMessageComposer(this.sendMessage);
  @override
  _TextMessageComposerState createState() => _TextMessageComposerState();
}

class _TextMessageComposerState extends State<TextMessageComposer> {
  bool isComposing = false;
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
            onPressed: () {},
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
