import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kt_drawer_menu/kt_drawer_menu.dart';
import 'package:scoped_model/scoped_model.dart';

import '../elements/elements.dart';
import '../models/models.dart';

class DrawerPage extends StatefulWidget {
  final StreamController<DrawerItemEnum> streamController;

  DrawerPage({Key key, this.streamController}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  DrawerItemEnum selected;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DrawerItemEnum>(
      stream: widget.streamController.stream,
      initialData: DrawerItemEnum.HOME,
      builder: (context, snapshot) {
        selected = snapshot.data;
        return ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Container(
                color: Colors.blueGrey[900],
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    model.userData.image,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    model.userData.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        _getMenu(context, DrawerItemEnum.HOME),
                        _getMenu(context, DrawerItemEnum.PEDIDOS),
                        _getMenu(context, DrawerItemEnum.SOBRE),
                        _getMenu(context, DrawerItemEnum.AJUDA),
                        Spacer(),
                        _getMenu(context, DrawerItemEnum.AJUDA),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _getMenu(BuildContext context, DrawerItemEnum menu) {
    switch (menu) {
      case DrawerItemEnum.HOME:
        return _buildItem(context, menu, "Home", Icons.dashboard, () {});
      case DrawerItemEnum.PEDIDOS:
        return _buildItem(context, menu, "Pedidos", Icons.message, () {});
      case DrawerItemEnum.SOBRE:
        return _buildItem(context, menu, "Sobre", Icons.settings, () {});
      case DrawerItemEnum.AJUDA:
        return _buildItem(context, menu, "Ajuda", Icons.info, () {});
      default:
        return Container();
    }
  }

  Widget _buildItem(
    BuildContext context,
    DrawerItemEnum menu,
    String title,
    IconData icon,
    Function onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          widget.streamController.sink.add(menu);
          KTDrawerMenu.of(context).closeDrawer();
          onPressed();
        },
        child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 26),
          child: Row(
            children: [
              Icon(icon,
                  color: selected == menu ? Colors.white : Colors.white70,
                  size: 24),
              SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: selected == menu ? 15 : 14,
                  fontWeight:
                      selected == menu ? FontWeight.w500 : FontWeight.w300,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
