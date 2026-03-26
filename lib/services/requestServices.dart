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
        .where('status', isEqualTo: 'Pending')
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
    return dbInstance
        .collection('friends')
        .doc(userId)
        .collection('friends')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  Stream<List<Map<String, dynamic>>> getFriendsStream(String userId) {
    return dbInstance
        .collection('friends')
        .doc(userId)
        .collection('friends')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  Future<void> sendRequest(String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User need to Login first');
    }

    // Fetch display names for both sender and receiver
    final senderDoc = await dbInstance
        .collection('Users')
        .doc(currentUser.uid)
        .get();
    final receiverDoc = await dbInstance
        .collection('Users')
        .doc(receiverId)
        .get();
    final senderName = senderDoc.data()?['name'] as String? ?? '';
    final receiverName = receiverDoc.data()?['name'] as String? ?? '';

    final docRef = dbInstance.collection('friendRequests').doc();
    final request = RequestModel(
      requestId: docRef.id,
      senderId: currentUser.uid,
      receiverId: receiverId,
      senderName: senderName,
      receiverName: receiverName,
      status: 'Pending',
      createdAt: DateTime.now(),
    );
    await docRef.set(request.toMap());
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
    try {
      final docSnapshot = await dbInstance
          .collection('friendRequests')
          .doc(docId)
          .get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data()!;
      final senderId = data['senderId'] as String;
      final receiverId = (data['receiverId'] ?? data['recieverId']) as String;
      final senderName = data['senderName'] as String? ?? 'Friend';
      final receiverName = data['receiverName'] as String? ?? 'Friend';

      final batch = dbInstance.batch();

      // Add to sender's friend list
      batch.set(
        dbInstance
            .collection('friends')
            .doc(senderId)
            .collection('friends')
            .doc(receiverId),
        {'name': receiverName, 'addedAt': FieldValue.serverTimestamp()},
      );

      // Add to receiver's friend list
      batch.set(
        dbInstance
            .collection('friends')
            .doc(receiverId)
            .collection('friends')
            .doc(senderId),
        {'name': senderName, 'addedAt': FieldValue.serverTimestamp()},
      );

      // Delete the request
      batch.delete(dbInstance.collection('friendRequests').doc(docId));

      await batch.commit();

      if (context.mounted) {
        Toasts.successToast('Friend request accepted', context);
      }
    } catch (e) {
      if (context.mounted) {
        Toasts.errorToast('Failed to accept request: ${e.toString()}', context);
      }
    }
  }

  /// Streams all requests SENT BY the current user.
  Stream<List<RequestModel>> getSentByMeRequestStream(String senderId) {
    return dbInstance
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => RequestModel.fromMap(doc.data()))
              .toList();
        });
  }

  /// Streams a map of receiverId → display name for sent requests.
  Stream<Map<String, String>> getReceiverNamesStream() {
    final currentId = FirebaseAuth.instance.currentUser!.uid;
    return dbInstance
        .collection('friendRequests')
        .where('senderId', isEqualTo: currentId)
        .snapshots(includeMetadataChanges: false)
        .asyncMap((snapshot) async {
          Map<String, String> names = {};

          for (var doc in snapshot.docs) {
            final receiverId =
                (doc.data()['receiverId'] ?? doc.data()['recieverId'])
                    as String?;
            if (receiverId == null) continue;

            final userDoc = await dbInstance
                .collection('Users')
                .doc(receiverId)
                .get();
            final name = userDoc.data()?['name'] as String?;

            if (name != null) {
              names[receiverId] = name;
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
}
