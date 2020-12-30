import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;
  DrawerTile(this.text, this.icon, this.pageController, this.page);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            pageController.jumpToPage(page);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 20, 50.0, 8.0),
              height: 60.0,
              child: Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 32.0,
                    color: pageController.page == page
                        ? Colors.black
                        : Colors.black54,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
