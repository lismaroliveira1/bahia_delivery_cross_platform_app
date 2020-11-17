import 'package:flutter/material.dart';

class EditProductParameters extends StatefulWidget {
  final TextEditingController controller;
  final String initialText;
  final String hintText;
  final String labelText;
  final int minLines;
  final int maxLines;

  EditProductParameters({
    @required this.controller,
    @required this.initialText,
    @required this.hintText,
    @required this.labelText,
    this.minLines,
    this.maxLines,
  });
  @override
  _EditProductParametersState createState() => _EditProductParametersState();
}

class _EditProductParametersState extends State<EditProductParameters> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller..text = widget.initialText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
      ),
    );
  }
}
