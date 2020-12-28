import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/home_screen.dart';
import 'package:bd_app_full/screens/login_screen.dart';
import 'package:bd_app_full/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isReady) {
            return OverlaySupport(
              child: MaterialApp(
                color: Colors.white,
                title: 'Bahia Delivery',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  primaryColor: Color.fromARGB(255, 216, 216, 216),
                ),
                debugShowCheckedModeBanner: false,
                home: model.isLoggedIn() ? HomeScreen() : LoginScreen(),
              ),
            );
          } else {
            return OverlaySupport(
                child: MaterialApp(
              supportedLocales: [Locale('pt', 'BR')],
              title: 'Bahia Delivery',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: Color.fromARGB(255, 216, 216, 216),
              ),
              debugShowCheckedModeBanner: false,
              home: WelcomeScreen(),
            ));
          }
        },
      ),
    );
  }
}
