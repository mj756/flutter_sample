class ApiResponse {
  //this is sample common api response format you can set your own by changing/adding fields
  late int status;
  late String message;
  late Object? data;

  ApiResponse() {
    status = -1;
    message = '';
    data = null;
  }

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as int;
    if(status==0 && json['data'] !=null)
      {
        data = json['data'] as Object;
      }else{
      data=null;
    }
    message = json['message'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;

    return data;
  }
}
