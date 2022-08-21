import 'package:flutter/material.dart';
import 'package:flutter_sample/view/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text('user1'),
              accountEmail: const Text('User1@test.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: Image.network('https://picsum.photos/200/300').image,
              )),
          ListTile(

            onTap: ()async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Setting()));
            },
            leading: const Icon(Icons.home,),
            title: Text(AppLocalizations.of(context)!.home),
          ),
          ListTile(
           onTap: ()async{
             await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Setting()));
           },
            leading: const Icon(Icons.settings),
            title:  Text(AppLocalizations.of(context)!.setting),
          ),
          ListTile(
            onTap: ()async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Setting()));
            },
            leading: const Icon(Icons.logout),
            title:  Text(AppLocalizations.of(context)!.logout),
          )
        ],
      ),
    ));
  }
}
