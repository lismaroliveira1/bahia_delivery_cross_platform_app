import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeTab extends StatelessWidget {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search), hintText: "Vai de que hoje?"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
