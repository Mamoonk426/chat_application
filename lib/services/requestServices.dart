import 'package:chat_application/models/requestModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Requestservices {
  FirebaseFirestore dbInstance = FirebaseFirestore.instance;

  Future<void> sendRequest(String recieverId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User is not logged in');
    }
    DocumentReference docref = dbInstance.collection('friendRequests').doc();
    await docref.set({
      'senderId': currentUser.uid,
      'recieverId': recieverId,
      'requestId': docref.id,
      'status': 'Pending',
    });
  }

  Future<void> listenRequest(RequestModel requestmodel) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User is not logged in');
    }
    dbInstance
        .collection('friendRequest')
        .where('recieverId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .listen((snapshots) {
          if (snapshots.docs.isEmpty) {
            print('No Request found');
          } else {
            for (var doc in snapshots.docs) {
              RequestModel model = RequestModel.fromMap(doc.data());
            }
          }
        });
  }
}
