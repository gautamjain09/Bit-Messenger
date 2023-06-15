import 'dart:io';
import 'package:bit_messenger/core/message_enum.dart';
import 'package:bit_messenger/core/providers/message_reply_provider.dart';
import 'package:bit_messenger/core/utils.dart';
import 'package:bit_messenger/features/chat/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void sendTextMessage() async {
    if (_messageController.text.trim() != "") {
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

  void sendFileMessage({
    required File file,
    required MessageEnum messageEnum,
  }) {
    ref.watch(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          recieverId: widget.recieverId,
          messageEnum: messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImage(context);
    if (image != null) {
      sendFileMessage(
        file: image,
        messageEnum: MessageEnum.image,
      );
    }
  }

  void selectVideo() async {
    File? video = await pickVideo(context);
    if (video != null) {
      sendFileMessage(
        file: video,
        messageEnum: MessageEnum.video,
      );
    }
  }

  void toggleEmojiKeyBoardContainer() {
    if (isShowEmojiContainer) {
      focusNode.requestFocus();
      setState(() {
        isShowEmojiContainer = false;
      });
    } else {
      focusNode.unfocus();
      setState(() {
        isShowEmojiContainer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
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
                      onTap: () {
                        toggleEmojiKeyBoardContainer();
                      },
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
                            onTap: () {
                              selectImage();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            child: const Icon(
                              Icons.attach_file,
                              color: greyColor,
                            ),
                            onTap: () {
                              selectVideo();
                            },
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
                child: InkWell(
                  child: const Icon(
                    Icons.send,
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
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
