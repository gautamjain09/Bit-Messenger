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

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(authControllerProvider).getUserData(uid);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<void> signUpwithEmailAndPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    return await authRepository.signUpwithEmailAndPassword(
      context: context,
      email: email,
      password: password,
    );
  }

  Future<void> loginInwithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    return await authRepository.loginInwithEmailAndPassword(
      context: context,
      email: email,
      password: password,
    );
  }

  void storeuserDataToFirestore(
    BuildContext context,
    String name,
    File? profileImage,
  ) {
    authRepository.saveUserDataToFirestore(
      context,
      name,
      profileImage,
      ref,
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return authRepository.getUserData(uid);
  }

  void logOut() {
    authRepository.logOut();
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
