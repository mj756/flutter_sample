import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ApiController
{
  static const Duration timeOut=Duration(seconds: 30);
  static const String baseAddress="https:www.google.com/";   //put your own api endpoint address
  static const String endpointLogin="${baseAddress}login";
  static const String endpointRegistration="${baseAddress}registration";
  static const String endpointForGotPassword="${baseAddress}forgot-password";
  static const String endpointChangePassword="${baseAddress}change-password";
  static const String endpointAboutUs="${baseAddress}about";
  static const String endpointTopUsers="${baseAddress}profile-detail";
  static const String endpointLogout="${baseAddress}logout";

  static Future<bool> checkInternetStatus()async{
    try {
      final result = await InternetAddress.lookup('example.com').timeout(const Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }catch(e)
    {
      return false;
    }
    return false;
  }
  static Map<String,String> geHeader({String method='POST'})
  {
    Map<String,String> header=<String,String>{};
    try
    {

        header['Authorization']=PreferenceController.getString(
            PreferenceController.apiToken);
      if(method!="GET") {
        header['Content-type']="application/json";
      }
        header['Language']=PreferenceController.getString(PreferenceController.prefKeyLanguage);
    }catch(e)
    {

    }

    return header;
  }
  static Future<ApiResponse> get(String url) async{
    ApiResponse apiResponse=ApiResponse();
    try {

      if(await checkInternetStatus()==false)
      {
        apiResponse.status=-1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client.get(Uri.parse(url),headers: geHeader(method: 'GET')).timeout(timeOut);
      if(kDebugMode)
        {
          print(response.body);
        }
      if(response.statusCode==200)
      {
        apiResponse=ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      }
      else
      {
        apiResponse.status=response.statusCode;
      }
    } catch(ex) {
      apiResponse.status=-1;
      apiResponse.message=ex.toString();
      if(kDebugMode)
      {
        print(ex);
      }
    }
    return apiResponse;
  }

  static Future<ApiResponse> post(String url,String body,{bool isLoginApiCall=false}) async{
    ApiResponse apiResponse=ApiResponse();
    try {
      if(await checkInternetStatus()==false)
      {

        apiResponse.status=-1;
        return apiResponse;
      }
      var client = http.Client();
      final response =await client.post(Uri.parse(url),body:body , headers: geHeader()).timeout(timeOut);
      if(kDebugMode)
      {
        print(response.body);
      }
      if(response.statusCode==200)
      {
        apiResponse=ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      }
      else
      {
        apiResponse.status=response.statusCode;
        apiResponse.data=null;
      }
    } catch(ex) {
      apiResponse.status=-1;
      apiResponse.message=ex.toString();
      if(kDebugMode)
      {
        print(ex);
      }
    }
    return apiResponse;
  }

  static Future<ApiResponse> put(String url,String body) async{
    ApiResponse apiResponse=ApiResponse();
    try {
      if(await checkInternetStatus()==false)
      {
        apiResponse.status=-1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client.put(Uri.parse(url),body:body , headers: geHeader()).timeout(timeOut);
      if(kDebugMode)
      {
        print(response.body);
      }
      if(response.statusCode==200)
      {
        apiResponse=ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      }
      else
      {
        apiResponse.status=response.statusCode;
        apiResponse.data=null;
      }
    } catch(ex) {
      apiResponse.status=-1;
      apiResponse.message=ex.toString();
      if(kDebugMode)
      {
        print(ex);
      }
    }
    return apiResponse;
  }
  static Future<ApiResponse> delete(String url,String body) async{
    ApiResponse apiResponse=ApiResponse();
    try {
      if(await checkInternetStatus()==false)
      {

        apiResponse.status=-1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client.delete(Uri.parse(url),body:body , headers: geHeader()).timeout(timeOut);
      if(kDebugMode)
      {
        print(response.body);
      }
      if(response.statusCode==200)
      {
        apiResponse=ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      }
      else
      {
        apiResponse.status=response.statusCode;
        apiResponse.data=null;
      }
    } catch(ex) {
      if(kDebugMode)
      {
        print(ex);
      }
    }
    return apiResponse;
  }

  static Future<String> downloadAndSaveFile(String url, String fileName) async {

    if(await checkInternetStatus()==false)
    {

      return '';
    }
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<ApiResponse> postFormData(String url, String filepath,Map<String,String>? param,{String method="POST"}) async{
    ApiResponse apiResponse=ApiResponse();
    try
    {

      if(await checkInternetStatus()==false)
      {

        apiResponse.status=-1;
        return apiResponse;
      }
      var request = http.MultipartRequest(method, Uri.parse(url));
      if(param!=null)
      {
        request.fields.addAll(param);
      }
     // String? contentType=lookupMimeType(filepath, headerBytes: [0xFF, 0xD8]);
      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        'image',File(filepath).readAsBytesSync(),
        filename: basename(filepath),

      //  contentType:MediaType(contentType!.substring(0,contentType.indexOf('/')),contentType.substring(contentType.lastIndexOf('/')+1)),
          contentType:  MediaType("image", "jpeg")
      );

      request.files.add(
          multipartFile
      );

      var res = await request.send();
      final response= await http.Response.fromStream(res) ;//   var responseData = await res.stream.toBytes();
      if(kDebugMode)
      {
        print(response.body);
      }
      if(response.statusCode==200)
      {

        apiResponse=ApiResponse.fromJson(json.decode(response.body));
      }
      else
      {
        apiResponse.status=response.statusCode;
        apiResponse.data=null;
      }
    }catch(ex)
    {
      apiResponse.status=-1;
      apiResponse.message=ex.toString();
      if(kDebugMode)
      {
        print(ex);
      }
    }
    return apiResponse;
  }
  static Future<void> sendPushMessage() async {
    try {
      const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
      List<String> registrationIds=List.empty(growable: true);
      registrationIds.add(PreferenceController.getString(PreferenceController.fcmToken));
      String body = jsonEncode({
        "registration_ids": registrationIds,
        /* "notification": {
          "title": 'Milan', // set sender name here,
          "body": 'Test message',
          "sound": "default",
          "content_available": true,
        },*/
        "sound": "default",
        "content_available": true,
        "priority": "high",
        "data": {
          "title": 'Test message',
          "notificationType":'CHAT',
          "notificationPayload":json.encode({'profileImage':'https://picsum.photos/200/300','message':"Hello Flutter How are you ?"})
        }
      });
      var client = http.Client();
      Map<String,String> header=<String,String>{};
      header['Authorization']="key=<your own key**********************************>";
      header['content-Type']='application/json';
      final result=await client.post(Uri.parse(fcmUrl),headers:header,body: body).timeout(timeOut);
    } catch (e) {

    }
  }

}