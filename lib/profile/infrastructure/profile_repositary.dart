import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import '../domain/user_model.dart';

class ProfileRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserModel?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        data['id'] = userDoc.id;
        return UserModel.fromJson(data);
      }
    }
    return null;
  }

  Future<String?> uploadProfilePicture(
    File profilePic,
  ) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String fileName = path.basename(profilePic.path);
        Reference storageRef = _storage
            .ref()
            .child('profile_pictures')
            .child(user.uid)
            .child(fileName);
        UploadTask uploadTask = storageRef.putFile(profilePic);
        TaskSnapshot taskSnapshot = await uploadTask;
        return await taskSnapshot.ref.getDownloadURL();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> updateUserProfile(UserModel userModel,
      {File? profilePic}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        if (profilePic != null) {
          String? profilePicUrl = await uploadProfilePicture(profilePic);
          if (profilePicUrl != null) {
            userModel = userModel.copyWith(profileImageUrl: profilePicUrl);
          }
        }
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update(userModel.toJson());
      } catch (e) {
        rethrow;
      }
    } else {}
  }

  Future<void> updateUserData(
    UserModel userModel,
  ) async {
    User user = _auth.currentUser!;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(userModel.toJson());
  }

  // Future<void> updateUserProfile(UserModel user,File? profilepic) async {

  // }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
