import 'package:bit_messenger/home_screen.dart';
import 'package:bit_messenger/features/auth/screens/otp_screen.dart';
import 'package:bit_messenger/features/auth/screens/user_info_screen.dart';
import 'package:bit_messenger/features/auth/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'features/auth/screens/login_screen.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (context) => const MaterialPage(child: SplashScreen()),
    '/login-screen': (context) => const MaterialPage(child: LoginScreen()),
    '/otp-screen/:id': (context) => MaterialPage(
          child: OTPScreen(id: context.pathParameters['id']!),
        ),
    '/user-info-screen': (context) =>
        const MaterialPage(child: UserInfoScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
  },
);
