import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String documentId;
  final String senderId;
  final String message;
  final DateTime sentAt;
  final String status;

  MessageModel({
    required this.documentId,
    required this.senderId,
    required this.message,
    required this.sentAt,
    required this.status,
  });

  // ✅ Firestore → MessageModel
  factory MessageModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return MessageModel(
      documentId: doc.id,
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'sent',
    );
  }

  // ✅ MessageModel → Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'sentAt': Timestamp.fromDate(sentAt),
      'status': status,
    };
  }

  // ✅ copyWith
  MessageModel copyWith({
    String? documentId,
    String? senderId,
    String? message,
    DateTime? sentAt,
    bool? isRead,
    String? status,
  }) {
    return MessageModel(
      documentId: documentId ?? this.documentId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'MessageModel('
        'documentId: $documentId, '
        'senderId: $senderId, '
        'message: $message, '
        'sentAt: $sentAt , '
        'status : $status';
  }
}
