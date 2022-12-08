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
      print('Must fill all informations.');
      return;
    }
    //
    if (confirmPassword != password) {
      print('The passwords are differents.');
      return;
    }
    //
    if (password.length < 6) {
      print('The password is short, it must has more than 6 characteres.');
    }
    print('Username: $userName');
    print('Email: $email');
    print('Confirmed Password: $confirmPassword');
    print('Password: $password');

    try {
      Object? isRegistered = await _authProvider!.register(email, password);
      //Perguntar se fez login
      if (isRegistered != null) {
        print('The user has sucessfully registered.');
      } else {
        print('The sign up process was failed.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
