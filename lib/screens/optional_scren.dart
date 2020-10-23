import 'package:bahia_delivery/tabs/optional_tab.dart';
import 'package:flutter/material.dart';

class OptionalScrenn extends StatefulWidget {
  @override
  _OptionalScrennState createState() => _OptionalScrennState();
}

class _OptionalScrennState extends State<OptionalScrenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opcionais"),
        centerTitle: true,
      ),
      body: OptionalTab(),
    );
  }
}
