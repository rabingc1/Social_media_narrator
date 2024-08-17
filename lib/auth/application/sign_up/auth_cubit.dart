import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/foundation.dart' show debugPrint;

import '../../domain/signup_model.dart';
import '../../infrastructure/auth_repositary.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String location,
    required String password,
    required String repassword,
    required String phoneNumber,
  }) async {
    emit(AuthLoading());
    try {
      debugPrint('Attempting to sign up with email: $email');
      final signUpModel = SignUpModel(
        id: '',
        name: name,
        email: email,
        location: location,
        password: password,
        repassword: repassword,
        phoneNumber: phoneNumber,
        admin: false,
        categories: [],
      );

      await authRepo.createUserWithEmailAndPassword(signUpModel);
      emit(AuthLoaded());
      debugPrint('User signed up successfully');
    } catch (e) {
      debugPrint('Error signing up: $e');
      emit(AuthError(e.toString()));
    }
  }
}
