import 'package:bahia_delivery/data/address_data_from_google.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class AddressModel extends Model {
  UserModel user;
  bool isLoading;
  double latitude;
  double longitude;
  GoogleMap googleMap;

  AddressDataFromGoogle currentAddressDataFromGoogle;
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    isLoading = true;
    notifyListeners();
    final position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position.latitude != null) latitude = position.latitude;
    if (position.longitude != null) longitude = position.longitude;
    if (latitude != null && longitude != null) {
      googleMap = GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 20.0,
        ),
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
      );
    }
    isLoading = false;
    notifyListeners();
  }
}
