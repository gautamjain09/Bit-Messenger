import 'dart:io';
import 'package:bit_messenger/core/message_enum.dart';
import 'package:bit_messenger/core/providers/firebase_providers.dart';
import 'package:bit_messenger/core/providers/message_reply_provider.dart';
import 'package:bit_messenger/core/providers/storage_repository_provider.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/models/chat_contact.dart';
import 'package:bit_messenger/models/message_model.dart';
import 'package:bit_messenger/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    firestore: ref.watch(firestoreProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  ChatRepository({
    required this.firestore,
    required this.firebaseAuth,
  });

  // 1 -> Last Chat with all reciever
  // users -> senderId -> chats -> recieverId -> set data
  // users -> recieverId -> chats -> senderId -> set data

  // 2 -> Full Chats Messages Storing
  // users -> senderId -> chats -> recieverId -> messages -> messageId -> storeMessages
  // users -> recieverId -> chats -> senderId -> messages -> messageId -> storeMessages
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required UserModel recieverUser,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) {
    try {
      String messageId = const Uuid().v1();
      DateTime currentTime = DateTime.now();

      // 1 -> last Chat with all reciever
      _saveDataToContactsSubCollection(
        text: text,
        recieverUser: recieverUser,
        senderUser: senderUser,
        sentTime: currentTime,
      );

      // 2 -> Full Chat Messages Storing
      _saveMessagesToMessagesSubCollection(
          recieverUser: recieverUser,
          senderUser: senderUser,
          sentTime: currentTime,
          text: text,
          messageId: messageId,
          messageType: MessageEnum.text,
          messageReply: messageReply);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      showSnackBar(
        context: context,
        text: e.toString(),
      );
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required UserModel senderUser,
    required UserModel recieverUser,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      DateTime sentTime = DateTime.now();
      String messageId = const Uuid().v1();

      String fileUrl;
      String messageText;
      if (messageEnum == (MessageEnum.image)) {
        messageText = "📷 Photo";
        fileUrl = await ref
            .read(storageRepositoryProvider)
            .storeImageToFirebaseStorage(
              context,
              "chat/${messageEnum.type}/${senderUser.uid}${recieverUser.uid}$messageId",
              file,
            );
      } else {
        messageText = "📸 Video";
        fileUrl = await ref
            .read(storageRepositoryProvider)
            .storeVideoToFirebaseStorage(
              context,
              "chat/${messageEnum.type}/${senderUser.uid}${recieverUser.uid}$messageId",
              file,
            );
      }

      _saveDataToContactsSubCollection(
        text: messageText,
        recieverUser: recieverUser,
        senderUser: senderUser,
        sentTime: sentTime,
      );

      _saveMessagesToMessagesSubCollection(
        recieverUser: recieverUser,
        senderUser: senderUser,
        sentTime: sentTime,
        text: fileUrl,
        messageId: messageId,
        messageType: messageEnum,
        messageReply: messageReply,
      );
    } on FirebaseException catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  // last message to Every friendUser
  void _saveDataToContactsSubCollection({
    required String text,
    required UserModel recieverUser,
    required UserModel senderUser,
    required DateTime sentTime,
  }) async {
    // 1 ->
    // users -> senderId -> chats -> recieverId -> set data
    ChatContact recieverChatContact = ChatContact(
      name: senderUser.name,
      profilePic: senderUser.profileUrl,
      contactId: senderUser.uid,
      sentTime: sentTime,
      lastMessage: text,
    );

    await firestore
        .collection("users")
        .doc(recieverUser.uid)
        .collection("chats")
        .doc(senderUser.uid)
        .set(recieverChatContact.toMap());

    // 2 ->
    // users -> recieverId -> chats -> senderId -> set data
    ChatContact senderChatContact = ChatContact(
      name: recieverUser.name,
      profilePic: recieverUser.profileUrl,
      contactId: recieverUser.uid,
      sentTime: sentTime,
      lastMessage: text,
    );

    await firestore
        .collection("users")
        .doc(senderUser.uid)
        .collection("chats")
        .doc(recieverUser.uid)
        .set(senderChatContact.toMap());
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> myChatContacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        myChatContacts.add(chatContact);
      }

      return myChatContacts;
    });
  }

  // full Chats messages storing of all contacts
  void _saveMessagesToMessagesSubCollection({
    required UserModel recieverUser,
    required UserModel senderUser,
    required DateTime sentTime,
    required String text,
    required String messageId,
    required MessageEnum messageType,
    required MessageReply? messageReply,
  }) async {
    MessageModel message = MessageModel(
      senderId: senderUser.uid,
      recieverId: recieverUser.uid,
      text: text,
      type: messageType,
      sentTime: sentTime,
      messageId: messageId,
      isSeen: false,
      repliedMessage: (messageReply == null) ? "" : messageReply.message,
      repliedMessageType:
          (messageReply == null) ? MessageEnum.text : messageReply.messageEnum,
      repliedTo: (messageReply == null)
          ? ""
          : messageReply.isMe
              ? senderUser.name
              : recieverUser.name,
    );

    // 1 ->
    // users -> senderId -> chats -> recieverId -> messages -> messageId -> storeMessages
    await firestore
        .collection("users")
        .doc(senderUser.uid)
        .collection("chats")
        .doc(recieverUser.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());

    // 2 ->
    // users -> recieverId -> chats -> senderId -> messages -> messageId -> storeMessages
    await firestore
        .collection("users")
        .doc(recieverUser.uid)
        .collection("chats")
        .doc(senderUser.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());
  }

  Stream<List<MessageModel>> getChatMessages(String recieverId) {
    return firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(recieverId)
        .collection("messages")
        .orderBy("sentTime")
        .snapshots()
        .map((event) {
      List<MessageModel> allMessages = [];
      for (var document in event.docs) {
        allMessages.add(MessageModel.fromMap(document.data()));
      }
      return allMessages;
    });
  }

  void setChatMessageSeenStatus({
    required BuildContext context,
    required String recieverId,
    required String senderId,
    required String messageId,
  }) async {
    // 1 ->
    // users -> senderId -> chats -> recieverId -> messages -> messageId -> setSeen
    await firestore
        .collection("users")
        .doc(senderId)
        .collection("chats")
        .doc(recieverId)
        .collection("messages")
        .doc(messageId)
        .update({"isSeen": true});

    // 2 ->
    // users -> recieverId -> chats -> senderId -> messages -> messageId -> setSeen
    await firestore
        .collection("users")
        .doc(recieverId)
        .collection("chats")
        .doc(senderId)
        .collection("messages")
        .doc(messageId)
        .update({"isSeen": true});
  }
}
