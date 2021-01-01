import 'dart:io';

import 'package:bd_app_full/data/category_store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/subsections_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class EditSectionTab extends StatefulWidget {
  final CategoryStoreData categoryStoreData;
  EditSectionTab(this.categoryStoreData);
  @override
  _EditSectionTabState createState() => _EditSectionTabState();
}

class _EditSectionTabState extends State<EditSectionTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File imageFile;
  bool isImageChoosed;
  final picker = ImagePicker();
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  int position;
  int x;
  int y;
  String id = "";
  int olderPos;

  @override
  void initState() {
    isImageChoosed = false;
    imageFile = null;
    id = widget.categoryStoreData.id;
    position = widget.categoryStoreData.order + 1;
    olderPos = position;
    x = widget.categoryStoreData.x;
    y = widget.categoryStoreData.y;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeImage = MediaQuery.of(context).size.width / 3;
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              floating: false,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    height: sizeImage,
                    width: sizeImage,
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
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.categoryStoreData.image,
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 4.0,
                          right: 4.0,
                          child: IconButton(
                            onPressed: () {
                              _onEditImagePressed();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: TextFormField(
                  controller: _nameController
                    ..text = widget.categoryStoreData.title,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: TextFormField(
                  controller: _descriptionController
                    ..text = widget.categoryStoreData.description,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black38,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _onPositionPressed();
                            },
                            child: Text("Posição $position" + "º"),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _onSizePressed();
                          },
                          child: Text("Tamanho $x:$y"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 35,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: SubSectionStoreScren(
                            widget.categoryStoreData.subSectionsList,
                            widget.categoryStoreData.id,
                            false,
                          ),
                          inheritTheme: true,
                          duration: Duration(
                            milliseconds: 350,
                          ),
                          ctx: context,
                        ),
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.add_circle),
                    title: Text("Subseções"),
                    subtitle: Text(
                      "Cadastre ou edite novas subseções nesta seção",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(26.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 45,
                  child: FlatButton(
                    onPressed: () {},
                    child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                        if (model.isLoading) {
                          return Container(
                            height: 20,
                            width: 20,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return Text(
                            "Atualizar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPositionPressed() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(
                          "Escohlha a posição",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                      child: Divider(
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: model.sectionsStorePartnerList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  position = index + 1;
                                });
                                Scaffold.of(context).hideCurrentSnackBar();
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${index + 1}º",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: position == index + 1
                                          ? Colors.red
                                          : Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onSizePressed() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView(
            children: [
              Center(
                child: Text(
                  "Escohlha o tamanho",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 1;
                    y = 1;
                  });
                  Scaffold.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "1:1",
                  style: TextStyle(
                    color: x == 1 && y == 1 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 1;
                    y = 2;
                  });
                  Scaffold.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "1:2",
                  style: TextStyle(
                    color: x == 1 && y == 2 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 2;
                    y = 1;
                  });
                  Scaffold.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "2:1",
                  style: TextStyle(
                    color: x == 2 && y == 1 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 2;
                    y = 2;
                  });
                  Scaffold.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "2:2",
                  style: TextStyle(
                    color: x == 2 && y == 2 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}

  void _onEditImagePressed() {
    Scaffold.of(context).showSnackBar(
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
              FlatButton(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 18,
                ),
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
              FlatButton(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 18,
                ),
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
