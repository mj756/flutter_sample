import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/extra_functionality/google_ads_controller.dart';
import 'package:provider/provider.dart';

class BannerAdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AdvertisementController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                  child: Column(
                children: [
                  context.watch<AdvertisementController>().isBannerReady == true
                      ? Container(
                          height: context
                              .watch<AdvertisementController>()
                              .bannerAd
                              .size
                              .height
                              .toDouble(),
                          width: context
                              .watch<AdvertisementController>()
                              .bannerAd
                              .size
                              .width
                              .toDouble(),
                          child: context
                              .read<AdvertisementController>()
                              .getBannerAd(),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Wrap(children: [
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<AdvertisementController>(context,
                                      listen: false)
                                  .loadBannerAd();
                            },
                            child: Text('Banner')),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<AdvertisementController>(context,
                                      listen: false)
                                  .loadInterstitialAd();
                            },
                            child: Text('Interstitial')),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<AdvertisementController>(context,
                                      listen: false)
                                  .loadRewardedAd();
                            },
                            child: Text('Reward')),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<AdvertisementController>(context,
                                      listen: false)
                                  .loadRewardedInterstitialAd();
                            },
                            child: Text('RewardedInterstitial'))
                      ]),
                    ),
                  )
                ],
              )));
        });
  }
}
