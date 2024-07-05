import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:telegramm/model/user.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<User>> getContacts() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        return User.fromJson(doc);
      }).toList();
    });
  }

  Future<void> addContact(String name, String email) async {
    await _firestore.collection('users').add({
      'email': email,
      'name': name,
    });
  }
}
