import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/Previous_UI/widgets/chats_list.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String name;
  final String uid;
  const ChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          name,
          style: const TextStyle(
            color: textColor,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call,
              size: 24,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              size: 20,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
                hintText: 'Type a message!',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(8),
                // suffixIcon: Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: const [
                //     Icon(
                //       Icons.camera_alt,
                //       color: Colors.grey,
                //       size: 24,
                //     ),
                //     SizedBox(width: 8),
                //     Icon(
                //       Icons.attach_file,
                //       color: Colors.grey,
                //       size: 24,
                //     ),
                //     SizedBox(width: 8),
                //     Icon(
                //       Icons.money,
                //       color: Colors.grey,
                //       size: 24,
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
