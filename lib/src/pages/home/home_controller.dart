import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';
import '../../utils/shared_pref.dart';

class HomeController {
  BuildContext? context;
  SharedPref? _sharedPref;

  AuthProvider? _authProvider;
  String? _typeUser;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = SharedPref();
    _authProvider = AuthProvider();

    _typeUser = await _sharedPref!.read('typeUser');
    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider!.isSignedIn();
    if (isSigned) {
      debugPrint('SI ESTA LOEGADO');
      if (_typeUser == 'client') {
        Navigator.pushNamedAndRemoveUntil(
            context!, 'client/map', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context!, 'driver/map', (route) => false);
      }
    } else {
      debugPrint('NO ESTA LOGEADO');
    }
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context!, 'login');
  }

  void saveTypeUser(String typeUser) async {
    _sharedPref!.save('typeUser', typeUser);
  }
}
