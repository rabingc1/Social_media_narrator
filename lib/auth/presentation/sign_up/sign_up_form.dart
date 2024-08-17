import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_narrator/auth/application/sign_up/auth_cubit.dart';
import 'package:social_media_narrator/auth/presentation/widgets/phone_number_fiield.dart';
import 'package:social_media_narrator/location_type.dart';
import 'package:social_media_narrator/theme/app_color.dart';
import 'package:social_media_narrator/theme/responsive_size.dart';

import '../../application/sign_up/auth_state.dart';
import '../login/sign_in_form.dart';
import '../widgets/email_field.dart';
import '../widgets/name_field.dart';
import '../widgets/password_field.dart';
import '../widgets/re_password_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  late final TextEditingController locationController;
  late final TextEditingController repasswordController;
  late final TextEditingController phoneController;

  List<String> locations = LocationService.locations;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    locationController = TextEditingController();
    repasswordController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    locationController.dispose();
    repasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is AuthLoaded) {
          Navigator.of(context).pop(); // Close the dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInForm(),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: ScreenUtils.getHeight(context, .1)),
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NameField(
                    namecontroller: nameController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  // DropdownButtonFormField<String>(
                  //   value: locations.first,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       locationController.text = value!;
                  //     });
                  //   },
                  //   items: locations.map((location) {
                  //     return DropdownMenuItem<String>(
                  //       value: location,
                  //       child: Text(location),
                  //     );
                  //   }).toList(),
                  //   decoration: const InputDecoration(
                  //     labelText: 'Location',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  EmailField(
                    emailcontroller: emailController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  PhoneNumberField(
                    phoneController: phoneController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).nextFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    passwordcontroller: passwordController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  const SizedBox(height: 10),
                  RePasswordField(
                    repasswordController: repasswordController,
                    originalPasswordController: passwordController,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading ? null : signUpHandler,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Sign Up',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: AppColor.calendarHeader,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInForm(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppColor.calendarHeader,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpHandler() {
    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final name = nameController.text.trim();
      const location = "";
      final repassword = repasswordController.text.trim();
      final password = passwordController.text.trim();
      final phone = phoneController.text.trim();

      final hashpassword = sha256.convert(utf8.encode(password)).toString();
      final hashrepassword = sha256.convert(utf8.encode(repassword)).toString();

      context.read<AuthCubit>().signUpWithEmailAndPassword(
            email: email,
            password: hashpassword,
            name: name,
            location: location,
            repassword: hashrepassword,
            phoneNumber: phone,
          );
    }
  }
}
