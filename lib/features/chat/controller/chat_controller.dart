// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bit_messenger/core/message_enum.dart';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/models/chat_contact.dart';
import 'package:bit_messenger/models/message_model.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bit_messenger/features/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  return ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  );
});

final getChatContactsProvider = StreamProvider((ref) {
  return ref.watch(chatControllerProvider).getChatContacts();
});

final getChatMessagesProvider = StreamProvider.family((ref, String recieverId) {
  return ref.watch(chatControllerProvider).getChatMessages(recieverId);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverId,
  }) async {
    UserModel recieverUser;
    ref.read(getUserDataProvider(recieverId)).whenData((value1) {
      recieverUser = value1;
      UserModel senderUser;
      String senderId = ref.watch(firebaseAuthProvider).currentUser!.uid;
      ref.read(getUserDataProvider(senderId)).whenData((value2) {
        senderUser = value2;
        chatRepository.sendTextMessage(
          context: context,
          text: text,
          recieverUser: recieverUser,
          senderUser: senderUser,
        );
      });
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> getChatMessages(String recieverId) {
    return chatRepository.getChatMessages(recieverId);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverId,
    required MessageEnum messageEnum,
  }) {
    UserModel recieverUser;
    ref.read(getUserDataProvider(recieverId)).whenData((value1) {
      recieverUser = value1;
      UserModel senderUser;
      String senderId = ref.watch(firebaseAuthProvider).currentUser!.uid;
      ref.read(getUserDataProvider(senderId)).whenData((value2) {
        senderUser = value2;
        chatRepository.sendFileMessage(
          context: context,
          file: file,
          senderUser: senderUser,
          recieverUser: recieverUser,
          ref: ref,
          messageEnum: messageEnum,
        );
      });
    });
  }
}
