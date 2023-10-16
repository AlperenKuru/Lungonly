import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _singleton = AdMobService._internal();

  factory AdMobService() {
    return _singleton;
  }

  AdMobService._internal();

  BannerAd? bannerAd;

  // Banner reklamı oluşturan fonksiyon
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-YOUR/KEY',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // Reklam başarıyla yüklendiğinde yapılacak işlemler
          print('Banner reklam yüklendi.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Reklam yüklenemediğinde yapılacak işlemler
          print('Banner reklam yüklenemedi: $error');
        },
      ),
    );
  }

  void initialize() {
    bannerAd = createBannerAd(); // Başlangıçta bir reklam nesnesi oluştur
    bannerAd!.load(); // Banner reklamı yükle
  }

  Widget showBannerAd() {
    return bannerAd != null
        ? AdWidget(ad: bannerAd!)
        : SizedBox(); // Reklam yüklenmediyse bir boşluk döndür
  }

  void closeBannerAd() {
    if (bannerAd != null) {
      bannerAd!.dispose();
      bannerAd = null;
    }
  }
}
