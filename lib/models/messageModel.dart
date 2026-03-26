import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String documentId;
  final String senderId;
  final String message;
  final DateTime sentAt;
  final bool isRead;

  MessageModel({
    required this.documentId,
    required this.senderId,
    required this.message,
    required this.sentAt,
    required this.isRead,
  });

  // ✅ Firestore → MessageModel
  factory MessageModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return MessageModel(
      documentId: doc.id,
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  // ✅ MessageModel → Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'sentAt': Timestamp.fromDate(sentAt),
      'isRead': isRead,
    };
  }

  // ✅ copyWith
  MessageModel copyWith({
    String? documentId,
    String? senderId,
    String? message,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return MessageModel(
      documentId: documentId ?? this.documentId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() {
    return 'MessageModel('
        'documentId: $documentId, '
        'senderId: $senderId, '
        'message: $message, '
        'sentAt: $sentAt, '
        'isRead: $isRead)';
  }
}
