import 'dart:collection';

import 'package:bd_app_full/data/category_store_data.dart';
import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/coupon_data.dart';
import 'package:bd_app_full/data/offs_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geodesy/geodesy.dart';

class StoreData {
  String description;
  String image;
  bool isOpen;
  String name;
  String partnerId;
  String id;
  bool isActive = false;
  int closingTimeHour;
  int closingTimeMinute;
  int openingTimeHour;
  int openingTimeMinute;
  List<OffData> productsOff = [];
  List<ProductData> products = [];
  List<CategoryStoreData> storeCategoryList = [];
  List<ProductData> purchasedProducts = [];
  List<ComboData> storesCombos = [];
  bool isFavorite = false;
  GeoPoint geopoint;
  double distance;
  LatLng latLng;
  double deliveryTime;
  String locationId;
  String storeAddress;
  List<CouponData> coupons = [];
  int discount = 0;
  double setupTime = 60;
  double deliveryRate = 2;
  StoreData(
    this.description,
    this.image,
    this.isOpen,
    this.name,
    this.partnerId,
    this.id,
    this.isActive,
    this.closingTimeHour,
    this.closingTimeMinute,
    this.openingTimeHour,
    this.openingTimeMinute,
    this.productsOff,
    this.distance,
    this.deliveryTime,
  );

  StoreData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    LinkedHashMap p;
    description = queryDoc.get("description");
    image = queryDoc.get("image");
    name = queryDoc.get("name");
    partnerId = queryDoc.get("partnerId");
    geopoint = queryDoc.data()["address"]["geopoint"];
    latLng = LatLng(
      geopoint.latitude,
      geopoint.longitude,
    );
    locationId = queryDoc.data()["address"]["locationId"];
    storeAddress = queryDoc.data()["address"]["storeAddress"];
    try {
      p = queryDoc.data()["closingTime"];
      closingTimeHour = p["hour"];
      closingTimeMinute = p["minute"];
      p = queryDoc.data()["openingTime"];
      openingTimeMinute = p["minute"];
      openingTimeHour = p["hour"];
      if (DateTime.now().hour > openingTimeHour &&
          DateTime.now().hour < closingTimeHour) {
        isOpen = true;
      } else if (DateTime.now().hour == openingTimeHour) {
        if (DateTime.now().minute >= openingTimeMinute) {
          isOpen = true;
        } else {
          isOpen = false;
        }
      } else if (DateTime.now().hour < openingTimeHour ||
          DateTime.now().hour > closingTimeHour) {
        isOpen = false;
      } else if (DateTime.now().hour == closingTimeHour) {
        if (DateTime.now().minute <= closingTimeMinute) {
          isOpen = true;
        } else {
          isOpen = false;
        }
      }
      isActive = true;
    } catch (erro) {
      isActive = false;
    }
  }
  StoreData.fromDocument(DocumentSnapshot queryDoc) {
    id = queryDoc.id;
    LinkedHashMap p;
    description = queryDoc.get("description");
    image = queryDoc.get("image");
    name = queryDoc.get("name");
    partnerId = queryDoc.get("partnerId");
    geopoint = queryDoc.data()["address"]["geopoint"];
    latLng = LatLng(
      geopoint.latitude,
      geopoint.longitude,
    );
    locationId = queryDoc.data()["address"]["locationId"];
    storeAddress = queryDoc.data()["address"]["storeAddress"];
    try {
      p = queryDoc.data()["closingTime"];
      closingTimeHour = p["hour"];
      closingTimeMinute = p["minute"];
      p = queryDoc.data()["openingTime"];
      openingTimeMinute = p["minute"];
      openingTimeHour = p["hour"];
      if (DateTime.now().hour > openingTimeHour &&
          DateTime.now().hour < closingTimeHour) {
        isOpen = true;
      } else if (DateTime.now().hour == openingTimeHour) {
        if (DateTime.now().minute >= openingTimeMinute) {
          isOpen = true;
        } else {
          isOpen = false;
        }
      } else if (DateTime.now().hour < openingTimeHour ||
          DateTime.now().hour > closingTimeHour) {
        isOpen = false;
      } else if (DateTime.now().hour == closingTimeHour) {
        if (DateTime.now().minute <= closingTimeMinute) {
          isOpen = true;
        } else {
          isOpen = false;
        }
      }
      isActive = true;
    } catch (erro) {
      isActive = false;
    }
  }
}
