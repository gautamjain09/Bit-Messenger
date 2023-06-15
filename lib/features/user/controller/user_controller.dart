import 'dart:io';

import 'package:bit_messenger/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bit_messenger/features/user/repository/user_repository.dart';

final userControllerProvider = Provider((ref) {
  return UserController(
    userRepository: ref.watch(userRepositoryProvider),
    ref: ref,
  );
});

final getUsersByEmailProvider = StreamProvider.family((ref, String query) {
  return ref.watch(userControllerProvider).searchUserByEmail(query: query);
});

final getAllUsersProvider = StreamProvider((ref) {
  return ref.watch(userControllerProvider).getAllUsers();
});

class UserController {
  final UserRepository userRepository;
  final ProviderRef ref;
  UserController({
    required this.userRepository,
    required this.ref,
  });

  Stream<List<UserModel>> searchUserByEmail({required String query}) {
    return userRepository.searchUserByEmail(query: query);
  }

  Stream<List<UserModel>> getAllUsers() {
    return userRepository.getAllUsers();
  }

  void updateUserProfile({
    required BuildContext context,
    required File? profileImage,
    required String profileUrl,
  }) {
    userRepository.updateUserProfile(
      context,
      profileImage,
      profileUrl,
      ref,
    );
  }
}
