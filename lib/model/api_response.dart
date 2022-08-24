class ApiResponse {
  //this is sample common api response format you can set your own by changing/adding fields
  late int code;
  late String message;
  late Object? data;

  ApiResponse() {
    code = -1;
    message = '';
    data = null;
  }

  ApiResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] as int;
    message = json['message']==null ? '':json['message'] as String;
    data = json['data'] != null ? json['data'] as Object:null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = data;
    }
    return data;
  }
}
