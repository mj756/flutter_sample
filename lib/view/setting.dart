import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
        .setting
        ),
      ),
      body: ListView(
        children: [
           ListTile(
             onTap: ()async {
               await Navigator.pushNamed(context,'/language');
             },
            leading: const Icon(Icons.language),
            title: Text( AppLocalizations.of(context)!
                .label_select_language),
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
