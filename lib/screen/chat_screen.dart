import 'package:flutter/material.dart';
import 'package:telegramm/service/message_service.dart';
import '../model/chat.dart';
import '../model/user.dart';

class ChatScreen extends StatelessWidget {
  final User contact;
  final String currentUserId;

  ChatScreen({required this.contact, required this.currentUserId});
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;
    await _chatService.addMessage(_controller.text, currentUserId, contact.id);
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
                      subtitle: Text('Sender: ${message.senderId}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Text message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
