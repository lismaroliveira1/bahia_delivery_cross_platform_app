import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  final Function(String) onSaved;

  InputField(
      {@required this.icon,
      @required this.hint,
      @required this.obscure,
      @required this.stream,
      @required this.onChanged,
      @required this.onSaved});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: onChanged,
            onSaved: onSaved,
            decoration: InputDecoration(
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                errorText: snapshot.hasError ? snapshot.error : null,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding:
                    EdgeInsets.only(left: 5, right: 30, top: 30, bottom: 30)),
            style: TextStyle(color: Colors.white),
            obscureText: obscure,
          );
        });
  }
}
