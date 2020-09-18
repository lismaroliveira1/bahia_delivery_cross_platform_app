import 'dart:async';

const googlePlaceApiKey = "AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI";

class SearchBloc {
  SearchBloc();
  var _searchController = StreamController();
  Stream get searchStream => _searchController.stream;
  void searchPlace(String keyword) {
    if (keyword.isNotEmpty) {
      _searchController.sink.add("searching");
    }
  }
}
