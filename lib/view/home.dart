import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/widget/drawer.dart';
class HomePage extends StatelessWidget
{
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Home'),
     ),
     drawer: const SideBar(),
     body: Center(child: Text(AppLocalizations.of(context)!.helloWorld)),
   );
  }

}