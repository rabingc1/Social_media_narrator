import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_narrator/location_type.dart';
import 'package:social_media_narrator/theme/app_color.dart';

import '../../../auth/application/sign_up/auth_cubit.dart';
import '../../../auth/application/sign_up/auth_state.dart';
import '../../../auth/presentation/widgets/email_field.dart';
import '../../../auth/presentation/widgets/name_field.dart';

import '../../application/cubit/profile_cubit_cubit.dart';
import '../../application/cubit/profile_cubit_state.dart';
import '../../domain/user_model.dart';
import '../profile_screen.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

final formKey = GlobalKey<FormState>();

class _EditProfileFormState extends State<EditProfileForm> {
  late final TextEditingController emailController;
  late final TextEditingController nameController;
  late final TextEditingController locationController;
  List<String> locations = LocationService.locations;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    locationController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            if (nameController.text.isEmpty) {
              nameController.text = state.userModel.name;
            }
            if (emailController.text.isEmpty) {
              emailController.text = state.userModel.email;
            }
            _selectedLocation ??= state.userModel.location;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: _pickImage,
                      //     child: CircleAvatar(
                      //       radius: 50,
                      //       backgroundImage: _profileImage != null
                      //           ? FileImage(_profileImage!)
                      //           : state.userModel.profileImageUrl.isEmpty
                      //               ? NetworkImage(
                      //                   state.userModel.profileImageUrl)
                      //               : const AssetImage('assets/avatar.jpg')
                      //                   as ImageProvider,
                      //       child: _profileImage == null &&
                      //               state.userModel.profileImageUrl.isEmpty
                      //           ? Text(
                      //               state.userModel.name.isNotEmpty
                      //                   ? state.userModel.name[0].toUpperCase()
                      //                   : '',
                      //               style: const TextStyle(
                      //                   fontSize: 40, color: Colors.white),
                      //             )
                      //           : null,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      NameField(
                        namecontroller: nameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                        items: LocationService.locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Location is required' : null,
                      ),
                      const SizedBox(height: 10),
                      EmailField(
                        emailcontroller: emailController,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : _updateProfileHandler,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    'Update',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text("Error loading profile"));
          }
        },
      ),
    );
  }

  void _updateProfileHandler() {
    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final name = nameController.text.trim();
      final location = _selectedLocation ?? '';

      final userProfileState = context.read<ProfileCubit>().state;
      String userimage = '';
      bool admin = false;

      if (userProfileState is ProfileLoaded) {
        userimage = userProfileState.userModel.profileImageUrl ?? "";
        admin = userProfileState.userModel.admin ?? false;
      }

      UserModel updatedUser = UserModel(
        id: "",
        name: name,
        email: email,
        location: location,
        profileImageUrl: userimage,
        admin: admin,
      );

      context.read<ProfileCubit>().updateuserData(updatedUser);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileScreen()));
    }
  }
}
