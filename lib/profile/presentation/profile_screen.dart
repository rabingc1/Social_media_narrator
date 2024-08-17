import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_narrator/theme/app_color.dart';
import 'package:social_media_narrator/theme/responsive_size.dart';

import '../../auth/presentation/login/sign_in_form.dart';

import '../application/cubit/profile_cubit_cubit.dart';
import '../application/cubit/profile_cubit_state.dart';
import '../domain/user_model.dart';
import 'edit_profile.dart';
import 'view_profile.dart';
import 'widgets/logout_confirmation_dailog.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  bool _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserProfile();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _updateProfilePicture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.container,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.container,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Text(state.userModel.name);
            }
            return const SizedBox();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileLoaded) {
              log("Image:${state.userModel.profileImageUrl.runtimeType}");
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.grey[200],
                            child: state.userModel.profileImageUrl != null &&
                                    state.userModel.profileImageUrl!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: state.userModel.profileImageUrl!,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Text(
                                      state.userModel.name.characters.first
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    state.userModel.name.characters.first
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      if (_uploadingImage)
                        const Positioned.fill(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      Positioned(
                        bottom: ScreenUtils.getHeight(context, .006),
                        left: ScreenUtils.getWidth(context, .29),
                        child: const CircleAvatar(
                          child: Icon(
                            Icons.camera_alt_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.userModel.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.userModel.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewProfile(userModel: state.userModel),
                            ));
                          },
                          child: const ProfileItem(
                            icon: Icons.view_agenda,
                            text: 'View Profile',
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey[300]),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EditProfile(),
                            ));
                          },
                          child: const ProfileItem(
                            icon: Icons.edit,
                            text: 'Edit Profile',
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey[300]),
                        GestureDetector(
                          onTap: () {
                            context.read<ProfileCubit>().signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignInForm(),
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () => LogoutConfirmationDialog.show(context),
                            child: const ProfileItem(
                              icon: Icons.logout,
                              text: 'Logout',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().fetchUserProfile();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  void _updateProfilePicture() async {
    if (_profileImage != null) {
      final userProfileState = context.read<ProfileCubit>().state;
      String name = '';
      String email = '';
      String location = '';
      String profileImageUrl = '';

      if (userProfileState is ProfileLoaded) {
        name = userProfileState.userModel.name;
        email = userProfileState.userModel.email;
        location = userProfileState.userModel.location;
        profileImageUrl = userProfileState.userModel.profileImageUrl ?? '';
      }

      setState(() {
        _uploadingImage = true;
      });

      UserModel updatedUser = UserModel(
        id: userProfileState is ProfileLoaded
            ? userProfileState.userModel.id
            : "",
        name: name,
        email: email,
        location: location,
        profileImageUrl: profileImageUrl,
        admin: false,
      );

      try {
        await context
            .read<ProfileCubit>()
            .updateuser(updatedUser, _profileImage);

        setState(() {
          _uploadingImage = false;
        });
      } catch (e) {
        setState(() {
          _uploadingImage = false;
        });
      }
    }
    // ignore: use_build_context_synchronously
    context.read<ProfileCubit>().fetchUserProfile();
  }
}
