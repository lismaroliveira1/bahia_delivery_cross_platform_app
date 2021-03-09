import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../tiles/drawer_tile.dart';

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
              ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                return ListView(
                  padding: EdgeInsets.only(left: 32.0, top: 32.0),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                      height: 170.0,
                      child: Image.asset("images/logo.png"),
                    ),
                    Text("Olá, ${!model.isLoggedIn()}",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        FlatButton(
                          child: Text(
                            !model.isLoggedIn()
                                ? "Entre ou Cadastra-se >"
                                : "Sair",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (!model.isLoggedIn())
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            else
                              model.signOut(onSuccess: () {});
                          },
                        ),
                      ],
                    ),
                    Divider(),
                    DrawerTile("Início", Icons.home, pageController, 0),
                    DrawerTile("Pedidos", Icons.list, pageController, 1),
                    DrawerTile(
                        "Configurações", Icons.settings, pageController, 2),
                    DrawerTile("Sobre", Icons.album, pageController, 3)
                  ],
                );
              })
            ],
          ),
        ));
  }
}
