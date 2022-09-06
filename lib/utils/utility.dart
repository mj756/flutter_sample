import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
class Utility
{

  static const String MESSAGE_TYPE_TEXT = "text";
  static const String MESSAGE_TYPE_IMAGE = "image";
  static const String MESSAGE_TYPE_AUDIO = "audio";
  static const String MESSAGE_TYPE_FILE = "file";
  static const String googleMapKey='add your own key here';
  static const String serverDateFormat = "yyyy-MM-dd";
  static String getRandomString({int length = 10}) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length - 1))));
  }
  static DateTime dateFromJson(String? strDate) {
    if (strDate != null && strDate.isNotEmpty) {
      return DateFormat(serverDateFormat).parse(strDate, true).toLocal();
    } else {
      return DateFormat(serverDateFormat)
          .parse(DateTime.now().toUtc().toString(), true)
          .toLocal();
    }
  }

  static String dateToJson(DateTime time) {
    return time.toUtc().toIso8601String();
  }

  static void printLog(String message) {
    if (kDebugMode) {
      print(message);
    }
  }



  static String utf8Encode(String? text) {
    if (text != null) return utf8.encode(text).join(",");
    return '';
  }

  static String utf8Decode(String? text) {
    if (text != null) {
      try {
        if(double.tryParse(text)!=null)
        {
          return text;
        }

        List<int> bytes = text.split(",").map(int.parse).toList();
        return utf8.decode(bytes);
      } catch (ex, stackTrace) {
        try {
          List<int> bytes = text.codeUnits;
          return utf8.decode(bytes);
        } catch (ex, stackTrace) {
          return text;
        }
      }
    } else {
      return '';
    }
  }
  static bool boolFromJson(Object? value) {
    if (value != null) {
      if (value is bool) {
        return value;
      } else if (value is int) {
        return value == 0 ? false : true;
      }
    }
    return false;
  }
  static DateTime parseToLocal(DateTime utcDate) {
    return DateTime.utc(
      utcDate.year,
      utcDate.month,
      utcDate.day,
      utcDate.hour,
      utcDate.minute,
      utcDate.second,
      utcDate.millisecond,
      utcDate.microsecond,
    ).toLocal();
  }
  static int boolToJson(bool value) => value ? 1 : 0;

  static bool? nullableBoolFromJson(Object? value) {
    if (value != null) {
      if (value is bool) {
        return value;
      } else if (value is int) {
        return value == 0 ? false : true;
      } else if (value is String) {
        return value.toLowerCase() == "true" ? true : false;
      }
    }
    return null;
  }

  static int? nullableBoolToJson(bool? value) =>
      value != null ? (value ? 1 : 0) : null;

  static int getEpochTime(DateTime date) {
    return (date.millisecondsSinceEpoch/1000).floor();
  }

  static DateTime getEpochToDate(int ephochTime, {bool isUtcTime= false}) {
    return DateTime.fromMillisecondsSinceEpoch(ephochTime * 1000,
        isUtc: isUtcTime);
  }


  static String getDurationBetweenTwoDates(
      BuildContext context, DateTime from) {
    String duration = '';
    DateTime dateCreated = from.toLocal();
    DateTime today = DateTime.now();
    Duration diff = today.difference(dateCreated);

    if (diff.inMinutes < 60) {
      duration =
      "${diff.inMinutes} ${AppLocalizations.of(context)!.label_minute_ago}";
    } else if (diff.inHours >= 1 && diff.inHours <= 23) {
      duration =
      "${diff.inHours} ${AppLocalizations.of(context)!.label_hours_ago}";
    } else if (diff.inDays >= 1 && diff.inDays < 30) {
      duration =
      "${diff.inDays} ${AppLocalizations.of(context)!.label_days_ago}";
    } else if (diff.inDays >= 30 && diff.inDays < 365) {
      duration =
      "${(diff.inDays / 30).floor()} ${AppLocalizations.of(context)!.label_month_ago}";
    } else {
      int year = (diff.inDays / 365).floor();
      duration =
      "$year ${AppLocalizations.of(context)!.label_year_ago}";
    }
    return duration;
  }
  static bool isValidEmail(email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    Pattern pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(phoneNumber);
  }

  static bool isValidURL(String url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isSuccess = false}) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isSuccess ? Colors.white : Colors.red),
        ),
      ));
    } catch (ex) {}
  }

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

}