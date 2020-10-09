import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  ProfileTile(
      {@required this.title, @required this.description, @required this.icon});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 30,
                color: Colors.black54,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 6),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.black45),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
