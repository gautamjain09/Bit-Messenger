import 'package:bit_messenger/chat_info.dart';
import 'package:bit_messenger/screens/mobile_chat_screen.dart';
import 'package:bit_messenger/screens/mobile_screen_layout.dart';
import 'package:bit_messenger/theme/colors.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: chat_info.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MobileChatScreen(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    chat_info[index]['name'].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      chat_info[index]['message'].toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      chat_info[index]['profilePic'].toString(),
                    ),
                    radius: 30,
                  ),
                  trailing: Text(
                    chat_info[index]['time'].toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: dividerColor,
                indent: 85,
              ),
            ],
          );
        },
      ),
    );
  }
}
