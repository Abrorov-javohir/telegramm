import 'package:flutter/material.dart'; // Flutter Material dizayn paketini import qilish
import 'package:telegramm/model/chat.dart'; // Profil ekranini import qilish

// ChatScreen StatefulWidget deklaratsiyasi
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// ChatScreenning holatini boshqaradigan sinf
class _ChatScreenState extends State<ChatScreen> {
  // Chat elementlarining ro'yxati
  List<Map<String, String>> chatItems = [
    {'name': 'Javohir', 'message': 'You Sent a Sticker'},
    {'name': 'Asrorbek', 'message': 'Asror Sereal Sent Gift'},
    {'name': 'Asilbek', 'message': 'Hi'},
    {'name': 'Putri Chania', 'message': 'Putri Chania Sent Gift'},
  ];

  // Qidiruv so'rovi uchun o'zgaruvchi
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Qidiruv so'roviga mos keladigan chat elementlarini filtrlash
    List<Map<String, String>> filteredChatItems = chatItems
        .where((chatItem) =>
            chatItem['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'), // AppBar sarlavhasi
        backgroundColor: Colors.white, // AppBar fon rangi
        foregroundColor: Colors.black, // AppBar matn rangi
        elevation: 0, // AppBar soyasi
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Tananing chetidan 16 piksel bo'sh joy
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Gorizontal bo'sh joy
              decoration: BoxDecoration(
                color: Colors.grey[200], // Kontayner fon rangi
                borderRadius:
                    BorderRadius.circular(30.0), // Kontaynerning burchaklari
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search Message', // Qidiruv maydoni uchun matn
                  border: InputBorder.none, // Chegarasiz qidiruv maydoni
                  icon: Icon(Icons.search,
                      color: Colors.grey), // Qidiruv ikonkasi
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Qidiruv so'rovini yangilash
                  });
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: filteredChatItems
                    .map((chatItem) => ChatItem(
                          name: chatItem['name']!, // Chat ismi
                          message: chatItem['message']!, // Chat xabari
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
