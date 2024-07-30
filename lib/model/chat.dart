import 'package:flutter/material.dart';
import 'package:telegramm/screen/sms.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String message;

  ChatItem({required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
        radius: 24,
        backgroundColor: Colors.grey[300],
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat()),
        );
      },
    );
  }
}
