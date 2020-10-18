import 'package:flutter/services.dart';
import 'package:place_plugin/place.dart';

class PlacePlugin {
  static const MethodChannel _channel = const MethodChannel('place_plugin');

  static void initialize(String apiKey) async {
    await _channel.invokeMethod("initialize", <String, dynamic>{
      'apikey': apiKey,
    });
  }

  static Future<List<Place>> search(String keyword) async {
    var result = await _channel.invokeMethod("search", <String, dynamic>{
      'keyword': keyword,
    });
    if (result != null) {
      return Place.fromNative(result);
    }
    return [];
  }

  static Future<Place> getPlace(Place place) async {
    var result = await _channel.invokeMapMethod('getPlace', <String, dynamic>{
      'placeId': place.placeId,
    });
    if (result != null) {
      place.lat = double.parse(result["latitude"].toString());
      place.lng = double.parse(result["longitude"].toString());
      place.formatedAddress = result["formatAddress"];
      return place;
    }
    return null;
  }
}
