import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Utility
{
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