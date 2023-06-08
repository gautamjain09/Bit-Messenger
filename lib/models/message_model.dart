import 'package:bit_messenger/core/message_enum.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime sentTime;
  final String messageId;
  final bool isSeen;
  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.type,
    required this.sentTime,
    required this.messageId,
    required this.isSeen,
  });

  MessageModel copyWith({
    String? senderId,
    String? recieverId,
    String? text,
    MessageEnum? type,
    DateTime? sentTime,
    String? messageId,
    bool? isSeen,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      text: text ?? this.text,
      type: type ?? this.type,
      sentTime: sentTime ?? this.sentTime,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      'sentTime': sentTime.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }
}
