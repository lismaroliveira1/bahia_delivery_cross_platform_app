import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/components.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class EditProductTab extends StatefulWidget {
  final ProductData productData;
  EditProductTab(this.productData);
  @override
  _EditProductTabState createState() => _EditProductTabState();
}

class _EditProductTabState extends State<EditProductTab> {
  String imageUrl = "";
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
  ProductData productData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    productData = widget.productData;
  }

  @override
  Widget build(BuildContext context) {
    double sizeImage = MediaQuery.of(context).size.width / 3;
    return Form(
      key: _formKey,
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
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    productData.productImage,
                                    height:
                                        MediaQuery.of(context).size.width / 3,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    fit: BoxFit.cover,
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
                                          MediaQuery.of(context).size.height /
                                              12,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
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
                                          TextButton(
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
                      controller: _nameController
                        ..text = productData.productTitle,
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
                        ..text = productData.productDescription,
                      decoration: InputDecoration(
                        labelText: "Descrição curta",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: TextField(
                      controller: _longDescriptionController
                        ..text = productData.fullDescription,
                      decoration: InputDecoration(
                        labelText: "Descrição longa",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: MediaQuery.of(context).size.width * 0.35,
                    ),
                    child: Container(
                      width: 110,
                      child: Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: TextField(
                          controller: _priceController
                            ..text =
                                productData.productPrice.toStringAsFixed(2),
                          decoration: InputDecoration(
                            labelText: "Preço",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
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
                        child: TextButton(
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
                        child: TextButton(
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
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: TextButton(
                      onPressed: () {
                        pageTransition(
                          context: context,
                          screen:
                              new RegisterNewOptIncrementScreen(productData),
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
                          child: Text(
                            "Complementos",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: TextButton(
                      onPressed: () {
                        productData.productTitle = _nameController.text;
                        productData.productDescription =
                            _descriptionController.text;
                        productData.productPrice = double.parse(
                            _priceController.text.replaceAll(",", "."));
                        UserModel.of(context).editPartnerProduct(
                          imageFile: isImageChoosed ? imageFile : null,
                          productData: productData,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: ScopedModelDescendant<UserModel>(
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
                    ),
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
    ScaffoldMessenger.of(context).showSnackBar(
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
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                              setState(() {
                                sectionStore = section;
                                productData.category = section.title;
                                productData.categoryId = section.id;
                              });
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Primeiro escolha a seção",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      _onSectionPressed();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
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
