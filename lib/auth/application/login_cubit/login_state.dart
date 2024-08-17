import '../../../profile/domain/user_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginAuthenicated extends LoginState {
  final UserModel userModel;

  LoginAuthenicated({required this.userModel});
}

class LoginUnAuthenicated extends LoginState {}

class LoginAdmin extends LoginState {
  final UserModel userModel;

  LoginAdmin({required this.userModel});
}

class LoginLoaded extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
