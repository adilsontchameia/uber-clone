import 'package:flutter/cupertino.dart';
import 'package:uber_clone/src/providers/auth_provider.dart';

class RegisterController {
  BuildContext? context;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _authProvider;
  //Para peticoes HTTP
  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = AuthProvider();
    return null;
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');
    try {
      bool isLogin = await _authProvider!.login(email, password);
      //Perguntar se fez login
      if (isLogin) {
        print('O usuario esta logado');
      } else {
        print('O usuario nao pode logar');
      }
    } catch (error) {
      print('Erro: $error');
    }
  }
}
