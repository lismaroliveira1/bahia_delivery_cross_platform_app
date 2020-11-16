import 'dart:io';

import 'package:bahia_delivery/data/store_categore_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/input_new_product_widget.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterNewCategoryTab extends StatefulWidget {
  @override
  _RegisterNewCategoryTabState createState() => _RegisterNewCategoryTabState();
}

class _RegisterNewCategoryTabState extends State<RegisterNewCategoryTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  File imageFile;
  bool isImageChoosed = false;
  int x;
  int y;
  int order;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    int listLength = UserModel.of(context).storesCategoresList.length;
    if (listLength == 0) {
      setState(() {
        order = 0;
      });
    }
    return Column(
      children: [
        Container(
          height: 80,
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
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 4.0,
                  right: 4.0,
                  child: IconButton(
                    onPressed: () {
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
                                    left:
                                        MediaQuery.of(context).size.width / 18,
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
                                    right:
                                        MediaQuery.of(context).size.width / 18,
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
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
          ),
        ),
        InputNewProductWidget(
          controller: _nameController,
          labelText: "Nome da Categoria",
          hintText: "Ex.: Massas",
          maxLines: 1,
        ),
        InputNewProductWidget(
          controller: _descriptionController,
          labelText: "Descrição",
          hintText: "",
          maxLines: 3,
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            height: 50,
            width: 120,
            child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading || !model.isLoggedIn()) {
                  return Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return FlatButton(
                    onPressed: () {
                      final categoreData = StoreCategoreData(
                        title: _nameController.text,
                        description: _descriptionController.text,
                        image: imageUrl,
                        imageFile: imageFile,
                      );
                      model.registerNewCategory(
                        storeCategoreData: categoreData,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                        x: x,
                        y: y,
                        noSize: _onPositionPressed,
                        order: order,
                      );
                    },
                    child: Center(
                      child: Text(
                        "Enviar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  void _onSuccess() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "Categoria criada com sucesso!",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
  }

  void _onFail() {}
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
          height: MediaQuery.of(context).size.height / 4,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        x = 2;
                        y = 2;
                      });
                      Scaffold.of(context).hideCurrentSnackBar();
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "2:2",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        x = 2;
                        y = 1;
                      });
                      Scaffold.of(context).hideCurrentSnackBar();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "2:1",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        x = 1;
                        y = 2;
                      });
                      Scaffold.of(context).hideCurrentSnackBar();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "1:2",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        x = 1;
                        y = 1;
                      });
                      Scaffold.of(context).hideCurrentSnackBar();
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "1:1",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSizeSetupPressed() {
    int listLenght = UserModel.of(context).storesCategoresList.length;
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      content: Container(
          height: 200,
          child: ListView.builder(
            itemCount: listLenght,
            itemBuilder: (context, index) {
              int position = index + 1;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border:
                          order == index ? Border.all(color: Colors.red) : null,
                    ),
                    child: ListTile(
                      title: Text(
                        "$position" + "º",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          order = index;
                        });
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                  listLenght == index + 1
                      ? Container(
                          decoration: BoxDecoration(
                            border: order == index + 1
                                ? Border.all(color: Colors.red)
                                : null,
                          ),
                          child: ListTile(
                            title: Text(
                              "${listLenght + 1}º",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                order = index + 1;
                              });
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                          ),
                        )
                      : Container(
                          height: 0,
                        )
                ],
              );
            },
          )),
    ));
  }

  void _onPositionPressedListLengthNull() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Container(
          height: 20,
          child: Text(
            "Posição já definida",
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
