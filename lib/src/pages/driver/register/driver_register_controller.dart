import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:uber_clone/src/utils/snackbar.dart' as utils;

import '../../../models/driver.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/driver_provider.dart';
import '../../../utils/my_progress_dialog.dart';

class DriverRegisterController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();

  AuthProvider? _authProvider;
  DriverProvider? _driverProvider;
  ProgressDialog? _progressDialog;

  Future init(BuildContext context) {
    this.context = context;
    _authProvider = AuthProvider();
    _driverProvider = DriverProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento...');

    return init(context);
  }

  void register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String password = passwordController.text.trim();

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6';

    print('Email: $email');
    print('Password: $password');

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(
          context!, key, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmPassword != password) {
      print('Las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(
          context!, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      print('el password debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(
          context!, key, 'el password debe tener al menos 6 caracteres');
      return;
    }

    _progressDialog!.show();

    try {
      Object? isRegister = await _authProvider!.register(email, password);

      if (isRegister != null) {
        Driver driver = Driver(
            id: _authProvider!.getUser().uid,
            email: _authProvider!.getUser().email,
            username: username,
            password: password,
            plate: plate);

        await _driverProvider!.create(driver);

        _progressDialog!.hide();
        Navigator.pushNamedAndRemoveUntil(
            context!, 'driver/map', (route) => false);
        utils.Snackbar.showSnackbar(
            context!, key, 'El usuario se registro correctamente');
        print('El usuario se registro correctamente');
      } else {
        _progressDialog!.hide();
        print('El usuario no se pudo registrar');
      }
    } catch (error) {
      _progressDialog!.hide();
      utils.Snackbar.showSnackbar(context!, key, 'Error: $error');
      print('Error: $error');
    }
  }
}
