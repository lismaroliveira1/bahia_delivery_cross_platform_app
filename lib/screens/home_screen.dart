import 'package:bahia_delivery/tabs/about_tab.dart';
import 'package:bahia_delivery/tabs/cart_tab.dart';
import 'package:bahia_delivery/tabs/favorite_tab.dart';
import 'package:bahia_delivery/tabs/home_tab.dart';
import 'package:bahia_delivery/tabs/order_tab.dart';
import 'package:bahia_delivery/tabs/profile_tab.dart';
import 'package:bahia_delivery/tabs/setup_tab.dart';
import 'package:bahia_delivery/widgets/custom_drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../tabs/home_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final CartTab _cartTab = CartTab();
  final ProfileTab _profileTab = ProfileTab();
  final HomeTab _homeTab = HomeTab();
  final FavoriteTab _favoriteTab = FavoriteTab();
  final OrderTab _orderTab = OrderTab();
  final SetupTab _setupTab = SetupTab();
  final AboutTab _aboutTab = AboutTab();
  Widget _showPage = new HomeTab();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _homeTab;
        break;
      case 1:
        return _favoriteTab;
        break;
      case 2:
        return _cartTab;
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
    double sizeColor = 25.0;
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: _showPage,
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
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
