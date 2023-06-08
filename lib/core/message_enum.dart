enum MessageEnum {
  text("text"),
  image("image"),
  video("video"),
  audio("audio");

  final String type;
  const MessageEnum(this.type);
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'image':
        return MessageEnum.image;
      case 'video':
        return MessageEnum.video;
      case 'audio':
        return MessageEnum.audio;
      default:
        return MessageEnum.text;
    }
  }
}
