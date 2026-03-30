import 'package:chat_application/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Getuserservices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Usermodel>> getUsers() async {
    final snapshot = await firebaseFirestore.collection('Users').get();
    return snapshot.docs.map((doc) => Usermodel.fromMap(doc.data())).toList();
  }

}
