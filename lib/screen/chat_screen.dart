import 'package:flutter/material.dart';
import 'package:telegramm/model/chat.dart';
import 'package:telegramm/model/user.dart';
import 'package:telegramm/service/message_service.dart';

class ChatScreen extends StatelessWidget {
  final User contact;
  final String currentUserId;

  ChatScreen({required this.contact, required this.currentUserId});
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // Firestore'ga chat hujjatini qo'shish
    await _chatService.addMessage(_controller.text, currentUserId, contact.id);

    // Xabar yuborilgandan keyin matn maydonini tozalash
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Chat>>(
              stream: _chatService.getChats(currentUserId, contact.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.messages),
                      subtitle: Text('Sender: ${message.receivedId}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // Butunlay bo'sh joy
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {}), // Kamera ikonkasi
                IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () {}), // Foto ikonkasi
                Expanded(
                  child: TextField(
                    controller: _controller, // Matn maydoni kontrolleri
                    decoration: InputDecoration(
                      hintText: 'Text message', // Matn maydoni uchun hint matni
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Matn maydoni burchaklarini yumaloqlash
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send), // Yuborish ikonkasi
                  onPressed: _sendMessage, // Xabar jo'natish
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
