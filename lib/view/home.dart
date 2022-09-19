import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/home_controller.dart';
import 'package:flutter_sample/view/extra_functionality/chat_user_list.dart';
import 'package:flutter_sample/widget/drawer.dart';
import 'package:provider/provider.dart';
import '../widget/app_exit_dialog.dart';
import 'extra_functionality/database_operation.dart';
import 'extra_functionality/map.dart';

class HomePage extends StatelessWidget {
  static const platform = MethodChannel('samples.flutter.dev/permission');

  HomePage({Key? key}) : super(key: key);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeController(),
        lazy: false,
        builder: (context, child) {
          return WillPopScope(
            onWillPop: () async {
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
                title: Text(AppLocalizations.of(context)!.home),
              ),
              drawer: const SideBar(),
              body: ListView(

                children: [
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/map',arguments: {'title':'Google map'});
                    },
                    leading: Icon(Icons.map),
                    title: Text('Google Map'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/chatting',arguments: {'title':'User list'});
                    },
                    leading:  Icon(Icons.chat),
                    title: Text('Chatting'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/database',arguments: {'title':'Local Database'});
                    },
                    leading:  Icon(Icons.data_object),
                    title: Text('Local Database'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/video',arguments: {'title':'Video player'});
                    },
                    leading:  Icon(Icons.video_camera_back_rounded),
                    title: Text('Video player'),
                  )
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: context.watch<HomeController>().currentPage,
               /* onTap: (index) {
                  Provider.of<HomeController>(context, listen: false)
                      .changePageIndex(index);
                  _pageController.jumpToPage(index);
                },*/
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: AppLocalizations.of(context)!.home),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.map),
                      label: AppLocalizations.of(context)!.home),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.chat),
                      label: AppLocalizations.of(context)!.home),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.data_saver_on), label: 'database'),
                ],
              ),
            ),
          );
        });
  }
}
