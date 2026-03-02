import 'package:chat_application/models/requestModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Requestservices {
  FirebaseFirestore dbInstance = FirebaseFirestore.instance;

  Stream<Set<String>> sentRequestReceiverIdsStream(String senderId) {
    return dbInstance
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .snapshots()
        .map((snapshot) {
          final receiverIds = <String>{};
          for (final doc in snapshot.docs) {
            final receiverId = doc.data()['recieverId'];
            if (receiverId is String) {
              receiverIds.add(receiverId);
            }
          }
          return receiverIds;
        });
  }

  Future<void> sendRequest(String recieverId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User need to Login first');
    }
    final docRef = dbInstance.collection('friendRequests').doc();
    await docRef.set({
      'senderId': currentUser.uid,
      'recieverId': recieverId,
      'requestId': docRef.id,
      'status': 'Pending',
    });
  }

  Future<void> listenRequest(RequestModel requestmodel) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User is not logged in');
    }
    dbInstance
        .collection('friendRequests')
        .where('recieverId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .listen((snapshots) {
          if (snapshots.docs.isEmpty) {
            print('No Request found');
          } else {
            for (var doc in snapshots.docs) {
              RequestModel.fromMap(doc.data());
            }
          }
        });
  }
}
