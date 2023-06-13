import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/core/message_enum.dart';
import 'package:bit_messenger/features/chat/widgets/video_player_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DisplayTextFileCard extends StatelessWidget {
  final String message;
  final MessageEnum messageEnum;
  const DisplayTextFileCard({
    super.key,
    required this.message,
    required this.messageEnum,
  });

  @override
  Widget build(BuildContext context) {
    return (messageEnum == MessageEnum.text)
        ? Text(
            message,
            style: const TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          )
        : (messageEnum == MessageEnum.image)
            ? CachedNetworkImage(
                imageUrl: message,
                height: 200,
                width: 200,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return CircularProgressIndicator(
                    value: downloadProgress.progress,
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : (messageEnum == MessageEnum.video)
                ? VideoPlayerItem(
                    videoUrl: message,
                  )
                : Container(); // AudioPlayer
  }
}
