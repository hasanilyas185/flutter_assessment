import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository()
      : _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

   signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

   isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    // ignore: unnecessary_null_comparison
    return currentUser != null;
  }

  getUser() async {
    return _firebaseAuth.currentUser;
  }

}