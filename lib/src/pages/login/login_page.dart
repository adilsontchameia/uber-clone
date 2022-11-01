import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber_clone/src/pages/login/login_controller.dart';
import 'package:uber_clone/src/utils/Colors.dart' as utils;
import 'package:uber_clone/src/widgets/button_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _con = LoginController();
  @override
  void initState() {
    super.initState();
    //Para evitar execoes em caso de erro, ao iniciar um metodo.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _bannerApp(),
              _textDescription(),
              _textLogin(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              _textFieldEmail(),
              _textFieldPassword(),
              _buttonLogin(),
              _textDontHaveAccount(),
            ],
          ),
        ));
  }

  Widget _textDontHaveAccount() {
    return Container(
      margin: const EdgeInsets.only(bottom: 50.0),
      child: const Text(
        'Dont have account ?',
        style: TextStyle(fontSize: 15.0, color: Colors.grey),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: ButtonApp(
        onPressed: _con.login,
        text: 'Login',
        color: utils.Colors.uberCloneColor,
        icon: Icons.arrow_forward_ios,
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Insert Your Password',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.uberCloneColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: _con.emailController,
        decoration: const InputDecoration(
          hintText: 'yourname@domain.com',
          labelText: 'Insert Your Email',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: utils.Colors.uberCloneColor,
          ),
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.black,
          fontSize: 27,
          fontFamily: 'NambusSans',
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: const Text(
        'Continuar com a sessao',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 24,
          fontFamily: 'NambusSans',
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.Colors.uberCloneColor,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150.0,
              height: 100.0,
            ),
            const Text(
              "Facil e Rapido",
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
