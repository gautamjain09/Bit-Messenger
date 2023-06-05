import 'dart:io';
import 'package:bit_messenger/features/auth/repository/auth_repository.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void veriflyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.veriflyOTP(context, verificationId, userOTP);
  }

  void storeuserDataToFirestore(
    BuildContext context,
    String name,
    File? profileImage,
  ) {
    authRepository.saveUserDataToFirestore(context, name, profileImage, ref);
  }

  void logOut() {
    authRepository.logOut();
  }
}
