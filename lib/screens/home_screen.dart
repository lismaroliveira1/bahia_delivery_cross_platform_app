import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(child: Icon(Icons.location_on), onPressed: () {})
                ],
              )
            ],
          )),
    );
  }
}
