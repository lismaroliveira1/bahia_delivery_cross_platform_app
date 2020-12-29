import 'dart:io';

import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class EditComboTab extends StatefulWidget {
  final ComboData comboData;
  EditComboTab(this.comboData);
  @override
  _EditComboTabState createState() => _EditComboTabState();
}

class _EditComboTabState extends State<EditComboTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File imageFile;
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  bool isImageChoosed = false;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  List<ProductData> products = [];
  @override
  void initState() {
    products = widget.comboData.products;
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
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              children: [
                Center(
                  child: Container(
                    height: sizeImage,
                    width: sizeImage,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: sizeImage,
                          width: sizeImage,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: isImageChoosed
                                  ? FileImage(imageFile)
                                  : NetworkImage(
                                      widget.comboData.image,
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4.0,
                          right: 4.0,
                          child: IconButton(
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
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 12,
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
                                            right: MediaQuery.of(context)
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
                            icon: Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: TextField(
                    controller: _nameController..text = widget.comboData.title,
                    decoration: InputDecoration(
                        labelText: "Nome",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: TextField(
                    controller: _descriptionController
                      ..text = widget.comboData.description,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Container(
                        width: 110,
                        child: Padding(
                          padding: EdgeInsets.only(right: 3),
                          child: TextField(
                            controller: _discountPercentageController
                              ..text = widget.comboData.discountPercentage
                                  .toString(),
                            decoration: InputDecoration(
                              hintText: "20%",
                              labelText: "Desconto",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      _onProductButtonPressed();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black38,
                          )),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(18),
                        child: Center(
                          child: Text("Produtos"),
                        ),
                      ),
                    ),
                  ),
                ),
                products.isNotEmpty
                    ? Expanded(
                        child: Column(
                          children: products.map((product) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(product.productTitle),
                                  subtitle: Text(product.productDescription),
                                  leading: Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          product.productImage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                FlatButton(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  onPressed: () {
                    double discountPercentage =
                        double.parse(_discountPercentageController.text);
                    final comboData = ComboData(
                      id: widget.comboData.id,
                      image: imageUrl,
                      title: _nameController.text,
                      description: _descriptionController.text,
                      discountPercentage: discountPercentage,
                      products: products,
                    );
                    UserModel.of(context).editPartnerCombo(
                      comboData: comboData,
                      onSuccess: _onSuccess,
                      onFail: _onFail,
                      imageFile: isImageChoosed ? imageFile : null,
                    );
                  },
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          if (model.isLoading) {
                            return Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Text(
                              "Atualizar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
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
      ),
    );
  }

  void _onProductButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(
          minutes: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        content: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  if (model.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              'Escolha o produto',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(
                              top: 12.0,
                            ),
                            children: model.productsPartnerList.map((product) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 6.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        products.add(product);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                    dense: true,
                                    title: Text(
                                      product.productTitle,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    subtitle: Text(
                                      product.productDescription,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    leading: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              product.productImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    trailing:
                                        Text("R\$ ${product.productPrice}"),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
