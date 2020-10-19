import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_place/google_place.dart';
import 'package:rxdart/subjects.dart';

String apiKEY = 'AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI';

class SearchBloc extends BlocBase {
  final _searchController = BehaviorSubject<String>();
  GooglePlace googlePlace = GooglePlace(apiKEY);
  //TODO Colocar essa chave no firebase
  Stream<String> get outSearch => _searchController.stream;
  @override
  void dispose() {
    super.dispose();
    _searchController.close();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
  }
}
