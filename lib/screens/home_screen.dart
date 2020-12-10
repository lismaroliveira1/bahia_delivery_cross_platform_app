import 'dart:io';

import 'package:bd_app_full/tabs/favorite_tab.dart';
import 'package:bd_app_full/tabs/home_tab.dart';
import 'package:bd_app_full/tabs/profile_tab.dart';
import 'package:bd_app_full/tabs/search_tab.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeTab _homeTab = HomeTab();
  final FavoriteTab _favoriteTab = FavoriteTab();
  final SearchTab _searchTab = SearchTab();
  final ProfileTab _profileTab = ProfileTab();
  Widget _showPage = new HomeTab();

  @override
  void initState() {
    super.initState();
    configFCM();
  }

  void configFCM() {
    final fcm = FirebaseMessaging();
    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(
          const IosNotificationSettings(provisional: true));
    }
    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunc: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(
          message['notification']['title'] as String,
          message['notification']['body'] as String,
        );
      },
    );
  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 12,
      isDismissible: true,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
      icon: Icon(Icons.list),
    ).show(context);
  }

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _homeTab;
        break;
      case 1:
        return _favoriteTab;
        break;
      case 2:
        return _searchTab;
        break;
      case 3:
        return _profileTab;
        break;
      default:
        return _homeTab;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeColor = 30.0;
    return Scaffold(
      body: _showPage,
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        color: Colors.black26,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.redAccent,
        items: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.home,
              size: sizeColor,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.favorite,
              size: sizeColor,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.search,
              size: sizeColor,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.person_pin,
              size: sizeColor,
              color: Colors.white,
            ),
          ),
        ],
        animationDuration: Duration(milliseconds: 350),
        animationCurve: Curves.ease,
        onTap: (int tapIndex) {
          setState(() {
            _showPage = _pageChooser(tapIndex);
          });
        },
      ),
    );
  }
}
