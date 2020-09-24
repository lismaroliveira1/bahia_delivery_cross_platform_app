import 'package:bahia_delivery/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymmentModel extends Model {
  UserModel userModel;
  bool isFocusedCVV = false;
  String cardNumber;
}
