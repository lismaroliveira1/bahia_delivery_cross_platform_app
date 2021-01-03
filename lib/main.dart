import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/home_screen.dart';
import 'package:bd_app_full/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return OverlaySupport(
            child: MaterialApp(
              navigatorKey: navigatorKey,
              color: Colors.white,
              title: 'Bahia Delivery',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: Color.fromARGB(255, 216, 216, 216),
              ),
              debugShowCheckedModeBanner: false,
              home: model.isLogged ? HomeScreen() : LoginScreen(),
              builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}
