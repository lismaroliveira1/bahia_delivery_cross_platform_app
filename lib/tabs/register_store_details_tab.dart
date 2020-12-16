import 'package:bd_app_full/data/category_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisterStoreDetailsTab extends StatefulWidget {
  @override
  _RegisterStoreDetailsTabState createState() =>
      _RegisterStoreDetailsTabState();
}

class _RegisterStoreDetailsTabState extends State<RegisterStoreDetailsTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _timeOpenController = TextEditingController();
  TextEditingController _timeCloseController = TextEditingController();
  String _dropdownInitValue;
  List<String> _dropdownsItens;
  String _valueToValidate4 = '';
  String _valueSaved4 = '';
  String _valueChanged4 = '';
  @override
  void initState() {
    Intl.defaultLocale = 'pt_BR';
    _dropdownsItens = [];
    UserModel.of(context).categoryList.forEach((category) {
      _dropdownsItens.add(category.title);
    });
    _dropdownInitValue = _dropdownsItens[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(UserModel.of(context).categoryList.length);
    double _imageSize = MediaQuery.of(context).size.width / 3;
    return Form(
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
                    'Agora vamos falar \ndo seu negócio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Loja tal",
                      labelText: 'Nome Fantasia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18),
                  child: TextField(
                    controller: _nameController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Loja tal",
                      labelText: 'Descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
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
                              onChanged: (val) =>
                                  setState(() => _valueChanged4 = val),
                              validator: (val) {
                                setState(() => _valueToValidate4 = val);
                                return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _valueSaved4 = val),
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
                              onChanged: (val) =>
                                  setState(() => _valueChanged4 = val),
                              validator: (val) {
                                setState(() => _valueToValidate4 = val);
                                return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _valueSaved4 = val),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
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
                      FlatButton(
                        onPressed: () {
                          onButtonSendPressed();
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
                              "Enviar",
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
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {}

  void _onYesPressed() {}

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
}
