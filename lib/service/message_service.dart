// import 'package:cloud_firestore/cloud_firestore.dart';

// class MessageService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Send a message
//   Future<void> sendMessage(String chatId, String text, bool isSent) async {
//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .add({
//       'text': text,
//       'isSent': isSent,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   // Get messages stream
//   Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
//     return _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) {
//               return {
//                 'text': doc['text'],
//                 'isSent': doc['isSent'],
//                 'timestamp': doc['timestamp'],
//               };
//             }).toList());
//   }
// }
