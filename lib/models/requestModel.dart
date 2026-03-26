import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String requestId; // unique request ID
  final String senderId; // who sent the request
  final String receiverId; // who will receive it
  final String senderName; // sender's display name
  final String receiverName; // receiver's display name
  final String status; // "pending" / "accepted" / "rejected"
  final DateTime? createdAt;

  const RequestModel({
    required this.requestId,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.status,
    required this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['createdAt'];
    DateTime? createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtRaw);
    }

    return RequestModel(
      requestId: map['requestId'] as String,
      senderId: map['senderId'] as String,
      receiverId: (map['receiverId'] ?? map['recieverId']) as String,
      senderName: (map['senderName'] as String?) ?? '',
      receiverName: (map['receiverName'] as String?) ?? '',
      status: (map['status'] as String?) ?? 'Pending',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'senderId': senderId,
      'recieverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
