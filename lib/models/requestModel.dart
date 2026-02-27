import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String requestId; // unique request ID
  final String senderId; // who sent the request
  final String receiverId; // who will receive it
  final String status; // "pending" / "accepted" / "rejected"
  final DateTime createdAt;

  RequestModel({
    required this.requestId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      requestId: map['requestId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
