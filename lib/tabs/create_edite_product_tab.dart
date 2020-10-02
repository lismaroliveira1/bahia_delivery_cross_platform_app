import 'package:flutter/material.dart';

class CreateEditProductTab extends StatefulWidget {
  @override
  _CreateEditProductTabState createState() => _CreateEditProductTabState();
}

class _CreateEditProductTabState extends State<CreateEditProductTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([]),
        ),
      ],
    );
  }
}
