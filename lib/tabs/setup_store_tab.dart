import 'package:flutter/material.dart';

class SetupStoreTab extends StatefulWidget {
  @override
  _SetupStoreTabState createState() => _SetupStoreTabState();
}

class _SetupStoreTabState extends State<SetupStoreTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Horário",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Abre:"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
