import 'dart:async';
import 'package:place_plugin/place_plugin.dart';

const googlePlaceApiKey = "AIzaSyBavlFX_n6MlAxfIPohHqu9n4F7zCvNpvg";

class SearchBloc {
  SearchBloc() {
    PlacePlugin.initailize(googlePlaceApiKey);
  }
  var _searchController = StreamController();
  Stream get searchStream => _searchController.stream;
  void searchPlace(String keyword) {
    if (keyword.isNotEmpty) {
      _searchController.sink.add("searching_");
      PlacePlugin.search(keyword).then((result) {
        _searchController.sink.add(result);
      }).catchError((e) {});
    } else {
      _searchController.add([]);
    }
  }
}
