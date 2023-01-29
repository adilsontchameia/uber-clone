import 'package:flutter/cupertino.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';

class RegisterController {
  BuildContext? context;
  //Controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //
  AuthProvider? _authProvider;
  //Para peticoes HTTP
  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = AuthProvider();
    return null;
  }

  void register() async {
    String userName = usernameController.text;
    String email = emailController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String password = passwordController.text.trim();
    //Validations
    if (userName.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      debugPrint('Must fill all informations.');
      return;
    }
    //
    if (confirmPassword != password) {
      debugPrint('The passwords are differents.');
      return;
    }
    //
    if (password.length < 6) {
      debugPrint('The password is short, it must has more than 6 characteres.');
    }
    debugPrint('Username: $userName');
    debugPrint('Email: $email');
    debugPrint('Confirmed Password: $confirmPassword');
    debugPrint('Password: $password');

    try {
      Object? isRegistered = await _authProvider!.register(email, password);
      //Perguntar se fez login
      if (isRegistered != null) {
        debugPrint('The user has sucessfully registered.');
      } else {
        debugPrint('The sign up process was failed.');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }
}
