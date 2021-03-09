import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/data.dart';
import '../models/models.dart';

class RegisterNewOptIncrementTab extends StatefulWidget {
  final ProductData productData;
  RegisterNewOptIncrementTab(this.productData);
  @override
  _RegisterNewOptIncrementTabState createState() =>
      _RegisterNewOptIncrementTabState();
}

class _RegisterNewOptIncrementTabState
    extends State<RegisterNewOptIncrementTab> {
  bool isImageChoosed = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController maxQuantityController = TextEditingController();
  final TextEditingController minQuantityController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final String imageUrl =
      "https://www.meuvidraceiro.com.br/images/sem-imagem.png";

  final picker = ImagePicker();
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                                ),
                        ),
                        Positioned(
                          bottom: 4.0,
                          right: 4.0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
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
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlatButton(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                18,
                                          ),
                                          onPressed: () async {
                                            try {
                                              final _pickedFile =
                                                  await picker.getImage(
                                                source: ImageSource.gallery,
                                                maxHeight: 500,
                                                maxWidth: 500,
                                              );
                                              if (_pickedFile == null) return;
                                              imageFile =
                                                  File(_pickedFile.path);
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
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                18,
                                          ),
                                          onPressed: () async {
                                            try {
                                              final _pickedFile =
                                                  await picker.getImage(
                                                source: ImageSource.camera,
                                                maxHeight: 500,
                                                maxWidth: 500,
                                              );
                                              if (_pickedFile == null) return;
                                              imageFile =
                                                  File(_pickedFile.path);
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Nome",
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Descrição",
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: priceController,
                            decoration: InputDecoration(
                                labelText: "Preço", hintText: "1.99"),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: maxQuantityController,
                            decoration: InputDecoration(
                                labelText: "Quantidade\nmáxima"),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: maxQuantityController,
                            decoration: InputDecoration(
                                labelText: "Quantidade\nmáxima"),
                          ),
                        )
                      ],
                    ),
                    //TODO colocar as sessões11
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          if (model.isLoading) {
                            return Container(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            );
                          } else {
                            return FlatButton(
                              onPressed: () {
                                final int maxQuantity =
                                    int.parse(maxQuantityController.text);
                                final int minQuantity =
                                    int.parse(minQuantityController.text);
                                final double price =
                                    double.parse(priceController.text);
                                final incrementalOptData =
                                    IncrementalOptionalsData(
                                  productId: widget.productData.pId,
                                  session: null,
                                  image: isImageChoosed ? null : imageUrl,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  maxQuantity: maxQuantity,
                                  minQuantity: minQuantity,
                                  price: price,
                                  type: "optmal",
                                );
                                model.insertOptIncrement(
                                  imageFile: isImageChoosed ? imageFile : null,
                                  incrementalOptData: incrementalOptData,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail,
                                );
                              },
                              child: Text(
                                "Inserir",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _onSuccess() {}
  void _onFail() {}
}
