import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Future<dynamic> pageTransition({
  @required BuildContext context,
  @required Widget screen,
}) =>
    Navigator.push(
      context,
      new PageTransition(
        type: PageTransitionType.rightToLeft,
        child: screen,
        inheritTheme: true,
        duration: new Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
