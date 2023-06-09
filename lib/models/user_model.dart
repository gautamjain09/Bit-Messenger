class UserModel {
  final String name;
  final String uid;
  final String profileUrl;
  final bool isOnline;
  final String email;
  final List<String> groupId;
  UserModel({
    required this.name,
    required this.uid,
    required this.profileUrl,
    required this.isOnline,
    required this.email,
    required this.groupId,
  });

  UserModel copyWith({
    String? name,
    String? uid,
    String? profileUrl,
    bool? isOnline,
    String? email,
    List<String>? groupId,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profileUrl: profileUrl ?? this.profileUrl,
      isOnline: isOnline ?? this.isOnline,
      email: email ?? this.email,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profileUrl': profileUrl,
      'isOnline': isOnline,
      'email': email,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profileUrl: map['profileUrl'] as String,
      isOnline: map['isOnline'] as bool,
      email: map['email'] as String,
      groupId: List<String>.from((map['groupId'])),
    );
  }
}
