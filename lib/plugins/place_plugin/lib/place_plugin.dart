// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/services.dart';

import 'place.dart';

class PlacePlugin {
  static const MethodChannel _channel = const MethodChannel('place_plugin');

  static void initialize(String apiKey) async {
    await _channel
        .invokeListMethod("initialize", <String, dynamic>{'apiKey': apiKey});

    Future<List<Place>> search(String keyword) async {
      var result = await _channel
          .invokeMethod("Search", <String, dynamic>{"keyword": keyword});
      if (result != null) {
        return Place.fromNative(result);
      } else {
        return [];
      }
    }
  }

  static Future<Place> getPlace(Place place) async {
    var result = await _channel
        .invokeMethod('getPlace', <String, dynamic>{'placeId': place.placeId});
    if (result != null) {
      place.lat = double.parse(result["latitude"].toString());
      place.lng = -double.parse(result["longitude"].toString());
      return place;
    }
    return null;
  }
}
