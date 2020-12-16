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
  @override
  Widget build(BuildContext context) {
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
                              "Próximo",
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
}
