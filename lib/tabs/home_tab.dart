import 'dart:async';

import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/location_screen.dart';
import 'package:bahia_delivery/themes/theme.dart';
import 'package:bahia_delivery/tiles/category_tile.dart';
import 'package:bahia_delivery/tiles/stores_tile.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    Permission.locationWhenInUse.serviceStatus.isEnabled.then(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.userImage == null) model.getUserData();
      if (model.isLoading && model.street == null) {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: CustomScrollView(
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
                        child: Container(
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: model.userImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Row(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                var status =
                                    await Permission.locationWhenInUse.status;

                                if (status.isDenied) {
                                  //TODO Inplement GO to the settings function
                                } else if (status.isGranted) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LocationScreen(),
                                  ));
                                } else if (status.isRestricted) {
                                } else if (status.isUndetermined) {
                                  await Permission.locationWhenInUse.request();
                                } else if (status.isPermanentlyDenied) {
                                  //Implementar para o mesmo abrir o settings
                                }
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Text(model.addressSeted
                                      ? model.currentUserAddress.street +
                                          ", nº " +
                                          model.currentUserAddress.number
                                      : "Localização"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Categorias",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              fontStyle: FontStyle.italic,
                              fontSize: 14),
                        ),
                      ),
                      ListCategory(),
                    ]),
                  ),
                  ListStories(),
                ],
              ),
            ),
          ],
        );
      }
    });
  }

  FutureOr _updateStatus(bool value) {
    if (value == null) {
      print("desconhecido");
    }
  }
}
