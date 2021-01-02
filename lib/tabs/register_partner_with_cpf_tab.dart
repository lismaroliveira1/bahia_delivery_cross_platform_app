import 'package:bd_app_full/blocs/register_partner_block.dart';
import 'package:bd_app_full/data/request_partner_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/register_address_screen.dart';
import 'package:bd_app_full/screens/register_store_details_from_partner_screen.dart';
import 'package:cnpj_cpf_formatter/cnpj_cpf_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisterPartnerWithCPFTab extends StatefulWidget {
  @override
  _RegisterPartnerWithCPFTabState createState() =>
      _RegisterPartnerWithCPFTabState();
}

class _RegisterPartnerWithCPFTabState extends State<RegisterPartnerWithCPFTab> {
  final _registerPartnerBloc = RegisterPartnerBloc();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate;
  String _textDate;
  bool isBirthDayChoosed;
  bool isLocationChoosed;

  @override
  void initState() {
    _textDate = "";
    isBirthDayChoosed = false;
    isLocationChoosed =
        UserModel.of(context).isLocationChoosedOnRegisterPartner;
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
                                      Expanded(
                                        child: Padding(
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
                          _onYesPressed();
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
                                              } else {
                                                final requestPartnerData =
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
                                                Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child:
                                                        RegisterStoreDetailsScreen(
                                                      requestPartnerData,
                                                    ),
                                                    inheritTheme: true,
                                                    duration: Duration(
                                                      milliseconds: 350,
                                                    ),
                                                    ctx: context,
                                                  ),
                                                );
                                              }
                                            }
                                          : null,
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
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
    );
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
    Navigator.of(context).pop();
  }

  void _onYesPressed() {
    Scaffold.of(context).hideCurrentSnackBar();
    Navigator.push(
      context,
      new PageTransition(
        type: PageTransitionType.rightToLeft,
        child: new RegisterAddressScreen(),
        inheritTheme: true,
        duration: new Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void noChoosedBiryhDay() {
    Scaffold.of(context).showSnackBar(
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
    Scaffold.of(context).showSnackBar(
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
    Scaffold.of(context).showSnackBar(
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
}
