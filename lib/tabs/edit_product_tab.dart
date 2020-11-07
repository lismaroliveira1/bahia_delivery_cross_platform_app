import 'dart:io';

import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/optional_scren.dart';
import 'package:bahia_delivery/widgets/Input_product_parameters_widget.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class EditProductTab extends StatefulWidget {
  final ProductData productData;
  EditProductTab(this.productData);
  @override
  _EditProductTabState createState() => _EditProductTabState();
}

class _EditProductTabState extends State<EditProductTab> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isImageEdited = false;
  final _picker = ImagePicker();
  File _imageFile;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortDescriptionController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryControler = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController longDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isImageEdited
                              ? Image.file(
                                  _imageFile,
                                  isAntiAlias: false,
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.productData.image,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Positioned(
                          bottom: 4.0,
                          right: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.width / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Card(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12)),
                                        ),
                                        content: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FlatButton(
                                                onPressed: () async {
                                                  try {
                                                    final _pickedFile =
                                                        await _picker.getImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      maxHeight: 500,
                                                      maxWidth: 500,
                                                    );
                                                    if (_pickedFile == null)
                                                      return;
                                                    _imageFile =
                                                        File(_pickedFile.path);
                                                    setState(() {
                                                      isImageEdited = true;
                                                    });
                                                  } catch (erro) {
                                                    setState(() {
                                                      isImageEdited = false;
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
                                                onPressed: () async {
                                                  try {
                                                    final _pickedFile =
                                                        await _picker.getImage(
                                                      source:
                                                          ImageSource.camera,
                                                      maxHeight: 500,
                                                      maxWidth: 500,
                                                    );
                                                    if (_pickedFile == null)
                                                      return;
                                                    _imageFile =
                                                        File(_pickedFile.path);
                                                    setState(() {
                                                      isImageEdited = true;
                                                    });
                                                  } catch (erro) {
                                                    setState(() {
                                                      isImageEdited = false;
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
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  child: Container(
                    child: Column(
                      children: [
                        EditProductParameters(
                          controller: titleController,
                          initialText: widget.productData.title,
                          hintText: "Ex: Pizza",
                          labelText: "Nome",
                        ),
                        EditProductParameters(
                          controller: shortDescriptionController,
                          initialText: widget.productData.description,
                          hintText: "",
                          labelText: "Descrição Curta",
                        ),
                        EditProductParameters(
                          controller: longDescriptionController,
                          initialText: widget.productData.fullDescription,
                          hintText: "",
                          labelText: "Descrição Longa",
                          minLines: 3,
                          maxLines: 4,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: EditProductParameters(
                                controller: priceController,
                                initialText:
                                    widget.productData.price.toString(),
                                hintText: "19,99",
                                labelText: "Preço",
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: EditProductParameters(
                                controller: categoryControler,
                                initialText: widget.productData.category,
                                hintText: "Ex: pizzas",
                                labelText: "Categoria",
                              ),
                            )
                          ],
                        ),
                        EditProductParameters(
                          controller: sessionController,
                          initialText: widget.productData.group,
                          hintText: "Ex: pizzas salgadas",
                          labelText: "Sessão",
                        )
                      ],
                    ),
                  ),
                ),
                StoreHomeWigget(
                  icon: Icons.add_circle_outline_outlined,
                  name: "Opcionais",
                  description: "Crie ou edite complementos ou opções de compra",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => new OptionalScrenn(
                          widget.productData,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red,
                    ),
                    child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                        if (model.isLoading) {
                          return Container(
                            child: Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        } else {
                          return FlatButton(
                            onPressed: () {
                              double doublePrice =
                                  double.parse(priceController.text);
                              final productData = ProductData(
                                widget.productData.id,
                                titleController.text,
                                categoryControler.text,
                                shortDescriptionController.text,
                                "image",
                                doublePrice,
                                longDescriptionController.text,
                                sessionController.text,
                              );
                              model.editProduct(
                                productData: productData,
                                imageFile: _imageFile,
                                onSuccess: _onsSuccess,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onsSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}