import 'package:bahia_delivery/tabs/cart_tab.dart';
import 'package:bahia_delivery/tabs/favorite_tab.dart';
import 'package:bahia_delivery/tabs/home_tab.dart';
import 'package:bahia_delivery/tabs/order_tab.dart';
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
  final OrderTab _orderTab = OrderTab();
  final HomeTab _homeTab = HomeTab();
  final FavoriteTab _favoriteTab = FavoriteTab();
  Widget _showPage = new HomeTab();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _homeTab;
        break;
      case 1:
        return _orderTab;
        break;
      case 2:
        return _favoriteTab;
        break;
      case 3:
        return _cartTab;
        break;
      default:
        return Text("");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: _showPage,
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            color: Colors.red,
            backgroundColor: Colors.white,
            buttonBackgroundColor: Colors.redAccent,
            items: [
              Icon(
                Icons.home,
                size: 20,
                color: Colors.white,
              ),
              Icon(
                Icons.list,
                size: 20,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite,
                size: 20,
                color: Colors.white,
              ),
              Icon(
                Icons.add_shopping_cart,
                size: 20,
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
        )
      ],
    );
  }
}
