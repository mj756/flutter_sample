import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/app_setting_controller.dart';
import 'package:flutter_sample/utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.themeColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.themeColor,
        title: Text(
          AppLocalizations.of(context)!
              .label_select_language,style: CustomStyles.customTextStyle(defaultColor: CustomColors.whiteColor,isBold: true,isExtraLargeFont: true),
          textAlign: TextAlign.center,),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: CustomColors.themeColor,
                image: DecorationImage(
                    image: Image.asset(
                  'assets/ic_launcher.png',
                  height: double.infinity,
                ).image),
              ),
            )),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                color: CustomColors.whiteColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              child: Stack(
                children: [
                  ListView.builder(
                      itemCount: AppLocalizations.supportedLocales.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Radio(
                            value: AppLocalizations
                                .supportedLocales[index].languageCode,
                            groupValue:
                            context.watch<AppSettingController>().appLanguage,
                            onChanged: (String? value) {
                              context.read<AppSettingController>().changeLanguage(
                                  AppLocalizations
                                      .supportedLocales[index].languageCode);
                            },
                            activeColor: CustomColors.themeColor,
                          ),
                          title: Text(AppLocalizations
                              .supportedLocales[index].languageCode),
                          trailing: Image.network(
                            'https://countryflagsapi.com/png/${AppLocalizations.supportedLocales[index].languageCode == 'en' ? 'us' : AppLocalizations.supportedLocales[index].languageCode}',
                            height: 30,
                            width: 30,
                          ),
                        );
                      }),
                   Positioned(
                      right: 20,
                      bottom: 10,
                      child: CircleAvatar(
                    radius: 20,
                    backgroundColor: CustomColors.themeColor,
                    child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },

                        child: const Icon(Icons.check)),
                  ))
                ],

              ),
            ))
          ],
        ),
      ),
    );
  }
}
