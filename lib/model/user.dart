import 'dart:ffi';

class AppUser {
  late String id;
  late String name;
  late String email;
  late String token;
 late String profileImage;
  AppUser() {
     id='';
     name='';
     email='';
     token='';
     profileImage='';

  }
  AppUser.fromJson(Map<String, dynamic> json) {
    id = (json['Id']).toString();
    email = json['Email'] as String;
    name = json['Name'] as String;
    token = json['Token'] as String;
    profileImage='';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] =id;
    data['Email'] =email;
    data['Name'] =name;
    data['Token'] =token;
    data['ProfileImage'] =profileImage;

    return data;
  }
  AppUser.fromGoogleJson(Map<String,dynamic> json) {
    id = json['uid'] as String;
    email = json['email'] as String;
    name = json['displayName'] as String;
    token = json['Token'] as String;
    profileImage=json['photoURL'] as String;
  }
  AppUser.fromMicrosoftJson( Map<String, dynamic> json) {
    id = json['UserId'] ?? '';
    name = json['UserName'] ?? '';
    email = json['UserEmail'] ?? '';
    profileImage = json['ProfileImage'] ?? '';
  }
}
