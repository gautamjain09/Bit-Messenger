// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bit_messenger/features/conctacts/repository/contacts_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  return ref.watch(contactsRepositoryProvider).getContacts();
});

final contactsControllerProvider = Provider((ref) {
  return ContactsController(
    contactsRepository: ref.watch(contactsRepositoryProvider),
    ref: ref,
  );
});

class ContactsController {
  final ContactsRepository contactsRepository;
  final ProviderRef ref;
  ContactsController({
    required this.contactsRepository,
    required this.ref,
  });

  void selectContact(Contact selectedContact, BuildContext context) async {
    contactsRepository.selectContact(selectedContact, context);
  }
}
