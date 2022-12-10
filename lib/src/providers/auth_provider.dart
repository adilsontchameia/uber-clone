import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  FirebaseAuth? _firebaseAuth;

  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser() {
    return _firebaseAuth!.currentUser!;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth!.currentUser;

    if (currentUser == null) {
      return false;
    }

    return true;
  }

  void checkIfUserIsLogged(BuildContext context, String typeUser) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // QUE EL USUARIO ESTA LOGEADO
      if (user != null) {
        if (typeUser == 'client') {
          Navigator.pushNamedAndRemoveUntil(
              context, 'client/map', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, 'driver/map', (route) => false);
        }
        print('El usuario esta logeado');
      } else {
        print('El usuario no esta logeado');
      }
    });
  }

  Future<Object> login(String email, String password) async {
    String errorMessage;

    try {
      return await _firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      errorMessage = error.code;
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    } else {
      return true;
    }
  }

  Future<Object?> register(String email, String password) async {
    String errorMessage;
    try {
      return await _firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      errorMessage = error.code;
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    } else {
      return register;
    }
  }

  Future<Future<List>> signOut() async {
    return Future.wait([
      _firebaseAuth!.signOut(),
    ]);
  }
}
