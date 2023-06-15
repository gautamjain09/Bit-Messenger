import 'package:bit_messenger/core/providers/message_reply_provider.dart';
import 'package:bit_messenger/features/chat/widgets/display_text_file_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 360,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 20,
                ),
                onTap: () {
                  // Cancel Reply
                  ref
                      .watch(messageReplyProvider.notifier)
                      .update((state) => null);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          DisplayTextFileCard(
            message: messageReply.message,
            messageEnum: messageReply.messageEnum,
          ),
        ],
      ),
    );
  }
}
