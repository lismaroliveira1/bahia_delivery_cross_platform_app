import 'dart:io';

import 'package:bd_app_full/blocs/partner_section_bloc.dart';
import 'package:bd_app_full/data/category_store_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/subsection_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateProductTab extends StatefulWidget {
  @override
  _CreateProductTabState createState() => _CreateProductTabState();
}

class _CreateProductTabState extends State<CreateProductTab> {
  final _partnerBloc = PartnerSectionBloc();
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _longDescriptionController =
      TextEditingController();
  File imageFile;
  bool isImageChoosed = false;
  final picker = ImagePicker();
  CategoryStoreData sectionStore;
  SubSectionData subSectionData;
  ProductData productData = new ProductData(
    category: "",
    categoryId: "null",
    pId: "null",
    productDescription: "null",
    fullDescription: "null",
    productImage: "https://www.meuvidraceiro.com.br/images/sem-imagem.png",
    productPrice: 0,
    quantity: 0,
    productTitle: "",
    group: "",
    complementProducts: [],
    incrementalOptionalsList: [],
    storeId: "",
    totalPrice: 0,
  );

  String teste;
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double sizeImage = MediaQuery.of(context).size.width / 3;
    return Center(
      child: Container(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: isImageChoosed
                                ? Image.file(
                                    imageFile,
                                    isAntiAlias: false,
                                    height:
                                        MediaQuery.of(context).size.width / 3,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              12,
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
                    child: StreamBuilder<String>(
                        stream: _partnerBloc.outName,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _partnerBloc.changeName,
                            controller: _nameController,
                            decoration: InputDecoration(
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                labelText: "Nome",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: StreamBuilder<String>(
                        stream: _partnerBloc.outDescription,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _partnerBloc.changeDescription,
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: "Descrição curta",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: StreamBuilder<String>(
                        stream: _partnerBloc.outLongDescription,
                        builder: (context, snapshot) {
                          return TextField(
                            onChanged: _partnerBloc.changeLongDescription,
                            controller: _longDescriptionController,
                            decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: "Descrição longa",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Container(
                      width: 110,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.35,
                        ),
                        child: StreamBuilder<String>(
                            stream: _partnerBloc.outPrice,
                            builder: (context, snapshot) {
                              return TextField(
                                onChanged: _partnerBloc.changePrice,
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: "Preço",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            _onSectionPressed();
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
                                child: Text("Seção"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            _onSubSectionPressed();
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
                                child: Text("Subseção"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: StreamBuilder<bool>(
                        stream: _partnerBloc.outSubmitedProduct,
                        builder: (context, snapshot) {
                          return FlatButton(
                            onPressed: snapshot.hasData
                                ? () {
                                    productData.productTitle =
                                        _nameController.text;
                                    productData.productDescription =
                                        _descriptionController.text;
                                    productData.fullDescription =
                                        _longDescriptionController.text;
                                    productData.productPrice = double.parse(
                                      _priceController.text
                                          .replaceAll(",", "."),
                                    );

                                    UserModel.of(context).insertNewProduct(
                                      productData: productData,
                                      onSuccess: _onSuccess,
                                      onFail: _onFail,
                                      imageFile:
                                          isImageChoosed ? imageFile : null,
                                    );
                                  }
                                : null,
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                color:
                                    snapshot.hasData ? Colors.red : Colors.grey,
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
                                      "Enviar",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    );
                                  }
                                },
                              )),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSectionPressed() {
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
          height: 450.0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Seções",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                if (model.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: ListView(
                      children: model.sectionsStorePartnerList.map((section) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: section == sectionStore
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              productData.category = "";
                              setState(() {
                                sectionStore = section;
                                productData.category = section.title;
                                productData.categoryId = section.id;
                              });

                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                            title: Text(
                              section.title,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            leading: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    section.image,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              section.description,
                            ),
                            trailing: Text(
                              "${section.order}º",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  void _onSubSectionPressed() {
    if (sectionStore == null) {
      _onSectionPressed();
    } else {
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
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                ),
                Expanded(
                  child: ListView(
                    children: sectionStore.subSectionsList.map((subsection) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                subSectionData = subsection;
                                productData.group = subsection.title;
                              });
                              Scaffold.of(context).hideCurrentSnackBar();
                            },
                            title: Text(
                              subsection.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
