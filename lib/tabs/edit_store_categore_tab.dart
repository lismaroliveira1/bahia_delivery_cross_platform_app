import 'dart:io';

import 'package:bahia_delivery/data/store_categore_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/Input_product_parameters_widget.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class EditStoreCategoreTab extends StatefulWidget {
  final StoreCategoreData storeCategoreData;
  EditStoreCategoreTab(this.storeCategoreData);

  @override
  _EditStoreCategoreTabState createState() => _EditStoreCategoreTabState();
}

class _EditStoreCategoreTabState extends State<EditStoreCategoreTab> {
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
                          widget.storeCategoreData.image,
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
        EditProductParameters(
          controller: _nameController,
          initialText: widget.storeCategoreData.title,
          hintText: "Ex: Pizza",
          labelText: "Nome da Categoria",
        ),
        EditProductParameters(
          controller: _descriptionController,
          initialText: widget.storeCategoreData.description,
          hintText: "Ex: Pizza",
          labelText: "Nome da Categoria",
          minLines: 3,
          maxLines: 4,
        ),
        StoreHomeWigget(
          icon: Icons.photo_size_select_large,
          name: "Tamanho",
          description: "Configure que esta categoria aparecerá na sua loja",
          onPressed: () {},
        ),
        StoreHomeWigget(
          icon: Icons.format_list_numbered,
          name: "Posição",
          description: "Configure a posição desta categoria na sua loja",
          onPressed: () {},
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
                      print(widget.storeCategoreData.id);
                      final storeCategoreData = StoreCategoreData(
                        id: widget.storeCategoreData.id,
                        title: _nameController.text,
                        description: _descriptionController.text,
                        image: widget.storeCategoreData.image,
                        imageFile: isImageChoosed ? imageFile : null,
                      );
                      model.updateStoreCategore(
                        storeCategoreData: storeCategoreData,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                      );
                    },
                    child: Center(
                      child: Text(
                        "Atualizar",
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
    print("ok");
  }

  void _onFail() {}
}
