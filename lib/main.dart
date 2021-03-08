import 'dart:async';

import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/home_screen.dart';
import 'package:bd_app_full/screens/login_screen.dart';
import 'package:bd_app_full/widgets/drawer_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kt_drawer_menu/kt_drawer_menu.dart';
import 'package:scoped_model/scoped_model.dart';

import 'elements/drawer_menu_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: close_sinks
  final StreamController<DrawerItemEnum> _streamController =
      StreamController<DrawerItemEnum>.broadcast(sync: true);

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            color: Colors.white,
            title: 'Bahia Delivery',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: Color.fromARGB(255, 216, 216, 216),
            ),
            debugShowCheckedModeBanner: false,
            home: model.isLogged
                ? KTDrawerMenu(
                    width: 360.0,
                    radius: 30.0,
                    scale: 0.6,
                    shadow: 20.0,
                    shadowColor: Colors.black12,
                    drawer: DrawerPage(streamController: _streamController),
                    content: HomeScreen(streamController: _streamController),
                  )
                : LoginScreen(),
            builder: EasyLoading.init(),
          );
        },
      ),
    );
  }
}
