import 'package:bahia_delivery/validators/credit_card_validator.dart';
import 'package:rxdart/subjects.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class CreditCardBloc extends BlocBase with CredirCardValidators {
  final _cardNumberController = BehaviorSubject<String>();
  final _cardOwnerNameController = BehaviorSubject<String>();
  final _validateDateCardController = BehaviorSubject<String>();
  final _cvvCardController = BehaviorSubject<String>();
  final _cpfController = BehaviorSubject<String>();

  Stream<String> get outCardNumber =>
      _cardNumberController.stream.transform(validateCardNumber);
  Stream<String> get outOwnerName =>
      _cardOwnerNameController.stream.transform(validateOwnerNameCard);
  Stream<String> get outValidateDateCard =>
      _validateDateCardController.stream.transform(validateDate);
  Stream<String> get outCVV => _cvvCardController.stream.transform(validateCVV);
  Stream<String> get outCPF => _cpfController.stream.transform(validateCPF);

  Function(String) get changeCardNumber => _cardNumberController.sink.add;
  Function(String) get changeOwnerName => _cardOwnerNameController.sink.add;
  Function(String) get changeValidadeDateCard =>
      _validateDateCardController.sink.add;
  Function(String) get changeCVV => _cvvCardController.sink.add;
  Function(String) get changeCPF => _cpfController.sink.add;
  @override
  void dispose() {
    super.dispose();
    _cardNumberController.close();
    _cardOwnerNameController.close();
    _validateDateCardController.close();
    _cvvCardController.close();
    _cpfController.close();
  }
}
