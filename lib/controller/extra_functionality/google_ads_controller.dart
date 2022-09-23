import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertisementController extends ChangeNotifier {
  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  bool isBannerReady = false;
  bool isInterstitialReady = false;
  late RewardedAd rewardAd;
  late RewardedInterstitialAd rewardedInterstitialAd;

  // late AdWidget adWidget;
  // late AdWidget nativeAdWidget;

  AdvertisementController() {}

  @override
  void dispose() {
    bannerAd.dispose();
    interstitialAd.dispose();
    rewardAd.dispose();
    rewardedInterstitialAd.dispose();

    super.dispose();
  }

  Future<void> loadBannerAd() async {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
      ),
    );
    bannerAd.load();
    // adWidget = AdWidget(ad: bannerAd);
    isBannerReady = true;
    notifyListeners();
  }

  Future<void> loadInterstitialAd() async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              interstitialAd = ad;
              interstitialAd.fullScreenContentCallback =
                  FullScreenContentCallback(
                onAdShowedFullScreenContent: (InterstitialAd ad) {},
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                },
                onAdFailedToShowFullScreenContent:
                    (InterstitialAd ad, AdError error) {
                  ad.dispose();
                },
              );
              interstitialAd.show();
            },
            onAdFailedToLoad: (error) {}));
  }

  Future<void> loadRewardedAd() async {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardAd = ad;
            rewardAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) {},
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (RewardedAd ad, AdError error) {
                ad.dispose();
              },
            );
            rewardAd.setImmersiveMode(true);
            rewardAd.show(
                onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              print(
                  '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (error) {}),
    );
  }

  Future<void> loadRewardedInterstitialAd() async {
    RewardedInterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5354046379',
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedInterstitialAd = ad;
            rewardedInterstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {},
              onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (RewardedInterstitialAd ad, AdError error) {
                ad.dispose();
              },
            );
            rewardedInterstitialAd.setImmersiveMode(true);
            rewardedInterstitialAd.show(
                onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              print(
                  '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (error) {}),
    );
  }

  AdWidget getBannerAd() {
    return AdWidget(ad: bannerAd);
  }
}
