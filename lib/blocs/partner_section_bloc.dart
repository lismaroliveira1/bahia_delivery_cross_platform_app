import 'package:bd_app_full/validators/partner_section_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class PartnerSectionBloc extends BlocBase with PartnerSectionValidators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _longDescriptionController = BehaviorSubject<String>();
  final _priceController = BehaviorSubject<String>();
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outDescription =>
      _descriptionController.stream.transform(validateDescription);
  Stream<String> get outLongDescription =>
      _longDescriptionController.stream.transform(validateLongDescription);
  Stream<String> get outPrice =>
      _priceController.stream.transform(validatePrice);
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
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeLongDescription =>
      _longDescriptionController.sink.add;
  Function(String) get changePrice => _priceController.sink.add;
  @override
  void dispose() {
    _nameController.close();
    _priceController.close();
    _longDescriptionController.close();
    _descriptionController.close();
    super.dispose();
  }
}
