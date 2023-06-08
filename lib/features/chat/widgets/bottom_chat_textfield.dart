import 'package:flutter/material.dart';
import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/features/chat/controller/chat_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatTextField extends ConsumerStatefulWidget {
  final String recieverId;
  const BottomChatTextField({
    super.key,
    required this.recieverId,
  });

  @override
  ConsumerState<BottomChatTextField> createState() =>
      _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends ConsumerState<BottomChatTextField> {
  bool isShowSendButton = false;
  FocusNode focusNode = FocusNode();

  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton && _messageController.text.trim() != "") {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text.trim(),
            recieverId: widget.recieverId,
          );

      setState(() {
        _messageController.text = "";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isEmpty) {
                    setState(() {
                      isShowSendButton = false;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bottomBarColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      child: const Icon(
                        Icons.emoji_emotions,
                        color: greyColor,
                      ),
                      onTap: () {},
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            child: const Icon(
                              Icons.camera_alt,
                              color: greyColor,
                            ),
                            onTap: () {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            child: const Icon(
                              Icons.attach_file,
                              color: greyColor,
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 22,
                child: GestureDetector(
                  child: Icon(
                    isShowSendButton ? Icons.send : Icons.mic,
                    color: greyColor,
                  ),
                  onTap: () {
                    sendTextMessage();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
