import 'package:bit_messenger/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/auth/screens/login_screen.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (context) => const MaterialPage(child: SplashScreen()),
    '/login-screen': (context) => const MaterialPage(child: LoginScreen()),
  },
);

// final loggedInRoute = RouteMap(
//   routes: {
//     '/': (_) => const MaterialPage(child: HomeScreen()),
//   },
// );
