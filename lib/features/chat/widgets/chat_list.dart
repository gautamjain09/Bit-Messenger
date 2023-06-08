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
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getChatMessagesProvider(widget.recieverId)).when(
          data: (data) {
            // For Scrolling to Last message Continously
            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            });

            return ListView.builder(
              controller: messageController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                MessageModel messageData = data[index];
                String sentTime = DateFormat.Hm().format(messageData.sentTime);
                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: sentTime,
                  );
                } else {
                  return SenderMessageCard(
                    message: messageData.text,
                    date: sentTime,
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
