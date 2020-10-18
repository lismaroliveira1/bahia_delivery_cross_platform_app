import 'package:flutter/services.dart';
import 'package:place_plugin_example/place.dart';

class PlacePlugin {
  static const MethodChannel _channel = const MethodChannel('place_plugin');

  static void intialize(String apiKey) async {
    await _channel.invokeMethod("initialize", <String, dynamic>{
      'apikey': apiKey,
    });
  }

  static Future<List<Place>> search(String keyword) async {
    var result = await _channel
        .invokeMethod("search", <String, dynamic>{'keyword': keyword});
    if (result != null) {
      return Place.fromNative(result);
    }
    return [];
  }
}
