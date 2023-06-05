import 'package:bit_messenger/features/chat/screens/chat_screen.dart';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsRepositoryProvider = Provider((ref) {
  return ContactsRepository(
    firestore: ref.read(firestoreProvider),
  );
});

class ContactsRepository {
  final FirebaseFirestore firestore;
  ContactsRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  // Selecting Contacts that are available for Chat
  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollections = await firestore.collection('users').get();
      var found = false;

      for (var doc in userCollections.docs) {
        var userData = UserModel.fromMap(doc.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNumber == userData.phoneNumber) {
          found = true;
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return ChatScreen(
                name: userData.name,
                uid: userData.uid,
              );
            }),
          );
          break;
        }
      }

      if (!found) {
        showSnackBar(
          context: context,
          text: "This number does not exist in App",
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }
}
