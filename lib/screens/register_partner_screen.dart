import 'dart:io';

import 'package:bahia_delivery/data/store_with_cpf_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/input_store_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class PartnerRegisterScreen extends StatefulWidget {
  @override
  _PartnerRegisterScreenState createState() => _PartnerRegisterScreenState();
}

class _PartnerRegisterScreenState extends State<PartnerRegisterScreen> {
  File imageFile;
  bool isJuridicPerson = false;
  String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  final picker = ImagePicker();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController socialNameController = TextEditingController();
  final TextEditingController fantasyNameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final StoreCPF storeCPF = StoreCPF();
  bool isImageChoosed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 100,
              ),
              Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.transparent),
                          child: Stack(
                            children: [
                              Container(
                                height: 150.0,
                                width: 150.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: isImageChoosed
                                      ? Image.file(
                                          imageFile,
                                          isAntiAlias: false,
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(imageUrl),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: IconButton(
                                  onPressed: () {
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                        ),
                                        content: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        source:
                                                            ImageSource.gallery,
                                                        maxHeight: 500,
                                                        maxWidth: 500,
                                                      );
                                                      if (_pickedFile == null)
                                                        return;
                                                      imageFile = File(
                                                        _pickedFile.path,
                                                      );
                                                      if (imageFile == null)
                                                        return;
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
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            18,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      final _pickedFile =
                                                          await picker.getImage(
                                                        source:
                                                            ImageSource.camera,
                                                        maxHeight: 500,
                                                        maxWidth: 500,
                                                      );
                                                      if (_pickedFile == null)
                                                        return;
                                                      imageFile = File(
                                                          _pickedFile.path);
                                                      if (imageFile == null)
                                                        return;
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
                                            )),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.camera_alt),
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      onPressed: () {
                        setState(() {
                          isJuridicPerson = false;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.ac_unit),
                          ),
                          Text("Pessoa Físca"),
                        ],
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      onPressed: () {
                        setState(() {
                          isJuridicPerson = true;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.ac_unit),
                          ),
                          Text("Pessoa Jurídica"),
                        ],
                      ),
                    ),
                    isJuridicPerson
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Nome Fantasia",
                                  controller: fantasyNameController,
                                ),
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Razão Social",
                                  controller: socialNameController,
                                ),
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Descrição",
                                  controller: descriptionController,
                                ),
                                InputStoreData(
                                  hintText: "00.000.000/0000-00 ",
                                  labelText: "CNPJ",
                                  controller: cnpjController,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Endereço",
                                      ),
                                    ),
                                  ],
                                ),
                                InputStoreData(
                                  hintText: "00000-000",
                                  labelText: "CEP",
                                  controller: zipCodeController,
                                ),
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Logradouro",
                                  controller: streetController,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: InputStoreData(
                                          labelText: "Bairro",
                                          hintText: "",
                                          controller: districtController),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: InputStoreData(
                                        labelText: "Número",
                                        hintText: "123",
                                        controller: numberController,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: InputStoreData(
                                        labelText: "Cidade",
                                        hintText: "",
                                        controller: cityController,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: InputStoreData(
                                        labelText: "Estado",
                                        hintText: "123",
                                        controller: stateController,
                                      ),
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(8),
                                  onPressed: () {},
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "Enviar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Nome da loja",
                                  controller: nameController,
                                ),
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Descrição",
                                  controller: descriptionController,
                                ),
                                InputStoreData(
                                  hintText: "000.000.000-00",
                                  labelText: "CPF",
                                  controller: cpfController,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Endereço",
                                      ),
                                    ),
                                  ],
                                ),
                                InputStoreData(
                                  hintText: "00000-000",
                                  labelText: "CEP",
                                  controller: zipCodeController,
                                ),
                                InputStoreData(
                                  hintText: "",
                                  labelText: "Logradouro",
                                  controller: streetController,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: InputStoreData(
                                        labelText: "Bairro",
                                        hintText: "",
                                        controller: districtController,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: InputStoreData(
                                        labelText: "Número",
                                        hintText: "123",
                                        controller: numberController,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: InputStoreData(
                                        labelText: "Cidade",
                                        hintText: "",
                                        controller: cityController,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: InputStoreData(
                                        labelText: "Estado",
                                        hintText: "123",
                                        controller: stateController,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.red,
                                  ),
                                  height: 50,
                                  width: 120,
                                  child: ScopedModelDescendant<UserModel>(
                                      builder: (context, child, model) {
                                    if (model.isLoading) {
                                      return Center(
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return FlatButton(
                                        padding: EdgeInsets.all(8),
                                        onPressed: () async {
                                          if (isJuridicPerson) {
                                          } else {
                                            final storeCPF = StoreCPF(
                                              name: nameController.text,
                                              description:
                                                  descriptionController.text,
                                              cpf: cpfController.text,
                                              zipCode: zipCodeController.text,
                                              street: streetController.text,
                                              district: districtController.text,
                                              number: numberController.text,
                                              city: cityController.text,
                                              state: stateController.text,
                                              image: imageUrl,
                                            );

                                            await UserModel.of(context)
                                                .createNewStoreWithCPF(
                                              imageFile: imageFile,
                                              storeCPF: storeCPF,
                                              onSuccess: _onSuccess,
                                              onFail: _onFail,
                                            );
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              "Enviar",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.red),
                                        ),
                                      );
                                    }
                                  }),
                                )
                              ],
                            )),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  void _onSuccess() {}

  void _onFail() {}
}
