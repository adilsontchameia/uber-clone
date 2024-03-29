import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:uber_clone/src/utils/snackbar.dart' as utils;

import '../../../models/client.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/client_provider.dart';
import '../../../utils/my_progress_dialog.dart';

class ClientRegisterController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  AuthProvider? _authProvider;
  ClientProvider? _clientProvider;
  ProgressDialog? _progressDialog;

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = AuthProvider();
    _clientProvider = ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    return null;
  }

  void register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String password = passwordController.text.trim();

    debugPrint('Email: $email');
    debugPrint('Password: $password');

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      debugPrint('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(
          context!, key, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmPassword != password) {
      debugPrint('Las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(
          context!, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      debugPrint('el password debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(
          context!, key, 'el password debe tener al menos 6 caracteres');
      return;
    }

    _progressDialog!.show();

    try {
      Object? isRegister = await _authProvider!.register(email, password);

      if (isRegister != null) {
        Client client = Client(
            id: _authProvider!.getUser().uid,
            email: _authProvider!.getUser().email,
            username: username,
            password: password);

        await _clientProvider!.create(client);

        _progressDialog!.hide();
        Navigator.pushNamedAndRemoveUntil(
            context!, 'client/map', (route) => false);

        utils.Snackbar.showSnackbar(
            context!, key, 'El usuario se registro correctamente');
        debugPrint('El usuario se registro correctamente');
      } else {
        _progressDialog!.hide();
        debugPrint('El usuario no se pudo registrar');
      }
    } catch (error) {
      _progressDialog!.hide();
      utils.Snackbar.showSnackbar(context!, key, 'Error: $error');
      debugPrint('Error: $error');
    }
  }
}
