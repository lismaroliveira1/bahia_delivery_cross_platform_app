import 'package:flutter/material.dart';

class StoreHomeWigget extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final VoidCallback onPressed;
  final Widget trailing;
  StoreHomeWigget({
    @required this.icon,
    @required this.name,
    @required this.description,
    @required this.onPressed,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 6.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red[100],
          ),
        ),
        child: Column(
          children: [
            ListTile(
              onTap: onPressed,
              leading: Icon(
                icon,
                size: 30,
                color: Colors.black45,
              ),
              dense: true,
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              trailing: trailing,
              subtitle: Text(
                description,
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
