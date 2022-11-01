import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber_clone/src/pages/home/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  
  final HomeController _con = HomeController();
  @override
  Widget build(BuildContext context) {
    //Usar o controlador
    //Apenas no stateless, porque se fazer um hot reload vai passar a iniciarlizar sempre que possivel (no statefull)
    _con.init(context);
    //Controlador iniciado acima
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.black, Colors.black54])),
            child: Column(
              children: [
                bannerApp(context),
                const SizedBox(height: 20.0),
                _textSelectYourRol('SELECIONE SUA PROFISSAO'),
                const SizedBox(height: 30.0),
                _imageTypeUser(context, 'assets/img/pasajero.png'),
                const SizedBox(height: 10.0),
                _textTypeUser('Cliente'),
                const SizedBox(height: 30.0),
                _imageTypeUser(context, 'assets/img/driver.png'),
                const SizedBox(height: 10.0),
                _textTypeUser('Condutor'),
              ],
            )),
      ),
    );
  }

  Widget bannerApp(BuildContext context) {
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Row(
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
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textSelectYourRol(String selectRolText) {
    return Text(
      selectRolText,
      style: const TextStyle(
          color: Colors.white, fontSize: 20.0, fontFamily: 'ONEDAY'),
    );
  }

  Widget _imageTypeUser(
    BuildContext context,
    String image,
  ) {
    return GestureDetector(
      onTap: _con.goToLoginPage,
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 50.0,
        backgroundColor: Colors.grey.shade900,
      ),
    );
  }

  Widget _textTypeUser(String typeUser) {
    return Text(typeUser,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ));
  }
}
