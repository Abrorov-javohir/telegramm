import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegramm/model/chat.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Chat>> getChats(String currentUserId, String contactId) {
    return _firestore
        .collection('chats')
        .where('sendId', isEqualTo: currentUserId)
        .where('receivedId', isEqualTo: contactId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        return Chat.fromJson(doc);
      }).toList();
    });
  }

  Future<void> addMessage(String message, String sendId, String receiveId,
      {bool isImage = false}) async {
    await _firestore.collection('chats').add({
      'messages': message,
      'sendId': sendId,
      'receivedId': receiveId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
