import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/widgets/massage_textfield.dart';
import 'package:chat_app/widgets/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  //first we have to know the current user and reciver

  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen(
      {required this.currentUser,
      required this.friendId,
      required this.friendName,
      required this.friendImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(88),
              child: CachedNetworkImage(
                imageUrl: friendImage,
                placeholder: ((context, url) => CircularProgressIndicator()),
                errorWidget: ((context, url, error) => Icon(Icons.error)),
                height: 40,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(friendName, style: TextStyle(fontSize: 20))
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.all(10), //wexpended wiget will took all the space
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  // if (snapshot.hasData) {
                  //   if (snapshot.data.docs.length < 1) {
                  //     return Center(
                  //       child: Text("Say Hi"),
                  //     );
                  //   }
                  //   // return ListView.builder(
                  //   //     itemCount: snapshot.data.docs.length,
                  //   //     reverse: true,
                  //   //     physics: BouncingScrollPhysics(),
                  //   //     itemBuilder: ((context, index) {
                  //   //       bool isMe = snapshot.data.docs[index]['senderId'] ==
                  //   //           currentUser.uid;
                  //   //       return SingleMessage(
                  //   //           message: snapshot.data.docs[index]['message'],
                  //   //           isMe: isMe);
                  //   //     }));
                  // }

                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text("Say Hi..."),
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            currentUser.uid;
                        return SingleMessage(
                            message: snapshot.data.docs[index]['message'],
                            isMe: isMe);
                      },
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          MassageTextField(currentUser.uid, friendId)
        ],
      ),
    );
  }
}
