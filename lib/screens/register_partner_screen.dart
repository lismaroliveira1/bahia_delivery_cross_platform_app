import 'package:bahia_delivery/data/store_with_cpf_data.dart';
import 'package:bahia_delivery/models/store_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/input_store_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PartnerRegisterScreen extends StatefulWidget {
  @override
  _PartnerRegisterScreenState createState() => _PartnerRegisterScreenState();
}

class _PartnerRegisterScreenState extends State<PartnerRegisterScreen> {
  bool isJuridicPerson = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 0,
          width: 0,
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
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
                          color: Colors.yellow),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: IconButton(
                              onPressed: () {},
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
                              labelText: "Nome",
                              controller: nameController,
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
                                    controller: numberController,
                                  ),
                                ),
                              ],
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(8),
                              onPressed: () {
                                if (isJuridicPerson) {
                                } else {
                                  final StoreCPF storeCPF = StoreCPF(
                                    name: nameController.text,
                                    cpf: cpfController.text,
                                    zipCode: zipCodeController.text,
                                    street: streetController.text,
                                    district: districtController.text,
                                    number: numberController.text,
                                    city: cityController.text,
                                    state: stateController.text,
                                  );
                                }
                              },
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
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
