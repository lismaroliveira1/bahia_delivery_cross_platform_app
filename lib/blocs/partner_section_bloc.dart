import 'package:bd_app_full/validators/partner_section_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class PartnerSectionBloc extends BlocBase with PartnerSectionValidators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _longDescriptionController = BehaviorSubject<String>();
  final _priceController = BehaviorSubject<String>();
  final _discountConntroller = BehaviorSubject<String>();
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outDescription =>
      _descriptionController.stream.transform(validateDescription);
  Stream<String> get outLongDescription =>
      _longDescriptionController.stream.transform(validateLongDescription);
  Stream<String> get outPrice =>
      _priceController.stream.transform(validatePrice);
  Stream<String> get outDiscount =>
      _discountConntroller.stream.transform(validateDiscount);
  Stream<bool> get outSubmitValid => Rx.combineLatest2(
        outName,
        outDescription,
        (a, b) => true,
      );
  Stream<bool> get outSubmitedProduct => Rx.combineLatest4(
        outName,
        outDescription,
        outLongDescription,
        outPrice,
        (a, b, c, d) => true,
      );
  Stream<bool> get outSubmitedOff => Rx.combineLatest3(
        outName,
        outDescription,
        outDiscount,
        (a, b, c) => true,
      );
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeLongDescription =>
      _longDescriptionController.sink.add;
  Function(String) get changePrice => _priceController.sink.add;
  Function(String) get changeDiscount => _discountConntroller.sink.add;
  @override
  void dispose() {
    _nameController.close();
    _priceController.close();
    _longDescriptionController.close();
    _descriptionController.close();
    _discountConntroller.close();
    super.dispose();
  }
}
