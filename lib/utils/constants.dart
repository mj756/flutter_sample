import 'package:flutter/material.dart';

const themeColor = Colors.blue;
const whiteColor = Colors.white;
const screenBackgroundColor = Colors.blue;
const blackColor = Colors.black;

const Duration apiResponseTimeOut = Duration(seconds: 30);
const String baseAddress = 'http://192.168.21.9:8000/api';
const String endpointLogin = "${baseAddress}/user/login";
const String endpointRegistration = "${baseAddress}/user/register";
const String endpointForGotPassword = "${baseAddress}/user/forgotpassword";
const String endpointChangePassword = "${baseAddress}/user/changepassword";
const String endpointTopUsers = "${baseAddress}/user/profile";
const String endpointLogout = "${baseAddress}logout";

const String messageTypeText = "text";
const String messageTypeImage = "image";
const String messageTypeAudio = "audio";
const String messageTypeFile = "file";
const String googleMapKey = 'your key';
const String serverDateFormat = "yyyy-MM-dd";

const SizedBox spaceHeight5 = SizedBox(height: 5);
const SizedBox spaceHeight10 = SizedBox(height: 10);
const SizedBox spaceHeight20 = SizedBox(height: 20);
const SizedBox spaceHeight30 = SizedBox(height: 30);
const SizedBox spaceHeight50 = SizedBox(height: 50);

const SizedBox spaceWidth5 = SizedBox(width: 5);
const SizedBox spaceWidth10 = SizedBox(width: 10);
const SizedBox spaceWidth20 = SizedBox(width: 20);
const SizedBox spaceWidth30 = SizedBox(width: 30);
const SizedBox spaceWidth50 = SizedBox(width: 50);

const int extraSmallFont = 10;
const int smallFont = 12;
const int normalFont = 14;
const int largeFont = 16;
const int extraLargeFont = 18;
