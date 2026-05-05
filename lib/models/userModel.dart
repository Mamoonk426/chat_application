import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isOnline;
  final DateTime? lastSeen;
  final FieldValue createdAt;
  final String? token;

  const Usermodel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phoneNumber,
    this.isOnline = false,
    this.lastSeen,
    required this.createdAt,
    this.token,
  });

  /// Create a User from a JSON/Firestore map
  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      isOnline: map['isOnline'] as bool? ?? false,
      lastSeen: map['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int)
          : null,
      createdAt: FieldValue.serverTimestamp(),
      token: map['token'] as String?,
    );
  }

  /// Convert User to a JSON/Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'createdAt': createdAt,
      'token': token,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Usermodel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
