import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/core/widgets/error_text.dart';
import 'package:bit_messenger/core/widgets/loader.dart';
import 'package:bit_messenger/features/auth/controller/auth_controller.dart';
import 'package:bit_messenger/features/chat/widgets/bottom_chat_textfield.dart';
import 'package:bit_messenger/features/chat/widgets/chat_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  const ChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: ref.watch(getUserDataProvider(uid)).when(
              data: (recieverData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(recieverData.profileUrl),
                        radius: 22,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          recieverData.name,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.start,
                          recieverData.isOnline ? "online" : "offline",
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
              error: ((error, stackTrace) =>
                  ErrorText(error: error.toString())),
              loading: () => const Loader(),
            ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: greyColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverId: uid),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: BottomChatTextField(recieverId: uid),
          ),
        ],
      ),
    );
  }
}
