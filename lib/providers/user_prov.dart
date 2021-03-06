import 'package:flutter/foundation.dart';
import 'package:streambox/config/enumvals.dart';
import 'package:streambox/models/user.dart';

class UserProv with ChangeNotifier {
  final User _user = User();
  void setName(String name) {
    _user.name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    _user.phoneNumber = number;
    notifyListeners();
  }

  void setPassword(String password) {
    _user.password = password;
    notifyListeners();
  }

  void setAddress(String address) {
    _user.address = address;
    notifyListeners();
  }

  void setUserRole(UserType role) {
    _user.role = role;
    notifyListeners();
  }

  String get name => _user.name;
  String get email => _user.email;
  String get phoneNumber => _user.phoneNumber;
  UserType get role => _user.role;
  String get password => _user.password;
  String get address => _user.address;

  void getInfo() {
    print(_user.toString());
  }
}
