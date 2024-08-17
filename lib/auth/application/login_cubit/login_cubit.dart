import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_narrator/auth/application/login_cubit/login_state.dart';
import 'package:social_media_narrator/auth/domain/login_model.dart';
import 'package:social_media_narrator/auth/infrastructure/auth_repositary.dart';
import 'package:social_media_narrator/profile/domain/user_model.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepo;
  final FirebaseAuth _auth;
  final FirebaseFirestore firebaseFirestore;

  LoginCubit(this.authRepo, this._auth, this.firebaseFirestore)
      : super(LoginInitial()) {
    _auth.idTokenChanges().listen((User? user) async {
      if (user == null) {
        emit(LoginUnAuthenicated());
      } else {
        try {
          DocumentSnapshot userDoc =
              await firebaseFirestore.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            UserModel userModel =
                UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
            if (userModel.admin == true) {
              emit(LoginAdmin(userModel: userModel));
            } else {
              emit(LoginAuthenicated(userModel: userModel));
            }
          } else {
            // Handle user document not found
            emit(LoginUnAuthenicated());
          }
        } catch (e) {
          // Handle any errors
          emit(LoginUnAuthenicated());
        }
      }
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final loginModel = LoginModel(
        email: email,
        password: password,
      );

      await authRepo.signInWithEmailAndPassword(loginModel);

      debugPrint('User signed in successfully');
    } catch (e) {
      debugPrint('Error signing in: $e');
      emit(LoginError(e.toString()));
    }
  }
}
