import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class PartnerBloc extends BlocBase {
  final _emailController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  @override
  void dispose() {
    _emailController.close();
    _descriptionController.close();
    super.dispose();
  }
}
