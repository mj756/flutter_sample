import 'dart:convert';
import 'dart:io';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/api_response.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/extra_functionality/map_model.dart';

class ApiController {
  static Future<bool> checkInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
    return false;
  }

  static Map<String, String> geHeader({String method = 'POST'}) {
    Map<String, String> header = <String, String>{};
    try {
      header['Authorization'] =
          PreferenceController.getString(PreferenceController.apiToken);
      if (method != "GET") {
        header['Content-type'] = "application/json";
      }
      header['Language'] =
          PreferenceController.getString(PreferenceController.prefKeyLanguage);
    } catch (e) {}

    return header;
  }

  static Future<ApiResponse> get(String url) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (await checkInternetStatus() == false) {
        apiResponse.status = -1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client
          .get(Uri.parse(url), headers: geHeader(method: 'GET'))
          .timeout(AppConstants.apiResponseTimeOut);
      if (response.statusCode == 200) {
        apiResponse = ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      } else {
        apiResponse.status = response.statusCode;
        apiResponse.data = null;
        apiResponse.message = "Internal server error";
      }
    } catch (ex) {
      apiResponse.status = -1;
      apiResponse.message = ex.toString();

    }
    return apiResponse;
  }

  static Future<ApiResponse> post(String url, String body,
      {bool isLoginApiCall = false}) async {

    ApiResponse apiResponse = ApiResponse();
    try {
      if (await checkInternetStatus() == false) {
        apiResponse.status = -1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client
          .post(Uri.parse(url), body: body, headers: geHeader())
          .timeout(AppConstants.apiResponseTimeOut);

      if (response.statusCode == 200) {
        apiResponse = ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      } else {
        apiResponse.status = response.statusCode;
        apiResponse.data = null;
        apiResponse.message = "Internal server error";
      }
    } catch (ex) {
      apiResponse.status = -1;
      apiResponse.message = ex.toString();

    }
    return apiResponse;
  }

  static Future<ApiResponse> put(String url, String body) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (await checkInternetStatus() == false) {
        apiResponse.status = -1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client
          .put(Uri.parse(url), body: body, headers: geHeader())
          .timeout(AppConstants.apiResponseTimeOut);
      if (response.statusCode == 200) {
        apiResponse = ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      } else {
        apiResponse.status = response.statusCode;
        apiResponse.data = null;
        apiResponse.message = "Internal server error";
      }
    } catch (ex) {
      apiResponse.status = -1;
      apiResponse.message = ex.toString();

    }
    return apiResponse;
  }

  static Future<ApiResponse> delete(String url, String body) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (await checkInternetStatus() == false) {
        apiResponse.status = -1;
        return apiResponse;
      }
      var client = http.Client();
      final response = await client
          .delete(Uri.parse(url), body: body, headers: geHeader())
          .timeout(AppConstants.apiResponseTimeOut);

      if (response.statusCode == 200) {
        apiResponse = ApiResponse.fromJson(json.decode(response.body));
        return apiResponse;
      } else {
        apiResponse.status = response.statusCode;
        apiResponse.data = null;
        apiResponse.message = "Internal server error";
      }
    } catch (ex) {

    }
    return apiResponse;
  }

  static Future<String> downloadAndSaveFile(String url, String fileName,{bool isPermanentStore=false}) async {
    if (await checkInternetStatus() == false) {
      return '';
    }
   // final Directory directory = await getApplicationDocumentsDirectory();
   // final Directory? directory = await getExternalStorageDirectory();
    final Directory? directory =isPermanentStore ? Directory('/storage/emulated/0/Download'):await getExternalStorageDirectory();
    if(directory==null){
      return '';
    }

    if (await File('${directory.path}/$fileName').exists()) {
      return '${directory.path}/$fileName';
    }

    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<ApiResponse> postFormData(
      String url, String filepath, Map<String, String>? param,
      {String method = "POST"}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (await checkInternetStatus() == false) {
        apiResponse.status = -1;
        return apiResponse;
      }
      var request = http.MultipartRequest(method, Uri.parse(url));
      if (param != null) {
        request.fields.addAll(param);
      }
      // String? contentType = lookupMimeType(filepath, headerBytes: [0xFF, 0xD8]);
      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'image', File(filepath).readAsBytesSync(),
          filename: basename(filepath),
          //  contentType:MediaType(contentType!.substring(0,contentType.indexOf('/')),contentType.substring(contentType.lastIndexOf('/')+1)),
          contentType: MediaType("image", "jpeg"));

      request.files.add(multipartFile);

      var res = await request.send();
      final response = await http.Response.fromStream(
          res); //   var responseData = await res.stream.toBytes();

      if (response.statusCode == 200) {
        apiResponse = ApiResponse.fromJson(json.decode(response.body));
      } else {
        apiResponse.status = response.statusCode;
        apiResponse.data = null;
        apiResponse.message = "Internal server error";
      }
    } catch (ex) {
      apiResponse.status = -1;
      apiResponse.message = ex.toString();

    }
    return apiResponse;
  }

  static Future<void> sendPushChatMessage(
      Map<String, dynamic> chatMessage, String otherUserFCMToken) async {
    try {
      const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
      List<String> registrationIds = List.empty(growable: true);
      registrationIds.add(otherUserFCMToken);
      String body = jsonEncode({
        "registration_ids": registrationIds,
        "sound": "default",
        "content_available": true,
        "priority": "high",
        "data": {
          "title": chatMessage['SenderName'],
          "notificationType": 'text',
          "notificationPayload": chatMessage
        }
      });

      var client = http.Client();
      Map<String, String> header = <String, String>{};
      header['Authorization'] = "key=your_key";
      header['content-Type'] = 'application/json';
      await client
          .post(Uri.parse(fcmUrl), headers: header, body: body)
          .timeout(AppConstants.apiResponseTimeOut);
    } catch (e) {}
  }

  static Future<MapResponseResult?> getNearByPlaces(String url) async {
    try {
      if (await checkInternetStatus() == false) {}
      var client = http.Client();
      final response = await client
          .get(Uri.parse(url))
          .timeout(AppConstants.apiResponseTimeOut);
      if (response.statusCode == 200) {
        MapResponseResult result =
            MapResponseResult.fromJson(json.decode(response.body));
        return result;
      }
    } catch (ex) {}
    return null;
  }
}
