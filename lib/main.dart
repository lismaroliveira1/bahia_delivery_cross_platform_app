import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
          title: 'Bahia Delivery',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: Color.fromARGB(255, 216, 216, 216)),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: HomeScreen(),
          )),
    );
  }
}
