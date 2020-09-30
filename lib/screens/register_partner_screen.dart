import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PartnerRegisterScreen extends StatefulWidget {
  @override
  _PartnerRegisterScreenState createState() => _PartnerRegisterScreenState();
}

class _PartnerRegisterScreenState extends State<PartnerRegisterScreen> {
  bool isJuridicPerson = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 0,
          width: 0,
        ),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return Container(
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
                        child: Container(
                          height: 120,
                          color: Colors.blue,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[TextField()],
                        )),
              ],
            ),
          );
        },
      ),
    );
  }
}
