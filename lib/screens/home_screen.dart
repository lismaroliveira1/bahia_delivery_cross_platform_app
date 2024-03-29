import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../elements/elements.dart';
import '../tabs/tabs.dart';

class HomeScreen extends StatefulWidget {
  final StreamController<DrawerItemEnum> streamController;

  HomeScreen({Key key, this.streamController}) : super(key: key);
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
    return StreamBuilder<DrawerItemEnum>(
        stream: widget.streamController.stream,
        initialData: DrawerItemEnum.HOME,
        builder: (context, snapshot) {
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
        });
  }

  Widget headerView(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: <Widget>[
              new Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/user1.jpg")))),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "John Witch",
                      ),
                      Text(
                        "test123@gmail.com",
                      )
                    ],
                  ))
            ],
          ),
        ),
        Divider(
          color: Colors.white.withAlpha(200),
          height: 16,
        )
      ],
    );
  }
}
