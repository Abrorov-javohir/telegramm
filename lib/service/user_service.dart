import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  // Foydalanuvchi kontaktlari oqimini olish
  Stream<List<User>> getContactsStream(String userId) {
    return _contactsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final userDocs = await Future.wait(
        snapshot.docs.map((doc) async {
          final contactId = doc['contactId'];
          print('Contact ID: $contactId'); // Log contact ID
          final userDoc = await _usersCollection.doc(contactId).get();
          print('User Doc: ${userDoc.data()}'); // Log user document data
          return User.fromDocument(userDoc);
        }).toList(),
      );
      return userDocs;
    });
  }

  // Yangi kontakt qo'shish
  Future<void> addContact(String userId, String contactId) async {
    try {
      await _contactsCollection.add({
        'userId': userId,
        'contactId': contactId,
      });
      print(
          'Contact added: userId=$userId, contactId=$contactId'); // Log contact addition
    } catch (e) {
      print('Error adding contact: $e');
      throw e;
    }
  }

  // Elektron pochta orqali foydalanuvchini olish
  Future<User?> getUserByEmail(String email) async {
    try {
      final querySnapshot =
          await _usersCollection.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        print(
            'User found: ${querySnapshot.docs.first.data()}'); // Log found user data
        return User.fromDocument(querySnapshot.docs.first);
      }
      print('No user found with email: $email'); // Log no user found
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      throw e;
    }
  }

  // Hozirgi foydalanuvchini kontaktlarga qo'shish
  Future<void> addCurrentUserToContacts(
      String currentUserId, String contactEmail) async {
    try {
      final contactUser = await getUserByEmail(contactEmail);
      if (contactUser != null) {
        await addContact(currentUserId, contactUser.id);
      } else {
        print(
            'Contact user not found for email: $contactEmail'); // Log contact not found
      }
    } catch (e) {
      print('Error adding current user to contacts: $e');
      throw e;
    }
  }
}
