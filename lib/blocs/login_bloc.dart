import 'package:bd_app_full/validators/login_validators.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmedPasswordController = BehaviorSubject<String>();
  final _confirmedName = BehaviorSubject<String>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get outName => _confirmedName.stream.transform(validateName);

  Stream<String> get outConfirmedPassword =>
      _confirmedPasswordController.stream.transform(validateConfirmedPassword);
  Stream<bool> get outSubmitValid =>
      Rx.combineLatest2(outEmail, outPassword, (a, b) => true);

  Stream<bool> get outSubmitValidRegister => Rx.combineLatest4(outEmail,
      outPassword, outName, outConfirmedPassword, (a, b, c, d) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _confirmedName.sink.add;
  Function(String) get changeConfirmedPassoword =>
      _confirmedPasswordController.sink.add;
  @override

  void dispose() {
    super.dispose();
    _emailController.close();
    _passwordController.close();
    _confirmedPasswordController.close();
    _confirmedName.close();
  }
}
