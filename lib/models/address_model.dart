import 'package:bahia_delivery/data/address_data_from_google.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:scoped_model/scoped_model.dart';

class AddressModel extends Model {
  bool isLoading;
  double latitude;
  double longitude;
  GoogleMap googleMap;
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _getCurrentLocation();
  }

  List<AddressDataFromGoogle> addressFromGoogleList = [];
  void getAddress(AutocompletePrediction predctionAddress) {
    addressFromGoogleList
        .add(AddressDataFromGoogle.fromPrediction(predctionAddress));
    notifyListeners();
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
