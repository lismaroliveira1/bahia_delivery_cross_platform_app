import 'dart:io';

import 'package:flutter/material.dart';

class RegisterNewOptOnlyChooseTab extends StatefulWidget {
  @override
  _RegisterNewOptOnlyChooseTabState createState() =>
      _RegisterNewOptOnlyChooseTabState();
}

class _RegisterNewOptOnlyChooseTabState
    extends State<RegisterNewOptOnlyChooseTab> {
  bool isImageChoosed = false;
  File imageFile;
  final String imageUrl =
      "https://www.meuvidraceiro.com.br/images/sem-imagem.png";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 120,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: isImageChoosed
                            ? Image.file(
                                imageFile,
                                isAntiAlias: false,
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                              )
                            : Image.network(
                                imageUrl,
                                isAntiAlias: false,
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                fit: BoxFit.fill,
                              ),
                      ),
                      Positioned(
                        bottom: 4.0,
                        right: 4.0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            return Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
