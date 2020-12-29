import 'package:bd_app_full/data/coupon_data.dart';
import 'package:bd_app_full/tabs/edit_coupon_tab.dart';
import 'package:flutter/material.dart';

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
