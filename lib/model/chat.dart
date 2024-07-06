import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String messages;
  final String senderId;
  final String receivedId;

  Chat({
    required this.id,
    required this.messages,
    required this.senderId,
    required this.receivedId,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      messages: data['messages'] as String,
      senderId: data['senderId'] as String,
      receivedId: data['receivedId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages,
      'senderId': senderId,
      'receivedId': receivedId,
    };
  }
}
