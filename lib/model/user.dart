import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
    );
  }
}
