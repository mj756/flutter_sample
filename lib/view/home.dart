import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/home_controller.dart';
import 'package:flutter_sample/widget/drawer.dart';
import 'package:provider/provider.dart';

import '../widget/app_exit_dialog.dart';
class HomePage extends StatelessWidget
{
  static const platform = MethodChannel('samples.flutter.dev/permission');
   HomePage({Key? key}) : super(key: key);
  final PageController _pageController=PageController();
  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(
     create: (context)=>HomeController(),lazy: false,
     builder: (context,child){
       return WillPopScope(
         onWillPop: () async{
           final shouldPop = await showDialog<bool>(
             context: context,
             barrierDismissible: false,
             builder: (context) {
               return const AppExitDialog();
             },
           );
           return shouldPop!;
         },
         child: Scaffold(
           appBar: AppBar(
             title:  Text(AppLocalizations.of(context)!.home),
           ),
           drawer: const SideBar(),
           body: PageView.builder(
               controller: _pageController,
               physics:const NeverScrollableScrollPhysics(),
               itemCount: 4,
               itemBuilder: (context,index){
                 return Container(
                   height: 200,
                   color: Colors.red,
                   child: Text('Page${index+1}'),
                 );
               }),

           bottomNavigationBar: BottomNavigationBar(
             type:BottomNavigationBarType.fixed,
             currentIndex: context.watch<HomeController>().currentPage,
             onTap: (index){
                Provider.of<HomeController>(context,listen: false).changePageIndex(index);
               _pageController.jumpToPage(index);
             },
             items: [
               BottomNavigationBarItem(icon:const Icon(Icons.home),label: AppLocalizations.of(context)!.home),
               BottomNavigationBarItem(icon:const Icon(Icons.home),label: AppLocalizations.of(context)!.home),
               BottomNavigationBarItem(icon:const Icon(Icons.home),label: AppLocalizations.of(context)!.home),
               BottomNavigationBarItem(icon:const Icon(Icons.home),label: AppLocalizations.of(context)!.home),
             ],
           ),
         ),
       );
     }

   );
  }

}