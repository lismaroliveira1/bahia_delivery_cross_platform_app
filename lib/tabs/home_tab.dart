import 'package:bahia_delivery/themes/theme.dart';
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
              leading: GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: Colors.white,
                      boxShadow: AppTheme.shadow),
                  child: Icon(Icons.sort),
                ),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Container(
                padding: EdgeInsets.all(10),
                height: 80,
                width: 80,
                child: Image(
                  image: AssetImage("images/logo.png"),
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                      child: Container(
                        height: 50,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          image: DecorationImage(
                              image: AssetImage("images/user.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      onTap: () {}),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
