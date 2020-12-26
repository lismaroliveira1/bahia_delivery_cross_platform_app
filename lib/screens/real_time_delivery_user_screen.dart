import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/screens/chat_user_order_screen.dart';
import 'package:bd_app_full/screens/details_user_order_screnn.dart';
import 'package:bd_app_full/tabs/real_time_delivery_user_tab.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RealTimeDeliveryUserScreen extends StatefulWidget {
  final OrderData orderData;
  RealTimeDeliveryUserScreen(this.orderData);

  @override
  _RealTimeDeliveryUserScreenState createState() =>
      _RealTimeDeliveryUserScreenState();
}

class _RealTimeDeliveryUserScreenState extends State<RealTimeDeliveryUserScreen>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  AnimatedIconData animatedIconData;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RealTimeDeliveryUserTab(widget.orderData),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      //Init Floating Action Bubble
      floatingActionButton: FloatingActionBubble(
        // Menu items
        backGroundColor: Colors.white,
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Detalhes",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.list_alt_rounded,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: DetailsUserOrderScreen(),
                  inheritTheme: true,
                  duration: Duration(
                    milliseconds: 350,
                  ),
                  ctx: context,
                ),
              );
            },
          ),
          // Floating action menu item
          Bubble(
            title: "Chat",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.message,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ChatUserOrderScreen(widget.orderData),
                  inheritTheme: true,
                  duration: Duration(
                    milliseconds: 350,
                  ),
                  ctx: context,
                ),
              );
            },
          ),
          //Floating action menu item
          Bubble(
            title: "Ligar",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.call,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
            },
          ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.blue,
        iconData: Icons.menu,
        // Flaoting Action button Icon
      ),
    );
  }
}
