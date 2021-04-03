import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth instance = FirebaseAuth.instance;

  Stream<User> get userSnapshot {
    return instance.authStateChanges();
  }

  Future<User> logIn(String email, String password) async {
    try {
      final userCreditentials = await instance.signInWithEmailAndPassword(
          email: email, password: password);
      return userCreditentials.user;
    } catch (error) {
      print(':::::: ERROR WHILE LOGING IN :::::::');
      throw error;
    }
  }

//hello

  Future<User> signIn(String email, String password) async {
    try {
      final userCreditentials = await instance.createUserWithEmailAndPassword(
          email: email, password: password);
          
      return userCreditentials.user;
    } catch (error) {
      print(error);
      print(':::::: ERROR WHILE SIGNING IN :::::::');
      throw error;
    }
  }

  Future<void> logOut() async {
    try {
      return await instance.signOut();
    } catch (error) {
      print(':::::: ERROR WHILE LOGING OUT ::::::');
      throw error;
    }
  }
}
