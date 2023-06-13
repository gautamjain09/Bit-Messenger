import 'package:bit_messenger/core/message_enum.dart';
import 'package:bit_messenger/core/providers/message_reply_provider.dart';
import 'package:bit_messenger/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bit_messenger/core/widgets/error_text.dart';
import 'package:bit_messenger/core/widgets/loader.dart';
import 'package:bit_messenger/features/chat/controller/chat_controller.dart';
import 'package:bit_messenger/features/chat/widgets/my_message_card.dart';
import 'package:bit_messenger/features/chat/widgets/sender_message_card.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverId;
  const ChatList({
    Key? key,
    required this.recieverId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void onMessageSwipe({
    required String message,
    required bool isMe,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getChatMessagesProvider(widget.recieverId)).when(
          data: (data) {
            // For Scrolling to Last message Continously
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });

            return ListView.builder(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                MessageModel messageData = data[index];
                String sentTime = DateFormat.Hm().format(messageData.sentTime);

                if ((messageData.isSeen == false) &&
                    (messageData.recieverId ==
                        FirebaseAuth.instance.currentUser!.uid)) {
                  ref.read(chatControllerProvider).setChatMessageSeenStatus(
                        context: context,
                        messageId: messageData.messageId,
                        recieverId: messageData.recieverId,
                      );
                }

                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: sentTime,
                    messageEnum: messageData.type,
                    onLeftSwipe: () {
                      onMessageSwipe(
                        message: messageData.text,
                        isMe: true,
                        messageEnum: messageData.type,
                      );
                    },
                    repliedMessageType: messageData.repliedMessageType,
                    repliedText: messageData.repliedMessage,
                    username: messageData.repliedTo,
                    isSeen: messageData.isSeen,
                  );
                } else {
                  return SenderMessageCard(
                    message: messageData.text,
                    date: sentTime,
                    messageEnum: messageData.type,
                    onRightSwipe: () {
                      onMessageSwipe(
                        message: messageData.text,
                        isMe: false,
                        messageEnum: messageData.type,
                      );
                    },
                    repliedMessageType: messageData.type,
                    repliedText: messageData.repliedMessage,
                    username: messageData.repliedTo,
                  );
                }
              },
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
