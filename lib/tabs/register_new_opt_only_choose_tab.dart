import 'dart:io';

import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/input_new_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterNewOptOnlyChooseTab extends StatefulWidget {
  final ProductData productData;
  RegisterNewOptOnlyChooseTab(this.productData);
  @override
  _RegisterNewOptOnlyChooseTabState createState() =>
      _RegisterNewOptOnlyChooseTabState();
}

class _RegisterNewOptOnlyChooseTabState
    extends State<RegisterNewOptOnlyChooseTab> {
  bool isImageChoosed = false;
  File imageFile;
  final picker = ImagePicker();
  final String imageUrl =
      "https://www.meuvidraceiro.com.br/images/sem-imagem.png";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController maxQuantityController = TextEditingController();
  final TextEditingController minQuantityController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
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
                                fit: BoxFit.fill,
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
                            return Scaffold.of(context).showSnackBar(
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
                                      ),
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
                  InputNewProductWidget(
                    controller: titleController,
                    labelText: "Nome",
                    hintText: "",
                    maxLines: 1,
                  ),
                  InputNewProductWidget(
                    controller: descriptionController,
                    labelText: "Descrição",
                    hintText: null,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: InputNewProductWidget(
                          controller: priceController,
                          labelText: "Preço",
                          hintText: "1,99",
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InputNewProductWidget(
                          controller: maxQuantityController,
                          labelText: "Quantidade \nMáxima",
                          hintText: "",
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InputNewProductWidget(
                          controller: minQuantityController,
                          labelText: "Quantidade \nMínima",
                          hintText: "",
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  InputNewProductWidget(
                    controller: sessionController,
                    labelText: "Sessão",
                    hintText: null,
                    maxLines: 1,
                  ),
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
                              final incrementalOptData = new IncrementalOptData(
                                productId: widget.productData.id,
                                image: imageUrl,
                                title: titleController.text,
                                description: descriptionController.text,
                                maxQuantity: maxQuantity,
                                minQuantity: minQuantity,
                                price: price,
                                type: "onlyChoose",
                                session: sessionController.text,
                              );
                              model.insertNewOptOnlyChoose(
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
          )
        ],
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
