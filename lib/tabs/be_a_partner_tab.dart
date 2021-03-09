import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:cnpj_cpf_formatter/cnpj_cpf_formatter.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../blocs/blocs.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class BeAPartnerTab extends StatefulWidget {
  @override
  _BeAPartnerTabState createState() => _BeAPartnerTabState();
}

class _BeAPartnerTabState extends State<BeAPartnerTab> {
  final _registerPartnerBloc = RegisterPartnerBloc();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _transitBoardController = TextEditingController();
  TextEditingController _vehicleColorController = TextEditingController();
  TextEditingController _transitCardController = TextEditingController();
  TextEditingController _timeOpenController = TextEditingController();
  TextEditingController _timeCloseController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  TextEditingController _fantasyNameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCategorySelected;
  TextEditingController _descriptionController = TextEditingController();
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  DateTime _selectedDate;
  List<String> _dropdownsItens;
  String _dropdownInitValue;
  String _textDate;
  bool isBirthDayChoosed;
  bool isLocationChoosed;
  bool isImageChoosed;
  bool isImageDriverChoosed;
  File imageDriverFile;
  File imageFile;
  String valueToValidate4 = '';
  String valueSaved4 = '';
  String valueChanged4 = '';
  String _dropDownInitiValueMot;
  bool isTypeVehicleChoosed;
  final picker = ImagePicker();
  List<String> dropdownList = [];
  Timer _timer;
  int screen;
  double _height;
  double _width;
  double _imageSize;
  bool isStoreOpenTimeSelected;
  bool isStoreCloseTimeSelected;
  RequestPartnerData requestPartnerData;

  bool isShippingDateSelected;
  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    isTypeVehicleChoosed = false;
    _textDate = "";
    isBirthDayChoosed = false;
    isImageChoosed = false;
    isImageDriverChoosed = false;
    _dropdownsItens = [];
    _dropdownsItens.add("Escolha");
    UserModel.of(context).categoryList.forEach((category) {
      _dropdownsItens.add(category.title);
    });
    dropdownList = [
      "Tipo do Veículo",
      "Motorizado",
      "Não motorizado",
    ];
    _dropDownInitiValueMot = dropdownList[0];
    isLocationChoosed =
        UserModel.of(context).isLocationChoosedOnRegisterPartner;
    _dropdownInitValue = _dropdownsItens[0];
    screen = 1;
    isCategorySelected = false;
    isStoreOpenTimeSelected = false;
    isStoreCloseTimeSelected = false;
    isShippingDateSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height * 0.25;
    _width = MediaQuery.of(context).size.width * 0.4;
    _imageSize = MediaQuery.of(context).size.width / 3;
    if (screen == 1) {
      return _home();
    } else if (screen == 2) {
      return _deliveryManRegisterWidget();
    } else if (screen == 3) {
      return _partnerRegisterWidget();
    } else if (screen == 4) {
      return _registerPartnerWithCPF();
    } else if (screen == 5) {
      return _registerPartnerWithCNPJ();
    } else if (screen == 6) {
      return _registerPartnerDetails();
    } else {
      return Container();
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value;
      _textDate = _selectedDate.day.toString() +
          '/' +
          _selectedDate.month.toString() +
          '/' +
          _selectedDate.year.toString();
      isBirthDayChoosed = true;
    });
    setState(() {
      isShippingDateSelected = true;
    });
    Navigator.of(context).pop();
  }

  void noChoosedBiryhDay() {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          "Escolha a data de nascimento",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(
          seconds: 1,
        ),
      ),
    );
  }

  void noChoosedLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          "Escolha a localização da loja",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: new Duration(seconds: 1),
      ),
    );
  }

  void noChoosedLocationAndBirthDay() {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          "Escolha a localização da loja e a sua data de nascimento",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
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
                      if (screen != 2) {
                        requestPartnerData.imageFile = imageFile;
                      }
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  } catch (e) {
                    print(e);
                    setState(() {
                      isImageChoosed = false;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                    if (screen != 2) {
                      requestPartnerData.imageFile = imageFile;
                    }
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  } catch (e) {
                    setState(() {
                      isImageChoosed = false;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}

  void onPhotoDriverPressed() {
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
                    imageDriverFile = File(_pickedFile.path);

                    if (imageDriverFile == null) return;
                    setState(() {
                      isImageDriverChoosed = true;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  } catch (e) {
                    setState(() {
                      isImageDriverChoosed = false;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                    imageDriverFile = File(_pickedFile.path);
                    if (imageDriverFile == null) return;
                    setState(() {
                      isImageDriverChoosed = true;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  } catch (e) {
                    setState(() {
                      isImageChoosed = false;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  void _onFailDriverImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "É necessário fazer o upload da sua foto com a sua carteira de motorista",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFailTypeVehycle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "É necessário Escolher o tipo do veículo",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _home() {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrroled) {
          return <Widget>[];
        },
        body: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Column(
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
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  'Qual a sua modalidade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () async {
                        _timer?.cancel();
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        await EasyLoading.dismiss();
                        setState(() {
                          screen = 3;
                        });
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          height: _height,
                          width: _width,
                          child: Center(
                            child: Text(
                              "Parceiro",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        _timer?.cancel();
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        await EasyLoading.dismiss();
                        setState(() {
                          screen = 2;
                        });
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          height: _height,
                          width: _width,
                          child: Center(
                            child: Text(
                              "Entregador",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deliveryManRegisterWidget() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Container(
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
                          'Deixe-nos saber \n mais sobre você',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 12.0),
                              height: _imageSize,
                              width: _imageSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: !isImageChoosed
                                      ? AssetImage(
                                          'images/user_no_image.png',
                                        )
                                      : FileImage(imageFile),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _onEditImagePressed();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18),
                        child: StreamBuilder<Object>(
                            stream: _registerPartnerBloc.outOwnerName,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: _nameController,
                                onChanged: _registerPartnerBloc.changeOWnerName,
                                decoration: InputDecoration(
                                  hintText: "Fulano de tal",
                                  labelText: 'Nome Completo',
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }),
                      ),
                      StreamBuilder<String>(
                          stream: _registerPartnerBloc.outCPF,
                          builder: (context, snapshot) {
                            return Container(
                              margin: EdgeInsets.only(top: 18),
                              child: TextField(
                                onChanged: _registerPartnerBloc.changeCPF,
                                controller: _cpfController,
                                inputFormatters: [
                                  CnpjCpfFormatter(
                                    eDocumentType: EDocumentType.CPF,
                                  )
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '000.000.000-00',
                                  labelText: 'CPF',
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          }),
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Selecione sua data \nde nascimento",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SfDateRangePicker(
                                            onSelectionChanged:
                                                _onSelectionChanged,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .single,
                                            initialSelectedRange:
                                                PickerDateRange(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 4)),
                                                    DateTime.now()
                                                        .add(const Duration(
                                                            days: 3))),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.red,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancelar",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Icon(
                                  Icons.perm_contact_calendar,
                                  size: MediaQuery.of(context).size.width / 4,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                "Nascimento",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _textDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: RegisterAddressScreen(),
                                inheritTheme: true,
                                duration: Duration(
                                  milliseconds: 350,
                                ),
                                ctx: context,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: MediaQuery.of(context).size.width / 4,
                                  color: Colors.black45,
                                ),
                              ),
                              ScopedModelDescendant<UserModel>(
                                  builder: (context, child, model) {
                                return Column(
                                  children: [
                                    Text(
                                      "Localização",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "${model.addressToRegisterPartner}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: _dropDownInitiValueMot,
                            icon: Icon(
                              Icons.arrow_downward,
                            ),
                            elevation: 16,
                            iconSize: 16,
                            underline: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width / 2,
                              color: Colors.red,
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _dropDownInitiValueMot = value;
                                isTypeVehicleChoosed = true;
                              });
                            },
                            items: dropdownList
                                .map((type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                      _dropDownInitiValueMot == "Motorizado"
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.2,
                                    child: Column(
                                      children: [
                                        FlatButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            onPhotoDriverPressed();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black45,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: isImageDriverChoosed
                                                    ? FileImage(imageDriverFile)
                                                    : AssetImage(
                                                        'images/user_and_id.png',
                                                      ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Envie uma foto com seu documento de identificação",
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Container(
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: TextField(
                                              controller:
                                                  _transitBoardController,
                                              decoration: InputDecoration(
                                                labelText: 'Placa do veículo',
                                                hintText: 'AAA-0000',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: TextField(
                                              controller:
                                                  _transitCardController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Nº Cateira de habilitação',
                                                hintText: '00123456789',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Container(
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: TextField(
                                              controller:
                                                  _vehicleColorController,
                                              decoration: InputDecoration(
                                                labelText: 'Cor do veículo',
                                                hintText: 'branca',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 26),
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
                            ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                                if (model.isLoading) {
                                  return Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return StreamBuilder<bool>(
                                    stream:
                                        _registerPartnerBloc.outSubmitValidCPF,
                                    builder: (context, snapshot) {
                                      return FlatButton(
                                        onPressed: snapshot.hasData
                                            ? () {
                                                if (!isLocationChoosed &&
                                                    !isBirthDayChoosed) {
                                                  noChoosedLocationAndBirthDay();
                                                } else if (!isBirthDayChoosed) {
                                                  noChoosedBiryhDay();
                                                } else if (!model
                                                    .isLocationChoosedOnRegisterPartner) {
                                                  noChoosedLocation();
                                                } else if (!isImageChoosed) {
                                                  _onFailImage();
                                                } else if (!isTypeVehicleChoosed) {
                                                  _onFailTypeVehycle();
                                                } else if (_dropDownInitiValueMot ==
                                                        "Motorizado" &&
                                                    !isImageDriverChoosed) {
                                                  _onFailDriverImage();
                                                } else {
                                                  final deliveryManDatta =
                                                      DeliveryManData(
                                                    driverImageFile:
                                                        imageDriverFile,
                                                    transitBoard:
                                                        _transitBoardController
                                                            .text,
                                                    vehycleColor:
                                                        _vehicleColorController
                                                            .text,
                                                    vehycleType:
                                                        _dropDownInitiValueMot,
                                                    transitId:
                                                        _transitCardController
                                                            .text,
                                                    birthDay: _selectedDate,
                                                    cpf: _cpfController.text,
                                                    imageFile: imageFile,
                                                    lat: null,
                                                    lng: null,
                                                    location: null,
                                                    locationId: null,
                                                    name: _nameController.text,
                                                    image: null,
                                                  );
                                                  UserModel.of(context)
                                                      .sendRequestForNewDeliveryMan(
                                                    deliveryManData:
                                                        deliveryManDatta,
                                                    onSuccess: _onSuccess,
                                                    onFail: _onFail,
                                                  );
                                                }
                                              }
                                            : null,
                                        padding: EdgeInsets.zero,
                                        child: model.isLoading
                                            ? Center(
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: snapshot.hasData &&
                                                          isBirthDayChoosed &&
                                                          model
                                                              .isLocationChoosedOnRegisterPartner
                                                      ? Colors.red
                                                      : Colors.grey[300],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Enviar",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _partnerRegisterWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                padding: const EdgeInsets.only(top: 80.0),
                child: Text(
                  'Você é pessoa\nfísica ou jurídica?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () async {
                        _timer?.cancel();
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        await EasyLoading.dismiss();
                        setState(() {
                          screen = 4;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red),
                        child: Center(
                          child: Text(
                            "Sou pessoa física \n uso CPF",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        _timer?.cancel();
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        await EasyLoading.dismiss();
                        setState(() {
                          screen = 5;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red),
                        child: Center(
                          child: Text(
                            "Sou pessoa jurídica \n uso CNPJ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerPartnerWithCPF() {
    return SafeArea(
      child: Form(
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
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text(
                          'Deixe-nos saber \n mais sobre você',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18),
                        child: StreamBuilder<Object>(
                            stream: _registerPartnerBloc.outOwnerName,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: _nameController,
                                onChanged: _registerPartnerBloc.changeOWnerName,
                                decoration: InputDecoration(
                                  hintText: "Fulano de tal",
                                  labelText: 'Nome Completo',
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }),
                      ),
                      StreamBuilder<String>(
                          stream: _registerPartnerBloc.outCPF,
                          builder: (context, snapshot) {
                            return Container(
                              margin: EdgeInsets.only(top: 18),
                              child: TextField(
                                onChanged: _registerPartnerBloc.changeCPF,
                                controller: _cpfController,
                                inputFormatters: [
                                  CnpjCpfFormatter(
                                    eDocumentType: EDocumentType.CPF,
                                  )
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '000.000.000-00',
                                  labelText: 'CPF',
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          }),
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Selecione sua data \nde nascimento",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SfDateRangePicker(
                                            onSelectionChanged:
                                                _onSelectionChanged,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .single,
                                            initialSelectedRange:
                                                PickerDateRange(
                                              DateTime.now().subtract(
                                                  const Duration(days: 4)),
                                              DateTime.now().add(
                                                const Duration(
                                                  days: 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.red),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancelar",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Icon(
                                  Icons.perm_contact_calendar,
                                  size: MediaQuery.of(context).size.width / 4,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                "Nascimento",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _textDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: RegisterAddressScreen(),
                                inheritTheme: true,
                                duration: Duration(
                                  milliseconds: 350,
                                ),
                                ctx: context,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: MediaQuery.of(context).size.width / 4,
                                  color: Colors.black45,
                                ),
                              ),
                              ScopedModelDescendant<UserModel>(
                                  builder: (context, child, model) {
                                return Column(
                                  children: [
                                    Text(
                                      "Localização",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "${model.addressToRegisterPartner}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 80, 20, 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
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
                            ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                                return StreamBuilder<bool>(
                                    stream:
                                        _registerPartnerBloc.outSubmitValidCPF,
                                    builder: (context, snapshot) {
                                      return FlatButton(
                                        onPressed: snapshot.hasData
                                            ? () async {
                                                if (!isLocationChoosed &&
                                                    !isBirthDayChoosed) {
                                                  noChoosedLocationAndBirthDay();
                                                } else if (!isBirthDayChoosed) {
                                                  noChoosedBiryhDay();
                                                } else if (!model
                                                    .isLocationChoosedOnRegisterPartner) {
                                                  noChoosedLocation();
                                                } else {
                                                  final requestPartnerDataFlag =
                                                      RequestPartnerData(
                                                    companyName:
                                                        _nameController.text,
                                                    ownerName:
                                                        _nameController.text,
                                                    cpf: _cpfController.text,
                                                    birthDay: _selectedDate,
                                                    isJuridicPerson: false,
                                                    location: UserModel.of(
                                                            context)
                                                        .addressToRegisterPartner,
                                                  );
                                                  _timer?.cancel();
                                                  await EasyLoading.show(
                                                    status: 'loading...',
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black,
                                                  );
                                                  await EasyLoading.dismiss();
                                                  setState(() {
                                                    requestPartnerData =
                                                        requestPartnerDataFlag;
                                                    screen = 6;
                                                  });
                                                }
                                              }
                                            : null,
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: snapshot.hasData &&
                                                    isBirthDayChoosed &&
                                                    model
                                                        .isLocationChoosedOnRegisterPartner
                                                ? Colors.red
                                                : Colors.grey[300],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Próximo",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerPartnerDetails() {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[];
        },
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              ListView(
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
                                          MediaQuery.of(context).size.width / 3,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      imageUrl,
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
                            controller: _fantasyNameController,
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
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.97,
                      child: Center(
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
                                      valueChanged4 = val;
                                      requestPartnerData.openTime = val;
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
                                      valueChanged4 = val;
                                      requestPartnerData.closeTime = val;
                                      isStoreCloseTimeSelected = true;
                                    }),
                                    validator: (val) {
                                      setState(() => valueToValidate4 = val);
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 26),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.97,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
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
                            Container(
                              child: StreamBuilder<bool>(
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
                                                  _fantasyNameController.text;
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
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
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
                                        child: ScopedModelDescendant<UserModel>(
                                          builder: (context, child, model) {
                                            if (model.isLoading) {
                                              return Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Text(
                                                "Enviar",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                          },
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerPartnerWithCNPJ() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScolled) {
        return <Widget>[];
      },
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
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
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Text(
                      'Deixe-nos saber mais\nsobre seu negócio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 18),
                    child: StreamBuilder<Object>(
                        stream: _registerPartnerBloc.outOwnerName,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _companyNameController,
                            onChanged: _registerPartnerBloc.changeOWnerName,
                            decoration: InputDecoration(
                              hintText: "Fulano de tal",
                              labelText: 'Razão Social',
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }),
                  ),
                  StreamBuilder<String>(
                      stream: _registerPartnerBloc.outCNPJ,
                      builder: (context, snapshot) {
                        return Container(
                          margin: EdgeInsets.only(top: 18),
                          child: TextField(
                            onChanged: _registerPartnerBloc.changeCNPJ,
                            controller: _cnpjController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CnpjCpfFormatter(
                                eDocumentType: EDocumentType.CNPJ,
                              )
                            ],
                            decoration: InputDecoration(
                              hintText: '00.000.000/0000-00',
                              labelText: 'CNPJ',
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }),
                  Container(
                    child: FlatButton(
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width / 1.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Selecione a data de\nexpedição do certificado",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SfDateRangePicker(
                                        onSelectionChanged: _onSelectionChanged,
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                        initialSelectedRange: PickerDateRange(
                                            DateTime.now().subtract(
                                                const Duration(days: 4)),
                                            DateTime.now()
                                                .add(const Duration(days: 3))),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.red),
                                                child: Center(
                                                  child: Text(
                                                    "Cancelar",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Icon(
                              Icons.perm_contact_calendar,
                              size: MediaQuery.of(context).size.width / 4,
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            "Expedição",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _textDate,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: RegisterAddressScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              Icons.location_on_rounded,
                              size: MediaQuery.of(context).size.width / 4,
                              color: Colors.black45,
                            ),
                          ),
                          ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                            return Column(
                              children: [
                                Text(
                                  "Localização",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "${model.addressToRegisterPartner}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 26),
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
                        ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            return StreamBuilder<bool>(
                              stream: _registerPartnerBloc.outSubmitValidCNPJ,
                              builder: (context, snapshot) {
                                return FlatButton(
                                  onPressed: snapshot.hasData &&
                                          isShippingDateSelected &&
                                          model
                                              .isLocationChoosedOnRegisterPartner
                                      ? () async {
                                          _timer?.cancel();
                                          await EasyLoading.show(
                                            status: 'loading...',
                                            maskType: EasyLoadingMaskType.black,
                                          );
                                          final requestPartnerDataFlag =
                                              RequestPartnerData(
                                            expedtionDate: _selectedDate,
                                            companyName:
                                                _companyNameController.text,
                                            cnpj: _cnpjController.text,
                                            location: UserModel.of(context)
                                                .addressToRegisterPartner,
                                            isJuridicPerson: true,
                                          );

                                          await EasyLoading.dismiss();
                                          setState(() {
                                            requestPartnerData =
                                                requestPartnerDataFlag;
                                          });
                                          setState(() {
                                            screen = 6;
                                          });
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
                                              isShippingDateSelected &&
                                              model
                                                  .isLocationChoosedOnRegisterPartner
                                          ? Colors.red
                                          : Colors.grey[300],
                                    ),
                                    child: Center(
                                      child: model.isLoading
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Text(
                                              "Próximo",
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
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
