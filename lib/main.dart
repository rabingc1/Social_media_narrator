

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_narrator/profile/infrastructure/profile_repositary.dart';
import 'package:social_media_narrator/splash_screen/home_Splash.dart';
import 'package:social_media_narrator/theme/app_theme.dart';

import 'auth/application/login_cubit/login_cubit.dart';
import 'auth/application/sign_up/auth_cubit.dart';
import 'auth/infrastructure/auth_repositary.dart';
import 'auth/presentation/login/sign_in_form.dart';
import 'profile/application/cubit/profile_cubit_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final ProfileRepo profileRepo = ProfileRepo();

  final AuthRepository authRepository = AuthRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthCubit(authRepository),
      ),
      BlocProvider(
        create: (context) =>
            LoginCubit(authRepository, firebaseAuth, firebaseFirestore),
      ),
      BlocProvider(
        create: (context) => ProfileCubit(profileRepo)..fetchUserProfile(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme(context),
      debugShowCheckedModeBanner: false,
      home: const FirstSplash(),
    );
  }
}
