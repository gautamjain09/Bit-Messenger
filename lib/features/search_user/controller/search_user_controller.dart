import 'package:bit_messenger/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bit_messenger/features/search_user/repository/search_user_repository.dart';

final searchUserControllerProvider = Provider((ref) {
  return SearchUserController(
    searchUserRepository: ref.watch(searchUserRepositoryProvider),
    ref: ref,
  );
});

final getUsersByEmailProvider = StreamProvider.family((ref, String query) {
  return ref
      .watch(searchUserControllerProvider)
      .searchUserByEmail(query: query);
});

final getAllUsersProvider = StreamProvider((ref) {
  return ref.watch(searchUserControllerProvider).getAllUsers();
});

class SearchUserController {
  final SearchUserRepository searchUserRepository;
  final ProviderRef ref;
  SearchUserController({
    required this.searchUserRepository,
    required this.ref,
  });

  Stream<List<UserModel?>> searchUserByEmail({required String query}) {
    return searchUserRepository.searchUserByEmail(query: query);
  }

  Stream<List<UserModel?>> getAllUsers() {
    return searchUserRepository.getAllUsers();
  }
}
