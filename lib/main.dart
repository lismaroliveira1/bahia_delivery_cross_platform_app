import 'package:bahia_delivery/screens/home_screen.dart';
import 'package:bahia_delivery/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bahia Delivery',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Color.fromARGB(255, 216, 216, 216)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: HomeScreen(),
          drawer: CustomDrawer(),
        ));
  }
}
