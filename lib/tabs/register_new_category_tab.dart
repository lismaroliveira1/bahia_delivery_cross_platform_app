import 'dart:io';

import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/input_new_product_widget.dart';
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
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {},
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
}
