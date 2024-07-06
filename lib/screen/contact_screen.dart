import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../service/user_service.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatefulWidget {
  final String currentUserId;

  ContactsScreen({required this.currentUserId});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

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
                  final emailController = TextEditingController();

                  return AlertDialog(
                    title: Text('Add Contact'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        onPressed: () async {
                          final contact = await userService
                              .getUserByEmail(emailController.text);
                          if (contact != null) {
                            await userService.addContact(
                                widget.currentUserId, contact.id);
                            print(
                                'Contact added: ${contact.id}'); // Log contact added
                          } else {
                            print(
                                'Contact not found for email: ${emailController.text}'); // Log contact not found
                          }
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
            decoration: InputDecoration(
              hintText: 'Search Contacts',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<List<User>>(
              stream: userService.getContactsStream(widget.currentUserId),
              builder: (context, snapshot) {
                debugPrint('Snapshot data: ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final contacts = snapshot.data ?? [];
                if (contacts.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                }
                final filteredContacts = contacts
                    .where((contact) => contact.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();
                if (filteredContacts.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                }
                return ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
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
                                currentUserId: widget.currentUserId,
                              ),
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
                                currentUserId: widget.currentUserId,
                              ),
                            ),
                          );
                        },
                        child: Text(contact.email),
                      ),
                    );
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
