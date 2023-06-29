import 'package:bit_messenger/core/widgets/error_text.dart';
import 'package:bit_messenger/core/widgets/loader.dart';
import 'package:bit_messenger/features/chat/controller/chat_controller.dart';
import 'package:bit_messenger/features/chat/screens/chat_screen.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/models/chat_contact.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatContactsList extends ConsumerWidget {
  const ChatContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ref.watch(getChatContactsProvider).when(
            data: (data) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    ChatContact chatContactData = data[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  name: chatContactData.name,
                                  uid: chatContactData.contactId,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              chatContactData.name,
                              style: const TextStyle(
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                chatContactData.lastMessage,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                chatContactData.profilePic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContactData.sentTime),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          indent: 85,
                        ),
                      ],
                    );
                  });
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
