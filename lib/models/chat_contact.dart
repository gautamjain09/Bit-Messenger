class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime sentTime;
  final String lastMessage;
  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.sentTime,
    required this.lastMessage,
  });

  ChatContact copyWith({
    String? name,
    String? profilePic,
    String? contactId,
    DateTime? sentTime,
    String? lastMessage,
  }) {
    return ChatContact(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      contactId: contactId ?? this.contactId,
      sentTime: sentTime ?? this.sentTime,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'sentTime': sentTime.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
