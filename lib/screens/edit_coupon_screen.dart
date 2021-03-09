import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class EditCouponScrenn extends StatelessWidget {
  final CouponData couponData;
  EditCouponScrenn(this.couponData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditCouponTab(couponData),
    );
  }
}
