import 'package:cnpj_cpf_formatter/cnpj_cpf_formatter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../blocs/blocs.dart';
import '../components/components.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class RegisterPartnerWithCNPJTab extends StatefulWidget {
  @override
  _RegisterPartnerWithCNPJTabState createState() =>
      _RegisterPartnerWithCNPJTabState();
}

class _RegisterPartnerWithCNPJTabState
    extends State<RegisterPartnerWithCNPJTab> {
  final _registerPartnerBloc = RegisterPartnerBloc();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate;
  String _textDate;
  bool isShippingDateSelected;

  @override
  void initState() {
    _textDate = "";
    isShippingDateSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _imageSize = MediaQuery.of(context).size.width / 3;
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
                    child: TextButton(
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
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SfDateRangePicker(
                                          onSelectionChanged:
                                              _onSelectionChanged,
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .single,
                                          initialSelectedRange: PickerDateRange(
                                              DateTime.now().subtract(
                                                  const Duration(days: 4)),
                                              DateTime.now().add(
                                                  const Duration(days: 3))),
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
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
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
                    child: TextButton(
                      onPressed: () {
                        pageTransition(
                          context: context,
                          screen: new RegisterAddressScreen(),
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
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
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
                                return TextButton(
                                  onPressed: snapshot.hasData &&
                                          isShippingDateSelected &&
                                          model
                                              .isLocationChoosedOnRegisterPartner
                                      ? () {
                                          final requestPartnerData =
                                              RequestPartnerData(
                                            companyName:
                                                _companyNameController.text,
                                            cnpj: _cnpjController.text,
                                            expedtionDate: _selectedDate,
                                            location: UserModel.of(context)
                                                .addressToRegisterPartner,
                                          );
                                          pageTransition(
                                            context: context,
                                            screen:
                                                new RegisterStoreDetailsScreen(
                                              requestPartnerData,
                                            ),
                                          );
                                        }
                                      : null,
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

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value;
      _textDate = _selectedDate.day.toString() +
          '/' +
          _selectedDate.month.toString() +
          '/' +
          _selectedDate.year.toString();
      isShippingDateSelected = true;
    });
    Navigator.of(context).pop();
  }
}
