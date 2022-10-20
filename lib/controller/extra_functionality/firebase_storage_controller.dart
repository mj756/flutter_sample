import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sample/model/user.dart';

// while inserting data we send custom user id , but while display data we display document reference id as a user id so that we can use this id to update or delete user detail.

class FirebaseStorageController extends ChangeNotifier {
  List<AppUser> users = List.empty(growable: true);

  FirebaseStorageController() {
    getData().then((value) {
      notifyListeners();
    });
  }
  Future<void> addData(
      {required String id, required String name, required String email}) async {
    AppUser user = new AppUser();
    user.id = id;
    user.name = name;
    user.email = email;
    final DocumentReference data =
        await FirebaseFirestore.instance.collection('users').add(user.toJson());
    user.id = data.id;
    users.add(user);
    notifyListeners();
  }

  Future<void> getData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        // .where('Email', isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> documents = data.docs;
    if (documents.isNotEmpty) {
      users.addAll(documents
          .map<AppUser>((e) =>
              AppUser.fromJson(Map<String, dynamic>.from(e.data() as Map))
                ..id = e.id)
          .toList());
      /* for (int i = 0; i < documents.length; i++) {
        AppUser temp =
            AppUser.fromJson(json.decode(json.encode(documents[i].data())));
        temp.id = documents[i].id;
        users.add(temp);
      }*/
    }
  }

  Future<void> searchData(String id) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    final List<DocumentSnapshot> documents = data.docs;
    if (documents.isNotEmpty) {
      for (int i = 0; i < documents.length; i++) {
        users.add(
            AppUser.fromJson(json.decode(json.encode(documents[i].data()))));
      }
    }
  }

  Future<void> updateData(
      {required String id, required String name, required String email}) async {
    AppUser user = new AppUser();
    user.id = id;
    user.name = name;
    user.email = email;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id) // <-- Doc ID where data should be updated.
        .update(user.toJson());

    int index = users.indexWhere((element) => element.id == id);
    if (index >= 0) {
      users[index] = user;
      notifyListeners();
    }
  }

  Future<void> deleteData(String tableName, String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete()
        .then((value) {
      users.removeWhere((element) => element.id == id);
      notifyListeners();
    });
  }
}
