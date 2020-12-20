import 'package:bd_app_full/validators/partner_section_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class PartnerSectionBloc extends BlocBase with PartnerSectionValidators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  Stream<String> get outName => _nameController.stream.transform(validateName);
  Stream<String> get outDescription =>
      _descriptionController.stream.transform(validateDescription);

  Stream<bool> get outSubmitValid => Rx.combineLatest2(
        outName,
        outDescription,
        (a, b) => true,
      );
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  @override
  void dispose() {
    _nameController.close();
    _descriptionController.close();
    super.dispose();
  }
}
