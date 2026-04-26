import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (e) {
      throw Exception('Error al iniciar sesión: Revise sus credenciales');
    }
  }
}