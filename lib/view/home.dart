import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/widget/drawer.dart';
class HomePage extends StatelessWidget
{
  static const platform = MethodChannel('samples.flutter.dev/permission');
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Home'),
     ),
     drawer: const SideBar(),
     body: Column(
         children:[
           Center(child: Text(AppLocalizations.of(context)!.home)),
          ElevatedButton(onPressed: ()async{

           final result= await platform.invokeMethod<int>('permission');
           print(result);

          }, child: const Text('Check permission'))
    ]
    ),
   );
  }

}