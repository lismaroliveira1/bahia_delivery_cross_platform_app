import 'dart:io';

import 'package:bd_app_full/components/components.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../blocs/blocs.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class InsertNewSectionTab extends StatefulWidget {
  @override
  _InsertNewSectionTabState createState() => _InsertNewSectionTabState();
}

class _InsertNewSectionTabState extends State<InsertNewSectionTab> {
  final _partnerSectionBloc = PartnerSectionBloc();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File imageFile;
  bool isImageChoosed;
  final picker = ImagePicker();
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  int position;
  int x;
  int y;
  String id = "";
  bool isFirstPostion;
  bool isSizeSelected;
  List<SubSectionData> subsections = [];
  @override
  void initState() {
    isSizeSelected = false;
    isFirstPostion = UserModel.of(context).sectionsStorePartnerList.length == 0;
    if (isFirstPostion) {
      position = 1;
    } else {
      position = UserModel.of(context).sectionsStorePartnerList.length + 1;
    }
    isImageChoosed = false;
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
              floating: false,
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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
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
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageUrl,
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: StreamBuilder<String>(
                    stream: _partnerSectionBloc.outName,
                    builder: (context, snapshot) {
                      return TextFormField(
                        onChanged: _partnerSectionBloc.changeName,
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nome",
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: StreamBuilder<String>(
                    stream: _partnerSectionBloc.outDescription,
                    builder: (context, snapshot) {
                      return TextFormField(
                        onChanged: _partnerSectionBloc.changeDescription,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                          labelText: "Descrição",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black38,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _onPositionPressed();
                            },
                            child: Text(
                              isFirstPostion
                                  ? "Posição 1º"
                                  : "Posição ${position.toString()}º",
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _onSizePressed();
                          },
                          child: Text(
                              isSizeSelected ? "Tamanho: $x:$y" : "Tamanho"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 35,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      pageTransition(
                        context: context,
                        screen: new SubSectionStoreScren(
                          [],
                          '',
                          true,
                        ),
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.add_circle),
                    title: Text("Subseções"),
                    subtitle: Text(
                      "Cadastre ou edite novas subseções nesta seção",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.35,
                ),
                child: StreamBuilder<bool>(
                  stream: _partnerSectionBloc.outSubmitValid,
                  builder: (context, snapshot) {
                    return Container(
                      margin: EdgeInsets.only(top: 40),
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: snapshot.hasData ? Colors.red : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 45,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: snapshot.hasData
                            ? () {
                                if (!isImageChoosed) {
                                  _onFailChoosedImage();
                                } else if (!isSizeSelected) {
                                  _onFailSizeSelected();
                                } else {
                                  final section = CategoryStoreData(
                                    description: _descriptionController.text,
                                    order: position - 1,
                                    title: _nameController.text,
                                    x: x,
                                    y: y,
                                    imageFile: imageFile,
                                  );
                                  UserModel.of(context).insertNewSection(
                                    section: section,
                                    onSuccess: _onSuccess,
                                    onFail: _onFail,
                                  );
                                }
                              }
                            : null,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            if (model.isLoading) {
                              return Container(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return SizedBox(
                                child: Text(
                                  "Criar",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          },
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
    );
  }

  void _onEditImagePressed() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
  }

  void _onSizePressed() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView(
            children: [
              Center(
                child: Text(
                  "Escohlha o tamanho",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 1;
                    y = 1;
                    isSizeSelected = true;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "1:1",
                  style: TextStyle(
                    color: x == 1 && y == 1 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 1;
                    y = 2;
                    isSizeSelected = true;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "1:2",
                  style: TextStyle(
                    color: x == 1 && y == 2 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 2;
                    y = 1;
                    isSizeSelected = true;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "2:1",
                  style: TextStyle(
                    color: x == 2 && y == 1 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    x = 2;
                    y = 2;
                    isSizeSelected = true;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  "2:2",
                  style: TextStyle(
                    color: x == 2 && y == 2 ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPositionPressed() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (isFirstPostion) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Essa é a primeira seção",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
            height: MediaQuery.of(context).size.height * 0.3,
            child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(
                            "Escohlha a posição",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          Container(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: Divider(
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: model.sectionsStorePartnerList.length + 1,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    position = index + 1;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "${index + 1}º",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: position == index + 1
                                            ? Colors.red
                                            : Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      );
    }
  }

  void _onFailChoosedImage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Você deve estar esquecendo a imagem",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFailSizeSelected() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Selecione o tamanho da seção",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFail() {}
  void _onSuccess() {
    Navigator.of(context).pop();
  }
}
