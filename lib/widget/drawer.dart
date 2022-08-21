import 'package:flutter/material.dart';
import 'package:flutter_sample/view/setting.dart';

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
                backgroundImage: Image.network('').image,
              )),
          ListTile(
           onTap: ()async{
             await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Setting()));
           },
            leading: const Icon(Icons.settings),
            title: const Text('Setting'),
          )
        ],
      ),
    ));
  }
}
