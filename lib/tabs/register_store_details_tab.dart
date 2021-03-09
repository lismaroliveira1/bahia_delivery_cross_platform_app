import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/blocs.dart';
import '../data/data.dart';
import '../models/models.dart';

class RegisterStoreDetailsTab extends StatefulWidget {
  final RequestPartnerData requestPartnerData;
  RegisterStoreDetailsTab(this.requestPartnerData);
  @override
  _RegisterStoreDetailsTabState createState() =>
      _RegisterStoreDetailsTabState();
}

class _RegisterStoreDetailsTabState extends State<RegisterStoreDetailsTab> {
  final _registerPartnerBloc = RegisterPartnerBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _timeOpenController = TextEditingController();
  TextEditingController _timeCloseController = TextEditingController();
  String _dropdownInitValue;
  List<String> _dropdownsItens;
  bool isCategorySelected;
  bool isStoreOpenTimeSelected;
  bool isStoreCloseTimeSelected;
  bool isImageChoosed;
  File imageFile;
  String closeTime;
  String openTime;
  final ImagePicker _picker = ImagePicker();
  RequestPartnerData requestPartnerData;
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  @override
  void initState() {
    requestPartnerData = widget.requestPartnerData;
    isImageChoosed = false;
    _dropdownsItens = [];
    _dropdownsItens.add("Escolha");
    UserModel.of(context).categoryList.forEach((category) {
      _dropdownsItens.add(category.title);
    });
    isCategorySelected = false;
    isStoreOpenTimeSelected = false;
    isStoreCloseTimeSelected = false;
    _dropdownInitValue = _dropdownsItens[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _imageSize = MediaQuery.of(context).size.width / 3;
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Container(
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        height: _imageSize,
                        width: _imageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(
                              'images/logo_and_name.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Agora vamos falar \ndo seu negócio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Center(
                        child: Container(
                          height: _imageSize,
                          width: _imageSize,
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
                                            MediaQuery.of(context).size.width /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        imageUrl,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                bottom: 4.0,
                                right: 4.0,
                                child: IconButton(
                                  onPressed: () {
                                    _onEditImagePressed();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18),
                      child: StreamBuilder<String>(
                          stream: _registerPartnerBloc.outFantasyStoreName,
                          builder: (context, snapshot) {
                            return TextField(
                              controller: _nameController,
                              onChanged: _registerPartnerBloc.changeFantasyName,
                              decoration: InputDecoration(
                                hintText: "Loja tal",
                                labelText: 'Nome Fantasia',
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18),
                      child: StreamBuilder<String>(
                          stream: _registerPartnerBloc.outStoreDescription,
                          builder: (context, snapshot) {
                            return TextField(
                              onChanged: _registerPartnerBloc.changeDesription,
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "Loja tal",
                                labelText: 'Descrição',
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }),
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
                                  requestPartnerData.category = newValue;
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 40, 20, 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                width: MediaQuery.of(context).size.width / 3,
                                child: DateTimePicker(
                                  type: DateTimePickerType.time,
                                  controller: _timeOpenController,
                                  locale: Locale('pt', 'BR'),
                                  icon: Icon(
                                    Icons.access_time,
                                    size: 55,
                                  ),
                                  onChanged: (val) => setState(() {
                                    requestPartnerData.openTime = val;
                                    isStoreOpenTimeSelected = true;
                                  }),
                                  validator: (val) {
                                    setState(() {});
                                    return null;
                                  },
                                  onSaved: (val) => setState(() {}),
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
                                width: MediaQuery.of(context).size.width / 3,
                                child: DateTimePicker(
                                  type: DateTimePickerType.time,
                                  controller: _timeCloseController,
                                  locale: Locale('pt', 'BR'),
                                  icon: Icon(
                                    Icons.access_time,
                                    size: 55,
                                  ),
                                  onChanged: (val) => setState(() {
                                    requestPartnerData.closeTime = val;
                                    isStoreCloseTimeSelected = true;
                                  }),
                                  validator: (val) {
                                    return null;
                                  },
                                  onSaved: (val) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 3.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.red),
                              child: Center(
                                child: Text(
                                  "Cancelar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          StreamBuilder<bool>(
                            stream: _registerPartnerBloc.outSubmitValidSend,
                            builder: (context, snapshot) {
                              return FlatButton(
                                onPressed: snapshot.hasData &&
                                        isCategorySelected &&
                                        isStoreOpenTimeSelected &&
                                        isStoreCloseTimeSelected
                                    ? () {
                                        setState(() {
                                          requestPartnerData.fantasyName =
                                              _nameController.text;
                                          requestPartnerData.description =
                                              _descriptionController.text;
                                        });
                                        UserModel.of(context)
                                            .sendRequestForNewPartner(
                                          requestPartnerData:
                                              requestPartnerData,
                                          onSuccess: _onSuccess,
                                          onFail: _onFail,
                                          onFailImage: _onFailImage,
                                        );
                                        //onButtonSendPressed();
                                      }
                                    : null,
                                padding: EdgeInsets.zero,
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: snapshot.hasData &&
                                            isCategorySelected &&
                                            isStoreOpenTimeSelected &&
                                            isStoreCloseTimeSelected
                                        ? Colors.red
                                        : Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Enviar",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onButtonSendPressed() {
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
          height: MediaQuery.of(context).size.height * 0.8,
        ),
      ),
    );
  }

  void _onEditImagePressed() {
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    PickedFile _pickedFile = await _picker.getImage(
                      source: ImageSource.gallery,
                      maxHeight: 500,
                      maxWidth: 500,
                      imageQuality: 80,
                    );
                    if (_pickedFile == null) return;
                    imageFile = File(_pickedFile.path);
                    requestPartnerData.imageFile = File(_pickedFile.path);
                    if (imageFile == null) return;
                    setState(() {
                      isImageChoosed = true;
                    });
                  } catch (error) {
                    await FirebaseFirestore.instance.collection("errors").add({
                      "erro": "No get image register store details - Gallery" +
                          error.toString(),
                      "userId": UserModel.of(context).firebaseUser.uid,
                      "errorAt": DateTime.now(),
                    });
                    setState(() {
                      isImageChoosed = false;
                    });
                    retrieveLostData();
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    PickedFile _pickedFile = await _picker.getImage(
                      source: ImageSource.camera,
                      maxHeight: 500,
                      maxWidth: 500,
                      imageQuality: 80,
                    );
                    if (_pickedFile == null) return;
                    imageFile = File(_pickedFile.path);
                    requestPartnerData.imageFile = File(_pickedFile.path);
                    if (imageFile == null) return;
                    setState(() {
                      isImageChoosed = true;
                    });
                  } catch (error) {
                    await FirebaseFirestore.instance.collection("errors").add({
                      "erro": "No get image register store details - Camera" +
                          error.toString(),
                      "userId": UserModel.of(context).firebaseUser.uid,
                      "errorAt": DateTime.now(),
                    });
                    setState(() {
                      isImageChoosed = false;
                    });
                    retrieveLostData();
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

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
  void _onFailImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "É necessário fazer o upload da imagem",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      imageFile = File(response.file.path);
      setState(() {
        isImageChoosed = true;
      });
    } else {
      return;
    }
  }
}
