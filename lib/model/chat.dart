import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String messages;
  String sendId;
  String receivedId;
  String id;

  Chat({
    required this.messages,
    required this.id,
    required this.receivedId,
    required this.sendId,
  });

  factory Chat.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      messages: data['messages'],
      receivedId: data['receivedId'],
      sendId: data['sendId'],
    );
  }
}
