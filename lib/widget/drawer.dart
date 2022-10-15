import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/api_controller.dart';
import 'package:flutter_sample/controller/firebase_controller.dart';
import 'package:flutter_sample/controller/preference_controller.dart';
import 'package:flutter_sample/model/user.dart';
import 'package:flutter_sample/utils/constants.dart';
import 'package:flutter_sample/view/login.dart';
import 'package:flutter_sample/view/setting.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser currentUser = AppUser.fromJson(json.decode(
        PreferenceController.getString(
            PreferenceController.prefKeyUserPayload)));
    return SafeArea(
        child: Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(currentUser.name),
              accountEmail: Text(currentUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: Image.network(currentUser.profileImage).image,
              )),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Setting()));
            },
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.setting),
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).pushNamed('/profile');
            },
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.label_profile),
          ),
          ListTile(
            onTap: () async {
              if (PreferenceController.getString(
                      PreferenceController.prefKeyLoginType) ==
                  PreferenceController.loginTypeNormal) {
                print(AppConstants.endpointLogout);
                await ApiController.post(
                    AppConstants.endpointLogout,
                    json.encode({
                      'id': PreferenceController.getString(
                          PreferenceController.prefKeyUserId),
                      'fcmToken': PreferenceController.getString(
                          PreferenceController.fcmToken)
                    })).then((response) {
                  print(response.message);
                  if (response.status != 0) {
                    PreferenceController.clearLoginCredential();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                });
              } else {
                await FirebaseController().logOut().then((value) {
                  if (value == true) {
                    PreferenceController.clearLoginCredential();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                });
              }
            },
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
          )
        ],
      ),
    ));
  }
}
