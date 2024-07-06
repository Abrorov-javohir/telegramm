import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat.dart';

class ChatService {
  final CollectionReference _chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  Stream<List<Chat>> getChats(String currentUserId, String contactId) {
    return _chatsCollection
        .where('senderId', isEqualTo: currentUserId)
        .where('receivedId', isEqualTo: contactId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList();
    });
  }

  Future<void> addMessage(
      String message, String senderId, String receivedId) async {
    await _chatsCollection.add({
      'messages': message,
      'senderId': senderId,
      'receivedId': receivedId,
    });
  }
}
