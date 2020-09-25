import 'package:flutter/material.dart';

class PaymentsMethodsTab extends StatefulWidget {
  @override
  _PaymentsMethodsTabState createState() => _PaymentsMethodsTabState();
}

class _PaymentsMethodsTabState extends State<PaymentsMethodsTab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
