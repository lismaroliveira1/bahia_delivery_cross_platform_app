import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/data.dart';
import '../models/models.dart';

class ChatUserOrderTab extends StatefulWidget {
  final OrderData orderData;
  ChatUserOrderTab(this.orderData);
  @override
  _ChatUserOrderTabState createState() => _ChatUserOrderTabState();
}

class _ChatUserOrderTabState extends State<ChatUserOrderTab> {
  File imageFile;
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  bool isImageChoosed = false;
  final picker = ImagePicker();
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  List<ChatMessage> messages = [];
  bool isComposing;
  ChatUser user;
  ChatUser store;
  @override
  void initState() {
    isComposing = false;
    initRealTimeFirebase();
    super.initState();
    user = ChatUser(
      name: widget.orderData.clientName,
      lastName: '',
      uid: widget.orderData.client,
      avatar: widget.orderData.clientImage,
    );
    store = ChatUser(
      name: widget.orderData.storeName,
      lastName: '',
      uid: widget.orderData.storeId,
      avatar: widget.orderData.storeImage,
    );
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DashChat(
                key: _chatViewKey,
                messages: messages,
                messageContainerDecoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                sendOnEnter: true,
                inputDecoration: InputDecoration(
                  isDense: true,
                  labelText: 'mensagem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textInputAction: TextInputAction.send,
                dateFormat: DateFormat('dd-MM-yyyy'),
                timeFormat: DateFormat('HH:mm'),
                user: user,
                showUserAvatar: true,
                showAvatarForEveryMessage: true,
                scrollToBottom: true,
                onSend: (ChatMessage message) {
                  UserModel.of(context).sendtextMessage(
                    message: message,
                    orderData: widget.orderData,
                  );
                },
                onLoadEarlier: () {
                  print("carregando...");
                },
                showTraillingBeforeSend: true,
                leading: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.photo,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      onSendImagePressed();
                    },
                  )
                ],
              ),
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
      List<ChatMessage> flag = [];
      event.docs.forEach((queryDoc) {
        flag.add(
          ChatMessage.fromJson(
            queryDoc.data(),
          ),
        );
      });
      setState(() {
        messages = flag;
      });
    });
  }

  void onSendImagePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  try {
                    final _pickedFile = await picker.getImage(
                      source: ImageSource.gallery,
                      maxHeight: 500,
                      maxWidth: 500,
                    );
                    if (_pickedFile == null) return;
                    imageFile = File(_pickedFile.path);
                    if (imageFile == null) return;
                    setState(() {
                      isImageChoosed = true;
                    });
                    UserModel.of(context).sendImageMessage(
                      imageFile: imageFile,
                      orderData: widget.orderData,
                      user: user,
                    );
                  } catch (e) {
                    setState(() {
                      isImageChoosed = false;
                    });
                  }
                },
                child: Container(
                  child: Image.asset(
                    "images/gallery_image.png",
                  ),
                  height: 50,
                  width: 50,
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final _pickedFile = await picker.getImage(
                      source: ImageSource.camera,
                      maxHeight: 500,
                      maxWidth: 500,
                    );
                    if (_pickedFile == null) return;
                    imageFile = File(_pickedFile.path);
                    if (imageFile == null) return;
                    setState(() {
                      isImageChoosed = true;
                    });
                    UserModel.of(context).sendImageMessage(
                      imageFile: imageFile,
                      orderData: widget.orderData,
                      user: user,
                    );
                  } catch (e) {
                    setState(() {
                      isImageChoosed = false;
                    });
                  }
                },
                child: Container(
                  child: Image.asset(
                    "images/camera_image.png",
                  ),
                  height: 50,
                  width: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
