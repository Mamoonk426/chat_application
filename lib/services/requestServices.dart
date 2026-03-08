import 'package:chat_application/components/Toasts.dart';
import 'package:chat_application/models/requestModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Stream<Set<String>> friendIdsStream(String userId) {
    // Listen to requests SENT by this user that were accepted
    final sentStream = dbInstance
        .collection('friendRequests')
        .where('senderId', isEqualTo: userId)
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((snapshot) {
          final ids = <String>{};
          for (final doc in snapshot.docs) {
            final receiverId = doc.data()['recieverId'];
            if (receiverId is String) {
              ids.add(receiverId);
            }
          }
          return ids;
        });

    // Listen to requests RECEIVED by this user that were accepted
    final receivedStream = dbInstance
        .collection('friendRequests')
        .where('recieverId', isEqualTo: userId)
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((snapshot) {
          final ids = <String>{};
          for (final doc in snapshot.docs) {
            final senderId = doc.data()['senderId'];
            if (senderId is String) {
              ids.add(senderId);
            }
          }
          return ids;
        });

    // Combine both streams
    return sentStream.asyncExpand((sentIds) {
      return receivedStream.map((receivedIds) {
        return {...sentIds, ...receivedIds};
      });
    });
  }

  Future<void> sendRequest(String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User need to Login first');
    }
    final docRef = dbInstance.collection('friendRequests').doc();
    final request = RequestModel(
      requestId: docRef.id,
      senderId: currentUser.uid,
      receiverId: receiverId,
      status: 'Pending',
      createdAt: DateTime.now(),
    );
    await docRef.set(request.toMap());
    //   'senderId': currentUser.uid,
    //   'recieverId': recieverId,
    //   'requestId': docRef.id,
    //   'status': 'Pending',

    // });
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
        .snapshots(includeMetadataChanges: false)
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
        })
        .distinct((prev, next) {
          if (prev.length != next.length) return false;
          for (final key in prev.keys) {
            if (prev[key] != next[key]) return false;
          }
          return true;
        });
  }

  Future<void> acceptRequest(String docId, BuildContext context) async {
    await dbInstance.collection('friendRequests').doc(docId).update({
      'status': 'Accepted',
    });
    Toasts.successToast('Requested Accepted', context);
  }
}
