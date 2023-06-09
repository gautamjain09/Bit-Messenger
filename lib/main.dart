import 'package:bit_messenger/features/auth/repository/auth_repository.dart';
import 'package:bit_messenger/features/auth/screens/login_screen.dart';
import 'package:bit_messenger/firebase_options.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/features/home/screens/home_screen.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    AuthRepository authRepository = AuthRepository(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );

    UserModel? userModel =
        await authRepository.getCurrentUserData(currentUser.uid);

    if (userModel != null) {
      runApp(
        const ProviderScope(
          child: MyAppLoggedIn(),
        ),
      );
    } else {
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    }
  } else {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bit Messenger',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class MyAppLoggedIn extends ConsumerWidget {
  const MyAppLoggedIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bit Messenger',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
