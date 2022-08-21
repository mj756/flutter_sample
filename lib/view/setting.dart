import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget
{
  const Setting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Provider.of<AppSetting>(context,listen: false).changeLanguage('es');
          },
          child: const Text('Change Language'),
        ),
      ),
    );
  }

}