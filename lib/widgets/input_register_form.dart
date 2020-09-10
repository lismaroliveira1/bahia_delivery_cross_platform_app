import 'package:flutter/material.dart';

class InputRegisterForm extends StatelessWidget {
  final String title;
  final double width;
  InputRegisterForm({@required this.title, @required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            child: Text(
              title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: width,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
