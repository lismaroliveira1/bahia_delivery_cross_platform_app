import 'package:bahia_delivery/validators/address_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class AddressBloc extends BlocBase with AddressValidators {
  final _nameController = BehaviorSubject<String>();
  final _zipCodeController = BehaviorSubject<String>();
  final _streetController = BehaviorSubject<String>();
  final _numberController = BehaviorSubject<String>();
  final _districtController = BehaviorSubject<String>();
  final _cityControlller = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<String>();
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outZipCode =>
      _zipCodeController.stream.transform(validateZipCode);
  Stream<String> get outStreet =>
      _streetController.stream.transform(validateStreet);
  Stream<String> get outNumber =>
      _numberController.stream.transform(validateNumber);
  Stream<String> get outDistrict =>
      _districtController.stream.transform(validateDistrict);
  Stream<String> get outCity => _cityControlller.stream.transform(validateCity);
  Stream<String> get outState =>
      _stateController.stream.transform(validateState);
  Function(String) get changeOutName => _nameController.sink.add;
  Function(String) get changeOutZipCode => _zipCodeController.sink.add;
  Function(String) get changeOutStreetController => _streetController.sink.add;
  Function(String) get changeOutNumberController => _numberController.sink.add;
  Function(String) get changeOutDistrictController =>
      _districtController.sink.add;
  Function(String) get changeOutCityController => _cityControlller.sink.add;
  Function(String) get changeOutStateController => _stateController.sink.add;
  @override
  void dispose() {
    super.dispose();
    _nameController.close();
    _zipCodeController.close();
    _streetController.close();
    _numberController.close();
    _districtController.close();
    _cityControlller.close();
    _stateController.close();
  }
}
