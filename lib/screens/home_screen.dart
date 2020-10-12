import 'dart:io';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/cart_screen.dart';
import 'package:bahia_delivery/screens/favorite_screen.dart';
import 'package:bahia_delivery/screens/profile_screen.dart';
import 'package:bahia_delivery/tabs/about_tab.dart';
import 'package:bahia_delivery/tabs/home_tab.dart';
import 'package:bahia_delivery/tabs/order_tab.dart';
import 'package:bahia_delivery/tabs/setup_tab.dart';
import 'package:bahia_delivery/widgets/custom_drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../tabs/home_tab.dart';
import 'package:flushbar/flushbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final HomeTab _homeTab = HomeTab();
  final FavoriteScreen _favoriteScreen = FavoriteScreen();
  final ProfileScreen _profileScreen = ProfileScreen();
  final OrderTab _orderTab = OrderTab();
  final SetupTab _setupTab = SetupTab();
  final AboutTab _aboutTab = AboutTab();
  final CartScreen _cartScreen = CartScreen();
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
        UserModel.of(context).updatePartnerData();
        UserModel.of(context).getUserOrder();
        print("onLaunc: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        UserModel.of(context).updatePartnerData();
        UserModel.of(context).getUserOrder();
        print("onResume: $message");
      },
      onMessage: (Map<String, dynamic> message) async {
        UserModel.of(context).updatePartnerData();
        UserModel.of(context).getUserOrder();
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
        return _favoriteScreen;
        break;
      case 2:
        return _cartScreen;
        break;
      case 3:
        return _profileScreen;
        break;
      default:
        return _homeTab;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeColor = 25.0;
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: _showPage,
          bottomNavigationBar: CurvedNavigationBar(
            height: 55,
            color: Colors.red,
            backgroundColor: Colors.white,
            buttonBackgroundColor: Colors.redAccent,
            items: [
              Icon(
                Icons.home,
                size: sizeColor,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite,
                size: sizeColor,
                color: Colors.white,
              ),
              Icon(
                Icons.add_shopping_cart,
                size: sizeColor,
                color: Colors.white,
              ),
              Icon(
                Icons.person_pin,
                size: sizeColor,
                color: Colors.white,
              ),
            ],
            animationDuration: Duration(milliseconds: 350),
            animationCurve: Curves.easeIn,
            onTap: (int tappedIndex) {
              setState(() {
                _showPage = _pageChooser(tappedIndex);
              });
            },
          ),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: _orderTab,
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: _setupTab,
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: _aboutTab,
        )
      ],
    );
  }
}
