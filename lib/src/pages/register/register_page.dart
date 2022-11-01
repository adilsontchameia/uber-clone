import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber_clone/src/pages/register/register_controller.dart';
import 'package:uber_clone/src/utils/Colors.dart' as utils;
import 'package:uber_clone/src/widgets/button_app.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _con = RegisterController();
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
              _textRegister(),
              _textFieldUsername(),
              _textFieldEmail(),
              _textFieldPassword(),
              _textFieldConfirmPassword(),
              _buttonLogin(),
            ],
          ),
        ));
  }

  Widget _buttonLogin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: ButtonApp(
        onPressed: _con.register,
        text: 'SingUp',
        color: utils.Colors.uberCloneColor,
        icon: Icons.arrow_forward_ios,
      ),
    );
  }

  Widget _textFieldUsername() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextField(
        controller: _con.usernameController,
        decoration: const InputDecoration(
          hintText: 'Your Name',
          labelText: 'User Name',
          suffixIcon: Icon(
            Icons.person_outlined,
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

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Confirm Your Password',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: utils.Colors.uberCloneColor,
          ),
        ),
      ),
    );
  }

  Widget _textRegister() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: const Text(
        'SIGNUP',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
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
