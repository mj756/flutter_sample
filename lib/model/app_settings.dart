class AppSettings {

  late int smallFontSize;
  late int normalFontSize;
  late int largeFontSize;
  late bool isTesting;

  AppSettings() {
     smallFontSize=12;
     normalFontSize=14;
    largeFontSize=18;
    isTesting=false;
  }

  AppSettings.fromJson(Map<String, dynamic> json) {
    smallFontSize = json['smallFontSize'] as int;
    normalFontSize = json['normalFontSize'] as int;
    largeFontSize = json['largeFontSize'] as int;
    isTesting = json['isTesting'] as bool;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['smallFontSize'] =smallFontSize;
    data['normalFontSize'] =normalFontSize;
    data['largeFontSize'] =largeFontSize;
    data['isTesting'] =isTesting;
    return data;
  }

}