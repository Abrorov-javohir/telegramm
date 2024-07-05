import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegramm/model/user.dart';
import 'package:telegramm/service/user_service.dart';
import 'chat_screen.dart'; // ChatScreen-ni import qilish

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final currentUserId =
        'YOUR_USER_ID'; // Hozirgi foydalanuvchi ID'sini o'rnating

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final nameController = TextEditingController();
                  final emailController = TextEditingController();

                  return AlertDialog(
                    title: Text('Add Contact'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter name',
                          ),
                        ),
                        SizedBox(height: 8), // Qo'shimcha bo'sh joy
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter email',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          userService.addContact(
                            nameController.text,
                            emailController.text,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search Message', // Qidiruv maydoni uchun matn
              border: InputBorder.none, // Chegarasiz qidiruv maydoni
              icon: Icon(Icons.search, color: Colors.grey), // Qidiruv ikonkasi
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value; // Qidiruv so'rovini yangilash
              });
            },
          ),
          Expanded(
            child: StreamBuilder<List<User>>(
              stream: userService.getContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                }
                final contacts = snapshot.data!
                    .where((contact) => contact.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                        leading: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            child: Text(contact.name[0]),
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    contact: contact,
                                    currentUserId: currentUserId),
                              ),
                            );
                          },
                          child: Text(contact.name),
                        ),
                        subtitle: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  contact: contact,
                                  currentUserId: currentUserId,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Last seen recently',
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
