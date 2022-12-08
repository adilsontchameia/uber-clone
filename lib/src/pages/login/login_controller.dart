import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:uber_clone/src/utils/snackbar.dart' as utils;

import '../../models/client.dart';
import '../../models/driver.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/driver_provider.dart';
import '../../utils/my_progress_dialog.dart';
import '../../utils/shared_pref.dart';

class LoginController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _authProvider;
  ProgressDialog? _progressDialog;
  DriverProvider? _driverProvider;
  ClientProvider? _clientProvider;

  SharedPref? _sharedPref;
  String? _typeUser;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = AuthProvider();
    _driverProvider = DriverProvider();
    _clientProvider = ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    _sharedPref = SharedPref();
    _typeUser = await _sharedPref!.read('typeUser');

    //print('============== TIPO DE USUARIO===============');
    print(_typeUser);
  }

  void goToRegisterPage() {
    if (_typeUser == 'client') {
      Navigator.pushNamed(context!, 'client/register');
    } else {
      Navigator.pushNamed(context!, 'driver/register');
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    //print('Email: $email');
    //print('Password: $password');

    _progressDialog!.show();

    try {
      bool isLogin = await _authProvider!.login(email, password);
      _progressDialog!.hide();

      if (isLogin) {
        print('El usuario esta logeado');

        if (_typeUser == 'client') {
          Client? client =
              await _clientProvider!.getById(_authProvider!.getUser().uid);
          //print('CLIENT: $client');

          if (client != null) {
            //print('El cliente no es nulo');
            Navigator.pushNamedAndRemoveUntil(
                context!, 'client/map', (route) => false);
          } else {
            // print('El cliente si es nulo');
            utils.Snackbar.showSnackbar(
                context!, key, 'El usuario no es valido');
            await _authProvider!.signOut();
          }
        } else if (_typeUser == 'driver') {
          Driver? driver =
              await _driverProvider!.getById(_authProvider!.getUser().uid);
          //print('DRIVER: $driver');

          if (driver != null) {
            Navigator.pushNamedAndRemoveUntil(
                context!, 'driver/map', (route) => false);
          } else {
            utils.Snackbar.showSnackbar(
                context!, key, 'El usuario no es valido');
            await _authProvider!.signOut();
          }
        }
      } else {
        utils.Snackbar.showSnackbar(
            context!, key, 'El usuario no se pudo autenticar');
        //print('El usuario no se pudo autenticar');
      }
    } catch (error) {
      utils.Snackbar.showSnackbar(context!, key, 'Error: $error');
      _progressDialog!.hide();
      //print('Error: $error');
    }
  }
}
