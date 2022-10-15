import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/constants.dart';
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
        future: getAllUser(context),
        builder: (context, AsyncSnapshot<List<AppUser>> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.data == null) {
              return Center(child: Text('no data found'));
            }
            return ListView.builder(
                physics: BouncingScrollPhysics(),
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
                        snapShot.data![index].profileImage,
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

  Future<List<AppUser>> getAllUser(BuildContext context) async {
    AppUser user = AppUser.fromJson(json.decode(PreferenceController.getString(
        PreferenceController.prefKeyUserPayload)));
    List<AppUser> users = List.empty(growable: true);
    final response = await ApiController.get(
        '${AppConstants.endpointGetAllUser}?id=${user.id}');
    if (response.status == 0) {
      final datas = json.decode(json.encode(response.data));
      for (int i = 0; i < datas.length; i++) {
        users.add(AppUser.fromJson(json.decode(json.encode(datas[i]))));
      }
    } else {
      print(response.message);
    }
    return users;
  }
}
