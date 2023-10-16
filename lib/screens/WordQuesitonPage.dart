import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'AdMobService.dart';
import 'ApiCenter.dart';

class WordQuestionPage extends StatefulWidget {
  const WordQuestionPage({Key? key});

  @override
  State<WordQuestionPage> createState() => _WordQuestionPageState();
}

class _WordQuestionPageState extends State<WordQuestionPage> {
  // Kelimeleri içerecek bir liste tanımlandı.
  List<Map<String, dynamic>> keywordData = [];
  String selectedWord = "";
  String currentQuestion = "";
  String selectedWordText = "";
  int trueCount = 0;
  int falseCount = 0;
  int questionIndex = 0;
  int answerAverage = 0;

  // Soru seçeneklerini ve düğme renklerini saklamak için listeler tanımlandı.
  List<String> options = [];
  List<Color> buttonColors = [
    Color(0xFF282559),
    Color(0xFF282559),
    Color(0xFF282559),
    Color(0xFF282559),
  ];

  @override
  void initState() {
    super.initState();
    loadKeywordData(); // Sayfa başlatıldığında kelime verilerini yüklemesi için fonksiyon çağırıldı.
  }

  // Kelime verilerini yüklemek için asenkron bir fonksiyon tanımlandı.
  Future<void> loadKeywordData() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/keyword.txt';

    bool fileExists = await File(filePath).exists();

    if (fileExists) {
      File file = File('${appDocDir.path}/keyword.txt');
      String fileContent = await file.readAsString();

      List<dynamic> jsonData = json.decode(fileContent);
      keywordData = jsonData.cast<Map<String, dynamic>>();
      setState(() {
        generateQuestion(); // Soru oluşturulduktan sonra sayfa güncellemek için kullanılır.
      });
    } else {
      // dosya bulunamadıysa dosya oluşması için servisi call et ve ve fonksiyonu tekrar çağır
      dynamic response = await ApiCenter.keywordListService();
      return loadKeywordData();
    }
  }

  // Soru oluşturmak için bir fonksiyon oluşturuldu.
  void generateQuestion() {
    if (keywordData.isNotEmpty && questionIndex < keywordData.length) {
      var keyword = keywordData[questionIndex];
      var selectedWordId = keyword['id'];
      selectedWord = keyword['tr'];
      options.clear();
      List<Map<String, dynamic>> optionData = [
        {
          'id': selectedWordId.toString(),
          'text': keyword['en'],
        }
      ];

      for (var i = 0; i < 3; i++) {
        var randomIndex;
        do {
          randomIndex = questionIndex +
              Random().nextInt(keywordData.length - questionIndex);
        } while (optionData.any((option) =>
            option['id'] == keywordData[randomIndex]['id'].toString()));
        optionData.add({
          'id': keywordData[randomIndex]['id'].toString(),
          'text': keywordData[randomIndex]['en'],
        });
      }

      if (optionData.map((option) => option['id']).toSet().length != 4) {
        questionIndex++;
        generateQuestion(); // Aynı şık gelmemesi için kontrol koyuldu geçerli koşul geçersizse başka bir soru oluştur.
      } else {
        options =
            optionData.map((option) => option['text'].toString()).toList();
        currentQuestion = keyword['tr'];
        selectedWordText = keyword['en'];

        options.shuffle(); //butonların sıralı gelmemesi için seçenekler karıştırıldı.
      }
    }
  }

  // Cevabı kontrol etmek için bir fonksiyon oluşturuldu.
  void checkAnswer(String selectedOptionText, int optionIndex) {
    if (selectedOptionText == selectedWordText) {
      trueCount++;
      answerAverage = (trueCount * 100) ~/ (trueCount + falseCount);
      options.clear();
      generateQuestion();
      initializeButtonColors(); // Doğru cevap verildiyse düğme renklerini sıfırla
    } else {
      falseCount++;
      buttonColors[optionIndex] = Colors.red; // Yanlış cevap verildiyse düğme rengini kırmızı yap.
    }
    questionIndex++;
    setState(() {}); // Sayfayı güncelle
  }

  void initializeButtonColors() {
    buttonColors = [
      Color(0xFF282559),
      Color(0xFF282559),
      Color(0xFF282559),
      Color(0xFF282559),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AdMobService adMobService =
        AdMobService(); // AdMobService sınıfının örneğini oluşturuyoruz
    adMobService.initialize(); // Reklam servisini başlatıyoruz
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF00004D),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, 100),
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
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "True: $trueCount",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontFamily: "Gotham",
                        ),
                      ),
                      SizedBox(
                        width: 17,
                      ),
                      Text(
                        "False: $falseCount",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontFamily: "Gotham",
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Statics: $answerAverage",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontFamily: "Gotham",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    "Word Question",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Gotham",
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (options.isNotEmpty)
                  Flexible(
                    flex: 3,
                    child: Text(
                      currentQuestion,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Gotham",
                      ),
                    ),
                  ),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (options.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () => checkAnswer(options[0], 0),
                            child: Container(
                              width: 130,
                              height: 70,
                              decoration: BoxDecoration(
                                color: buttonColors[0],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  options[0],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Gotham",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 20,
                      ),
                      if (options.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () => checkAnswer(options[1], 1),
                            child: Container(
                              width: 130,
                              height: 70,
                              decoration: BoxDecoration(
                                color: buttonColors[1],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  options[1],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Gotham",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (options.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () => checkAnswer(options[2], 2),
                            child: Container(
                              width: 130,
                              height: 70,
                              decoration: BoxDecoration(
                                color: buttonColors[2],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  options[2],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Gotham",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 20,
                      ),
                      if (options.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () => checkAnswer(options[3], 3),
                            child: Container(
                              width: 130,
                              height: 70,
                              decoration: BoxDecoration(
                                color: buttonColors[3],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  options[3],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "Gotham",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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
        ],
      ),
    );
  }
}
