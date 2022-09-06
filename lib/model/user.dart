class AppUser {
  //this is sample common api response format you can set your own by changing/adding fields
  late int id;
  late String name;
  late String email;
  late String token;
 late String profileImage;
  AppUser() {
     id=0;
     name='';
     email='';
     token='';
     profileImage='';
  }

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['Id'] as int;
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
    data['profileImage'] ='';
    return data;
  }
}
