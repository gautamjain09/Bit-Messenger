import 'package:bit_messenger/common/widgets/error_text.dart';
import 'package:bit_messenger/common/widgets/loader.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/auth/screens/splash_screen.dart';
import 'package:bit_messenger/firebase_options.dart';
import 'package:bit_messenger/screens/mobile_screen_layout.dart';
import 'package:bit_messenger/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
      home: ref.watch(userDataProvider).when(
            data: (user) {
              if (user == null) {
                return const SplashScreen();
              } else {
                return const MobileScreenLayout();
              }
            },
            error: ((error, stackTrace) => ErrorText(error: error.toString())),
            loading: () => const Loader(),
          ),
    );
  }
}
