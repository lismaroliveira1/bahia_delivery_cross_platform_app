import 'package:bahia_delivery/tiles/drawer_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  CustomDrawer(this.pageController);
  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
          15.0,
        )),
        child: Drawer(
          child: Stack(
            children: <Widget>[
              _buildDrawerBack(),
              ListView(
                padding: EdgeInsets.only(left: 32.0, top: 32.0),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                    height: 170.0,
                    child: Image.asset("images/logo.png"),
                  ),
                  Text("Olá",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Divider(),
                  DrawerTile("Início", Icons.home, pageController, 0),
                  DrawerTile("Pedidos", Icons.list, pageController, 1),
                  DrawerTile(
                      "Configurações", Icons.settings, pageController, 2),
                  DrawerTile("Sobre", Icons.album, pageController, 3)
                ],
              )
            ],
          ),
        ));
  }
}
