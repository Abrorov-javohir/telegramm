import 'package:flutter/material.dart';
import 'package:telegramm/service/local_notification.dart';
import 'package:timezone/timezone.dart' as tz;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hi how are you', 'isSent': false},
    {'text': 'Hi I am fine and you', 'isSent': true},
    {'text': 'Me too', 'isSent': false},
  ];

  final TextEditingController _controller = TextEditingController();
  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.init();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({'text': _controller.text, 'isSent': true});
        _controller.clear();
      });
      _scheduleNotifications();
    }
  }

  void _scheduleNotifications() {
    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    // Local notification
    _notificationService.scheduleNotification(scheduledDate);

    // Push notification
    _notificationService.schedulePushNotification(
        scheduledDate, 'You have a new message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              child: Text('A'),
            ),
            SizedBox(width: 8),
            Text('Asrorbek'),
          ],
        ),
        backgroundColor: Colors.purple[100],
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isSent']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: message['isSent']
                          ? Colors.purple[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['text']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.camera_alt), onPressed: () {}),
                IconButton(icon: const Icon(Icons.photo), onPressed: () {}),
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
