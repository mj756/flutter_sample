import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/home_controller.dart';
import 'package:flutter_sample/widget/drawer.dart';
import 'package:provider/provider.dart';

import '../widget/app_exit_dialog.dart';

class HomePage extends StatelessWidget {
  static const platform = MethodChannel('samples.flutter.dev/permission');

  const HomePage({Key? key}) : super(key: key);

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
                      await Navigator.pushNamed(context, '/map',
                          arguments: {'title': 'Google map'});
                    },
                    leading: const Icon(Icons.map),
                    title: const Text('Google Map'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/chatting',
                          arguments: {'title': 'User list'});
                    },
                    leading: const Icon(Icons.chat),
                    title: const Text('Chatting'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/database',
                          arguments: {'title': 'Local Database'});
                    },
                    leading: const Icon(Icons.data_object),
                    title: const Text('Local Database'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/video',
                          arguments: {'title': 'Video player'});
                    },
                    leading: const Icon(Icons.video_camera_back_rounded),
                    title: const Text('Video player'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/advertisement',
                          arguments: {'title': 'Google ads'});
                    },
                    leading: const Icon(Icons.video_camera_back_rounded),
                    title: const Text('Google ads'),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/audio',
                          arguments: {'title': 'Audio player'});
                    },
                    leading: const Icon(Icons.library_music_sharp),
                    title: const Text('Audio player'),
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
