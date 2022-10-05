import 'package:flutter/material.dart';

class AppConstants{

static const themeColor = Colors.blue;
static const whiteColor = Colors.white;
static const screenBackgroundColor = Colors.blue;
static const blackColor = Colors.black;

static const Duration apiResponseTimeOut = Duration(seconds: 30);

static  String baseAddress = 'http://192.168.56.29:8000/api/';
static  String endpointLogin = "${baseAddress}user/login";
static  String endpointRegistration = "${baseAddress}user/register";
static  String endpointGetAllUser = "${baseAddress}user/getalluser";
static  String endpointForGotPassword = "${baseAddress}user/forgotpassword";
static  String endpointChangePassword = "${baseAddress}user/changepassword";
static  String endpointTopUsers = "${baseAddress}user/profile";
static  String endpointLogout = "${baseAddress}logout";

static  String endpointSendMessage = "${baseAddress}message";
static  String endpointGetMessage = "${baseAddress}message/getMessages";

static const String messageTypeText = "text";
static const String messageTypeImage = "image";
static const String messageTypeAudio = "audio";
static const String messageTypeFile = "file";
static const String googleMapKey = 'your key';
static const String serverDateFormat = "yyyy-MM-dd";

static const SizedBox spaceHeight5 = SizedBox(height: 5);
static const SizedBox spaceHeight10 = SizedBox(height: 10);
static const SizedBox spaceHeight20 = SizedBox(height: 20);
static const SizedBox spaceHeight30 = SizedBox(height: 30);
static const SizedBox spaceHeight50 = SizedBox(height: 50);

static const SizedBox spaceWidth5 = SizedBox(width: 5);
static const SizedBox spaceWidth10 = SizedBox(width: 10);
static const SizedBox spaceWidth20 = SizedBox(width: 20);
static const SizedBox spaceWidth30 = SizedBox(width: 30);
static const SizedBox spaceWidth50 = SizedBox(width: 50);

static const int extraSmallFont = 10;
static const int smallFont = 12;
static const int normalFont = 14;
static const int largeFont = 16;
static const int extraLargeFont = 18;
}


