import 'package:bd_app_full/validators/register_partner_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPartnerBloc extends BlocBase with RegisterPartnerValidators {
  final _ownerNameController = BehaviorSubject<String>();
  final _cpfController = BehaviorSubject<String>();
  final _fantasyStoreNameController = BehaviorSubject<String>();
  final _descriptionStoreController = BehaviorSubject<String>();
  final _cnpjController = BehaviorSubject<String>();

  Stream<String> get outOwnerName =>
      _ownerNameController.stream.transform(validateName);
  Stream<String> get outCPF => _cpfController.stream.transform(validateCPF);
  Stream<String> get outFantasyStoreName =>
      _fantasyStoreNameController.stream.transform(validateFantasyName);
  Stream<String> get outStoreDescription =>
      _descriptionStoreController.stream.transform(validateDescription);
  Stream<String> get outCNPJ => _cnpjController.stream.transform(validateCNPJ);

  Function(String) get changeOWnerName => _ownerNameController.sink.add;
  Function(String) get changeCPF => _cpfController.sink.add;
  Function(String) get changeFantasyName =>
      _fantasyStoreNameController.sink.add;
  Function(String) get changeDesription => _descriptionStoreController.sink.add;
  Function(String) get changeCNPJ => _cnpjController.sink.add;

  @override
  void dispose() {
    _ownerNameController.close();
    _cpfController.close();
    _fantasyStoreNameController.close();
    _descriptionStoreController.close();
    _cnpjController.close();
    super.dispose();
  }
}
