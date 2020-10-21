import 'dart:io';

import 'package:flutter/material.dart';

class EditProductTab extends StatefulWidget {
  @override
  _EditProductTabState createState() => _EditProductTabState();
}

class _EditProductTabState extends State<EditProductTab> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final bool _isImageChoosed = false;
  File _imageFile;
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 80),
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _isImageChoosed
                        ? Image.file(
                            _imageFile,
                            isAntiAlias: false,
                            height: MediaQuery.of(context).size.width / 3,
                            width: MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
