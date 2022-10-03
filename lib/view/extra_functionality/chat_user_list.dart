import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/view/extra_functionality/chat.dart';

import '../../controller/preference_controller.dart';

class ChatUserList extends StatelessWidget {
  const ChatUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['title']),
      ),
      body: FutureBuilder(
        future: getAllUser(),
        builder: (context, AsyncSnapshot<List<AppUser>> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.data == null) {
              return Center(child: Text('no data found'));
            }
            return ListView.builder(
                itemCount: snapShot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async => await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatRoom(otherUser: snapShot.data![index]))),
                    leading: CircleAvatar(
                      backgroundImage: Image.network(
                        snapShot.data![index].profileImage.isNotEmpty
                            ? snapShot.data![index].profileImage
                            : 'https://picsum.photos/200/300',
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
    final response =
        await ApiController.get('http://192.168.21.9:8000/api/user/getalluser');
    final datas = json.decode(json.encode(response.data));
    for (int i = 0; i < datas.length; i++) {
      users.add(AppUser.fromJson(json.decode(json.encode(datas[i]))));
    }
    return users;
    AppUser user = AppUser.fromJson(json.decode(PreferenceController.getString(
        PreferenceController.prefKeyUserPayload)));
    user.token = PreferenceController.getString(PreferenceController.fcmToken);
    {
      final data = await FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: user.email)
          .get();
      final List<DocumentSnapshot> documents = data.docs;
      if (documents.isNotEmpty) {
        bool found = false;
        for (int i = 0; i < documents.length; i++) {
          if (AppUser.fromJson(json.decode(json.encode(documents[i].data())))
                  .token !=
              user.token) {
            await documents[i].reference.delete();
          } else {
            found = true;
          }
        }
        if (found == false) {
          await FirebaseFirestore.instance
              .collection('users')
              .add(user.toJson());
        }
      } else {
        await FirebaseFirestore.instance.collection('users').add(user.toJson());
      }
    }
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where("Email", isNotEqualTo: user.email)
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
