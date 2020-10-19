import 'package:bahia_delivery/data/address_data.dart';
import 'package:bahia_delivery/data/address_data_from_google.dart';
import 'package:google_place/google_place.dart';
import 'package:scoped_model/scoped_model.dart';

class AddressModel extends Model {
  List<AddressDataFromGoogle> addressFromGoogleList = [];
  void getAddress(AutocompletePrediction predctionAddress) {
    addressFromGoogleList
        .add(AddressDataFromGoogle.fromPrediction(predctionAddress));
    notifyListeners();
  }
}
