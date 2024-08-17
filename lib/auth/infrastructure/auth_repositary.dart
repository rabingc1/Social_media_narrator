import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/login_model.dart';
import '../domain/signup_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserWithEmailAndPassword(SignUpModel signUpModel) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: signUpModel.email,
        password: signUpModel.password,
      );

      final user = SignUpModel(
        id: userCredential.user!.uid,
        name: signUpModel.name,
        email: userCredential.user!.email ?? signUpModel.email,
        location: signUpModel.location,
        password: signUpModel.password,
        repassword: signUpModel.repassword,
        admin: false,
        phoneNumber: signUpModel.phoneNumber,
        categories: [],
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(LoginModel loginModel) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
