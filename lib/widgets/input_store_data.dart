import 'package:flutter/material.dart';

class InputStoreData extends StatelessWidget {
  final String labelText;
  final String hintText;
  InputStoreData({@required this.hintText, @required this.labelText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      child: TextField(
        autocorrect: true,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
