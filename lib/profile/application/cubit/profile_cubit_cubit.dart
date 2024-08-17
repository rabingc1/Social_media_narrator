import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_narrator/profile/application/cubit/profile_cubit_state.dart';
import 'package:social_media_narrator/profile/domain/user_model.dart';
import 'package:social_media_narrator/profile/infrastructure/profile_repositary.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileLoading());

  void fetchUserProfile() async {
    try {
      UserModel? user = await _profileRepo.getUserInfo();

      if (user == null) {
        throw Exception("User not found");
      }

      emit(ProfileLoaded(userModel: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateuser(UserModel user, File? image) async {
    emit(ProfileLoading());
    try {
      String? imageUrl;

      if (image != null) {
        imageUrl = await _profileRepo.uploadProfilePicture(image);
      } else {
        imageUrl = user.profileImageUrl;
      }

      UserModel updatedUser = user.copyWith(profileImageUrl: imageUrl);
      await _profileRepo.updateUserProfile(updatedUser);
      emit(ProfileAdded());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateuserData(UserModel user) async {
    emit(ProfileLoading());
    try {
      await _profileRepo.updateUserData(user);
      emit(ProfileAdded());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('Attempting to sign out');
      await _profileRepo.signOut();
      emit(ProfileLoading());
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error signing out: $e');
      emit(ProfileError(
        message: e.runtimeType.toString(),
      ));
    }
  }
}
