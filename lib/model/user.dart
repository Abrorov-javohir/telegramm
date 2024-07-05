import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  String name;

  User({
    required this.email,
    required this.id,
    required this.name,
  });

  factory User.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      email: data['email'],
      id: doc.id,
      name: data['name'],
    );
  }
}
