import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  FirebaseAuth? _firebaseAuth;
  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  //Method to login
  Future<bool> login(String email, String password) async {
    String? errorMessage;

    try {
      await _firebaseAuth?.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      //Codigo do Erro
      //Qualquer
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return true;
  }

  //Method to signUp
  Future<bool> register(String email, String password) async {
    String? errorMessage;

    try {
      await _firebaseAuth?.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      //Codigo do Erro
      //Qualquer
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return true;
  }
}
