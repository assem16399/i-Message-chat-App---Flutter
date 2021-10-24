import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  bool isMe({String? messageUid, currentUid}) {
    if (messageUid == currentUid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      //TODO stream: Firestore.instance
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
              chatStreamSnapshot) {
        if (chatStreamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (chatStreamSnapshot.data != null) {
          return ListView.builder(
            reverse: true,
            itemBuilder: (context, index) => MessageBubble(
              imageUrl:
                  chatStreamSnapshot.data!.docs[index].data()['userImageUrl'],
              key: ValueKey(chatStreamSnapshot.data!.docs[index].id),
              username: chatStreamSnapshot.data!.docs[index].data()['username'],
              isMe: isMe(
                  messageUid:
                      chatStreamSnapshot.data!.docs[index].data()['userId'],
                  currentUid: user!.uid),
              message: chatStreamSnapshot.data!.docs[index].data()['text'],
            ),
            itemCount: chatStreamSnapshot.data!.docs.length,
          );
        } else {
          return const Center(
            child: Text('Start the conversation'),
          );
        }
      },
    );
  }
}
