import 'dart:io';

import 'package:bd_app_full/data/user_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class SetupPartnerTab extends StatefulWidget {
  @override
  _SetupPartnerTabState createState() => _SetupPartnerTabState();
}

class _SetupPartnerTabState extends State<SetupPartnerTab> {
  TextEditingController _timeOpenController = TextEditingController();
  TextEditingController _timeCloseController = TextEditingController();
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  String valueToValidate4 = '';
  String valueSaved4 = '';
  String valueChanged4 = '';
  bool isStoreOpenTimeSelected;
  bool isStoreCloseTimeSelected;
  final picker = ImagePicker();
  File imageFile;
  bool isImageChoosed;
  String _dropdownInitValue;
  List<String> _dropdownsItens;
  bool isCategorySelected;
  UserData user;
  @override
  void initState() {
    user = UserModel.of(context).userData;
    isImageChoosed = false;
    isCategorySelected = false;
    _dropdownsItens = [];
    _dropdownsItens.add("Escolha");
    UserModel.of(context).categoryList.forEach((category) {
      _dropdownsItens.add(category.title);
    });
    _dropdownInitValue = _dropdownsItens[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              double _imageSize = MediaQuery.of(context).size.width / 3;
              if (model.isLoading) {
                return Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: _imageSize,
                              width: _imageSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: isImageChoosed
                                      ? FileImage(imageFile)
                                      : model.userData.storeImage != null
                                          ? NetworkImage(
                                              model.userData.storeImage)
                                          : NetworkImage(imageUrl),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _onEditImagePressed();
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            child: Row(
                              children: [
                                Text("Horário de funcionamento"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.97,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Abre às",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: DateTimePicker(
                                            type: DateTimePickerType.time,
                                            controller: _timeOpenController,
                                            locale: Locale('pt', 'BR'),
                                            icon: Icon(
                                              Icons.access_time,
                                              size: 55,
                                            ),
                                            onChanged: (val) => setState(() {
                                              valueChanged4 = val;
                                              isStoreOpenTimeSelected = true;
                                            }),
                                            validator: (val) {
                                              setState(() {
                                                valueToValidate4 = val;
                                              });
                                              return null;
                                            },
                                            onSaved: (val) => setState(() {
                                              valueSaved4 = val;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Fecha às",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: DateTimePicker(
                                            type: DateTimePickerType.time,
                                            controller: _timeCloseController,
                                            locale: Locale('pt', 'BR'),
                                            icon: Icon(
                                              Icons.access_time,
                                              size: 55,
                                            ),
                                            onChanged: (val) => setState(() {
                                              valueChanged4 = val;
                                              isStoreCloseTimeSelected = true;
                                            }),
                                            validator: (val) {
                                              setState(
                                                  () => valueToValidate4 = val);
                                              return null;
                                            },
                                            onSaved: (val) => setState(() {
                                              valueSaved4 = val;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Categoria:     ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              DropdownButton<String>(
                                value: _dropdownInitValue,
                                icon: Icon(Icons.arrow_downward),
                                elevation: 16,
                                iconSize: 16,
                                underline: Container(
                                  height: 2,
                                  color: Colors.red,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _dropdownInitValue = newValue;
                                    isCategorySelected = true;
                                  });
                                },
                                items: _dropdownsItens.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.only(
                          bottom: 12,
                        ),
                        onPressed: () {},
                        child: Container(
                          width: _imageSize,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              "Atualizar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

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
                    Scaffold.of(context).hideCurrentSnackBar();
                  } catch (e) {
                    print(e);
                    setState(() {
                      isImageChoosed = false;
                    });
                    Scaffold.of(context).hideCurrentSnackBar();
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
                    Scaffold.of(context).hideCurrentSnackBar();
                  } catch (e) {
                    setState(() {
                      isImageChoosed = false;
                    });
                    Scaffold.of(context).hideCurrentSnackBar();
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
