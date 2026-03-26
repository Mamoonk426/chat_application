import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String documentId;
  final DateTime lastMessageTime;
  final List<String> participants;
  final Map<String, String> participantNames; // uid → display name
  final String senderName;
  final String receiverName;
  final String lastMessageSenderId;
  final String lastMessage;

  ChatModel({
    required this.documentId,
    required this.lastMessageTime,
    required this.participants,
    required this.participantNames,
    required this.senderName,
    required this.receiverName,
    required this.lastMessageSenderId,
    required this.lastMessage,
  });

  // ✅ Firestore → ChatModel
  factory ChatModel.fromMap(DocumentSnapshot doc) {
    try {
      final map = doc.data() as Map<String, dynamic>;
      return ChatModel(
        documentId: doc.id,
        lastMessageTime: map['lastMessageTime'] is Timestamp 
            ? (map['lastMessageTime'] as Timestamp).toDate()
            : DateTime.now(),
        participants: List<String>.from(map['participants'] ?? []),
        participantNames: Map<String, String>.from(map['participantNames'] ?? {}),
        senderName: (map['senderName'] as String?) ?? '',
        receiverName: (map['receiverName'] as String?) ?? '',
        lastMessageSenderId: map['lastMessageSenderId'] ?? '',
        lastMessage: map['lastMessage'] != null 
            ? (map['lastMessage'] is Map 
                ? (map['lastMessage'] as Map<String, dynamic>)['message'] ?? ''
                : map['lastMessage'].toString())
            : '',
      );
    } catch (e) {
      print('Error parsing ChatModel from document ${doc.id}: $e');
      // Return a placeholder or rethrow depending on strategy. 
      // For list display, we want to at least see why it failed.
      return ChatModel(
        documentId: doc.id,
        lastMessageTime: DateTime.now(),
        participants: [],
        participantNames: {},
        senderName: '',
        receiverName: '',
        lastMessageSenderId: 'ERROR',
        lastMessage: 'Error parsing chat data',
      );
    }
  }

  // ✅ ChatModel → Firestore
  Map<String, dynamic> toMap() {
    return {
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'participants': participants,
      'participantNames': participantNames,
      'senderName': senderName,
      'receiverName': receiverName,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessage': lastMessage,
    };
  }

  // ✅ copyWith
  ChatModel copyWith({
    String? documentId,
    DateTime? lastMessageTime,
    List<String>? participants,
    Map<String, String>? participantNames,
    String? senderName,
    String? receiverName,
    String? lastMessageSenderId,
    String? lastMessage,
  }) {
    return ChatModel(
      documentId: documentId ?? this.documentId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  String toString() {
    return 'ChatModel('
        'documentId: $documentId, '
        'lastMessage: $lastMessage, '
        'lastMessageTime: $lastMessageTime, '
        'participants: $participants, '
        'participantNames: $participantNames, '
        'senderName: $senderName, '
        'receiverName: $receiverName, '
        'lastMessageSenderId: $lastMessageSenderId)';
  }
}
