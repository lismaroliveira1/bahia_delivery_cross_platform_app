import 'dart:async';

import 'package:place_plugin/place_plugin.dart';

const googlePlaceApiKey = "AIzaSyBavlFX_n6MlAxfIPohHqu9n4F7zCvNpvg";

class SearchBlock {
  var _searchController = StreamController();
  SearchBlock() {
    PlacePlugin.initialize(googlePlaceApiKey);
  }
  Stream get searchStream => _searchController.stream;

  void searchPlace(String keyword) {
    if (keyword.isNotEmpty) {
      _searchController.sink.add("searching");
      PlacePlugin.search(keyword).then((result) {
        _searchController.sink.add(result);
      }).catchError((e) {});
    } else {
      _searchController.add([]);
    }
  }
}
