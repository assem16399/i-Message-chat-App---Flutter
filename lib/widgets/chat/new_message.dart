import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _messageController = TextEditingController();

  void _sendMessage() async {
    //TODO _SendMessage() Function
    final userAuth = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': userAuth.uid,
      'username': userData.data()!['username'],
      'userImageUrl': userData.data()!['imageUrl']
    });
    _messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            labelText: 'send message',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed:
                  _enteredMessage.trim().isNotEmpty ? _sendMessage : null,
              splashRadius: 20,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _enteredMessage = value;
            });
          },
        ));
  }
}
