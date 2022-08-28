import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          TextButton(onPressed: (){
          //  Provider.of<AppSetting>(context,listen: false).changeLanguage(value!);
          }, child: const Text('Save',style: TextStyle(color: Colors.white),))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
              title: DropdownButton(
                value: context.watch<AppSettingController>().appLanguage,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: AppLocalizations.supportedLocales.map((Locale value) {
                  return DropdownMenuItem(
                      alignment: Alignment.centerLeft,
                      value: value.languageCode,
                      child: SizedBox(
                        width: 50,
                        child:   Image.network(
                          'https://countryflagsapi.com/png/${value.languageCode=='en' ? 'us':value.languageCode}',
                          fit: BoxFit.fill,),
                      ));
                }).toList(),
                onChanged: (String? value) {
                  Provider.of<AppSettingController>(context,listen: false).changeLanguage(value!);
                },
              ),
          ),
          const ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change password'),
          )
        ],
      )
    );
  }
}
