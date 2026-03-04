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
  }

  Stream<List<RequestModel>> getSentRequestStream(String receiverId) {
    return dbInstance
        .collection('friendRequests')
        .where('recieverId', isEqualTo: receiverId)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshots) {
          return snapshots.docs
              .map((doc) => RequestModel.fromMap(doc.data()))
              .toList();
        });
  }

  Stream<Map<String, String>> getSenderNamesStream() {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    return dbInstance
        .collection('friendRequests')
        .where('recieverId', isEqualTo: currentId)
        .snapshots()
        .asyncMap((snapshot) async {
          Map<String, String> names = {};

          for (var doc in snapshot.docs) {
            final senderId = doc.data()['senderId'] as String?;
            if (senderId == null) continue;

            final userDoc = await dbInstance
                .collection('Users')
                .doc(senderId)
                .get();
            final name = userDoc.data()?['name'] as String?;

            if (name != null) {
              names[senderId] = name;
            }
          }

          return names;
        });
  }
}
