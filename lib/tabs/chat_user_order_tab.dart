import 'package:bd_app_full/data/messages_chat_data.dart';
import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUserOrderTab extends StatefulWidget {
  final OrderData orderData;
  ChatUserOrderTab(this.orderData);
  @override
  _ChatUserOrderTabState createState() => _ChatUserOrderTabState();
}

class _ChatUserOrderTabState extends State<ChatUserOrderTab> {
  TextEditingController _messageController = TextEditingController();
  List<MessageChatData> messages = [];
  bool isComposing;
  @override
  void initState() {
    isComposing = false;
    initRealTimeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Pedido: ${widget.orderData.id.substring(0, 6)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.orderData.storeName,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.orderData.storeDescription,
                ),
              ],
            ),
            leading: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    widget.orderData.storeImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: messages
                  .map(
                    (message) => ListTile(
                      title: Text(
                        message.text,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      if (text.length == 0) {
                        setState(() {
                          isComposing = false;
                        });
                      } else {
                        setState(() {
                          isComposing = true;
                        });
                      }
                      setState(() {
                        isComposing = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enviar mensagem',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: isComposing ? Colors.red[400] : Colors.grey[300],
                  ),
                  onPressed: isComposing
                      ? () {
                          UserModel.of(context).sendtextMessageByUser(
                            text: _messageController.text,
                            orderData: widget.orderData,
                          );
                          setState(() {
                            isComposing = false;
                          });
                          _messageController.clear();
                        }
                      : null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void initRealTimeFirebase() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderData.id)
        .collection("chat")
        .orderBy(
          'createdAt',
          descending: false,
        )
        .snapshots()
        .listen((event) {
      messages.clear();
      List<MessageChatData> flag = [];
      event.docs.forEach((queryDoc) {
        flag.add(MessageChatData.fromQueryDocumentSnaphot(queryDoc));
      });
      setState(() {
        messages = flag;
      });
    });
  }
}
