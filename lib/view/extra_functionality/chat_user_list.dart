import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/view/extra_functionality/chat.dart';

class ChatUserList extends StatelessWidget {
  const ChatUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAllUser(),
        builder: (context, AsyncSnapshot<List<AppUser>> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount:  snapShot.data!.length,
                itemBuilder: (context, index) {
              return ListTile(
                onTap: () async => await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatRoom(otherUser:snapShot.data![index]))),
                leading: CircleAvatar(
                  backgroundImage:
                   Image.network(
                    snapShot.data![index].profileImage.isNotEmpty ? snapShot.data![index].profileImage: 'https://picsum.photos/200/300',
                    height: 30,
                    width: 30,
                  ).image,
                ),
                title: Text(snapShot.data![index].name),
              );
            });
          }
        },
      ),
    );
  }

  Future<List<AppUser>> getAllUser() async {
    List<AppUser> users = List.empty(growable: true);
    final data = await FirebaseFirestore.instance
        .collection('users')
        // .where("SenderId", isEqualTo: 101)
        .get();
    final List<DocumentSnapshot> documents = data.docs;
    if (documents.isNotEmpty) {
      documents.map((doc) => doc.data()).forEach((element) {
        users.add(AppUser.fromJson(json.decode(json.encode(element))));
      });
    }
    if (users.isNotEmpty) {
      users.sort((a, b) => a.name.compareTo(b.name));
    }
    return users;
  }
}
