import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'AdMobService.dart';
import 'AnimationPage.dart';
import 'ApiCenter.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  // Kelimeleri içerecek bir liste tanımlandı.
  List<Map<String, dynamic>> keywords = [];

  final AnimationScreen animationScreen = AnimationScreen();
  bool animationScreenVisible = true; // Sayfa başlatıldığında animasyon ekranının açık gelmesi için true ayarlandı.

  @override
  void initState() {
    super.initState();
    loadKeywords(); //Sayfa başlatıldığında kelime listesini yüklemesi için fonksiyon çağırıldı.
  }

  // Kelime listesini yüklemek için bir asenkron fonksiyon tanımlandı
  Future<void> loadKeywords() async {
    final wordFlagProvider = Provider.of<WordFlagProvider>(context, listen: false);
    // newWordFlag değişkeni yeni kelime eklendiği durumda keyword.txt dosyasını güncellemek için kullanılır. 
    if (wordFlagProvider.newWordFlag == true) {
      dynamic response = await ApiCenter.keywordListService();
      wordFlagProvider.setNewWordFlag(false);
      return loadKeywords();
    }
    
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/keyword.txt';

    bool fileExists = await File(filePath).exists();

     if (fileExists) {
      File file = File('${appDocDir.path}/keyword.txt');

      if (await file.exists()) {
        String data = await file.readAsString();
        List<dynamic> jsonData = json.decode(data);

        List<Map<String, dynamic>> trEnPairs = [];
        for (var item in jsonData) {
          trEnPairs.add({
            'tr': item['tr'],
            'en': item['en'],
          });
        }

        setState(() {
          keywords = trEnPairs;
        });
      }
      // Kelime listesinin verilerini kaydetme işlemi bittiğinde animasyonu kapatmak için kullanılır.
      setState(() {
        animationScreenVisible = false;
      });
    } else {
      // Dosya yoksa, API call edilir.
      dynamic response = await ApiCenter.keywordListService();
      return loadKeywords();
    }
  }

  @override
  Widget build(BuildContext context) {
    //AdMobService.dart dosyasından reklam görüntüsünü eklemek için kullanılır.
    AdMobService adMobService = AdMobService(); // AdMobService sınıfının örneğini oluşturuldu
    adMobService.initialize();  // Reklam servisini başlatıldı
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF00004D),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Text(
                    "LUNGONLY",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: "CsGordon",
                      color: Color(0xFFFFFAEF),
                      shadows: [
                        Shadow(
                          color: Color(0xFFFFC1B2),
                          offset: Offset(2, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Word List",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gotham",
                    fontSize: 30,
                  ),
                ),
                // Kelime listesini ekranda göstermek için ListView kullanılır.
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: keywords.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: SvgPicture.asset(
                              "assets/images/star.svg",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          Text(
                            '${keywords[index]['tr']}',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            '${keywords[index]['en']}',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: SvgPicture.asset(
                              "assets/images/star2.svg",
                              width: 20,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 150),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: adMobService.showBannerAd(),
          ),
        ),
        // Animasyon ekranını kontrol etmek için bir değişken kullanılır.
        animationScreenVisible
          ? GestureDetector(
              onTap: () {
                // Ekran dışına tıklanıldığı durumda animasyonu kapatmak için kullanılır.
                setState(() {
                  animationScreenVisible = false;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: animationScreen, // Animasyonlu ekranı göstermek için kullanılır.
                ),
              ),
            )
          : Container(),
        ],
     ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: WordListPage(),
    ));
