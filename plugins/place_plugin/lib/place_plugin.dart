
import 'dart:async';

import 'package:flutter/services.dart';

class PlacePlugin {
  static const MethodChannel _channel =
      const MethodChannel('place_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
