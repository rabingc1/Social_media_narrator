import '../../domain/user_model.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileAdded extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel userModel;

  ProfileLoaded({required this.userModel});
}

class ProfileUpdated extends ProfileState {
  final String imageUrl;

  ProfileUpdated(this.imageUrl);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
