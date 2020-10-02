import 'package:flutter/material.dart';

class StoreHomeWigget extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final VoidCallback onPressed;
  StoreHomeWigget(
      {@required this.icon,
      @required this.name,
      @required this.description,
      @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.red[100],
            ),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.black45,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 14.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, left: 8.0, bottom: 14.0),
                    child: Text(
                      description,
                      style: TextStyle(color: Colors.black45),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
