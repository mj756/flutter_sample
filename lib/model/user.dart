import 'dart:convert';

class AppUser {
  late String id;
  late String name;
  late String email;
  late String gender;
  late String dob;
  late String token;
  late String profileImage;

  AppUser() {
    id = '';
    name = '';
    email = '';
    gender = '';
    dob = DateTime.now().toIso8601String();
    token = '';
    profileImage = '';
  }

  AppUser.fromJson(Map<String, dynamic> json) {
    id = (json['id']).toString();
    name = json['name'] as String;
    email = json['email'] as String;
    gender = json['gender'] as String;
    dob = json['dob'] as String;
    token = json['token'] as String;
    profileImage = json['profileImage'] as String;
  }
  static List<AppUser> fromJsonList(Map<String, dynamic> jsonData) {
    List<AppUser> users = List.empty(growable: true);
    for (int i = 0; i < jsonData.length; i++) {
      users.add(AppUser.fromJson(json.decode(json.encode(jsonData[i]))));
    }
    return users;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'dob': dob,
      'token': token,
      'profileImage': profileImage
    };
  }
}
