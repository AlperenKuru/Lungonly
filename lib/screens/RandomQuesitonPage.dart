import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import 'AdMobService.dart';
import 'AnimationPage.dart';
import 'ApiCenter.dart';

void main() => runApp(RandomQuestionPage());

class RandomQuestionPage extends StatefulWidget {
  @override
  _RandomQuestionPageState createState() => _RandomQuestionPageState();
}

class WordData {
  String word;
  int wordKey;
  Color backgroundColor;
  bool clickable; // Boolean bir değer kullanarak clickable özelliğini ekleyin

  WordData(this.word, this.wordKey,
      {required this.backgroundColor, this.clickable = true});

  // JSON dönüşümü için toJson yöntemi
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'wordKey': wordKey,
      'backgroundColor': backgroundColor?.value,
      'clickable': clickable, // JSON'da clickable değerini saklayın
    };
  }
}

class _RandomQuestionPageState extends State<RandomQuestionPage> {
 
  final AnimationScreen animationScreen = AnimationScreen();
  bool animationScreenVisible = true;

  bool firstChoise = true;

  //seçili word keyi tutmak için
  int choiseWordKey = 0;

  //seçili buton bilgisini tutmak için.
  int choiseWordIndex = 0;

  bool blockNative = false;
  bool blockPractice = false;

  int selectNativeLanguage = 0;
  int selectPracticeLanguage = 0;
  int selectCategoryLanguage = 0;

  List<Map<String, dynamic>> nativeWordList = [];
  List<Map<String, dynamic>> practiceWordList = [];

  List<WordData> ntChoiseBtns = [
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA), clickable: true), // İlk NTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // İkinci NTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // Üçüncü NTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // Dördüncü NTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // Beşinci NTChoiseBTN
  ];
  List<WordData> ptChoiseBtns = [
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA), clickable: true), // İlk PTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // İkinci PTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // Üçüncü PTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // Dördüncü PTChoiseBTN
    WordData("Veri bulanamadı", 0,
        backgroundColor: Color(0xFF4495FA),
        clickable: true), // Beşinci PTChoiseBTN
  ];

  void _handleRandomWordButtonPressed(BuildContext context) async {
    animationScreenVisible = true;
    setState(() {});
    // API isteği için RandomQuestion metodunu çağır
    dynamic response = await ApiCenter.RandomQuestionService(
        selectNativeLanguage, selectCategoryLanguage, selectPracticeLanguage);

    if (response.success == true) {
      setState(() {
        nativeWordList.clear();
        practiceWordList.clear();
        nativeWordList = response.nativeWordList;
        practiceWordList = response.practiceWordList;

        print(nativeWordList);
        print(practiceWordList);

        // nativeWordList için WordData nesneleri oluşturun
        ntChoiseBtns = nativeWordList
            .map((wordItem) => WordData(wordItem['word'], wordItem['wordKey'],
                backgroundColor: Color(0xFF4495FA), clickable: true))
            .toList();

        // practiceWordList için WordData nesneleri oluşturun
        ptChoiseBtns = practiceWordList
            .map((wordItem) => WordData(wordItem['word'], wordItem['wordKey'],
                backgroundColor: Color(0xFF4495FA), clickable: true))
            .toList();

        _onOptionSelected('RandomQuestionPage');
      });
      // Başarılı cevap alındı, işlemleri burada yapabilirsiniz.
      // Animasyonlu ekranı göstermek için bir değişkeni true olarak ayarlayın
      animationScreenVisible = false;
      showSnackBar(context, "İşlem  başarılı.");
    } else {
      // API isteğinde hata oluştu veya giriş başarısız oldu,
      showSnackBar(context, "işlem başarısız.");
    }
  }

//firstChoise == true && languageValue == 'nt' içerisinde index değerini bir değişkende tut
//Eğer cevap doğruysa o değişken ile diğer cevabında rengini değiştir. değişkeni sıfırla.
  void _checkAnswer(String languageValue, int buttonIndex, int wordKey) {
    if (firstChoise == true && languageValue == 'nt') {
      setState(() {
        ntChoiseBtns[buttonIndex].backgroundColor = Colors.yellow.shade300;
        ntChoiseBtns[buttonIndex].clickable = false;
        choiseWordKey = wordKey;
        choiseWordIndex = buttonIndex;
        firstChoise = false;
        blockNative = true;
      });
    } else if (firstChoise == true && languageValue == 'pt') {
      setState(() {
        ptChoiseBtns[buttonIndex].backgroundColor = Colors.yellow.shade300;
        ptChoiseBtns[buttonIndex].clickable = false;
        choiseWordKey = wordKey;
        choiseWordIndex = buttonIndex;
        firstChoise = false;
        blockPractice = true;
      });
    } else if (wordKey == choiseWordKey && languageValue == 'nt') {
      setState(() {
        ntChoiseBtns[buttonIndex].backgroundColor = Colors.green.shade200;
        ptChoiseBtns[choiseWordIndex].backgroundColor = Colors.green.shade200;
        ntChoiseBtns[buttonIndex].clickable = false;
        ptChoiseBtns[choiseWordIndex].clickable = false;
        choiseWordKey = 0;
        choiseWordIndex = 0;
        firstChoise = true;
        blockPractice = false;
        blockNative = false;
      });
    } else if (wordKey == choiseWordKey && languageValue == 'pt') {
      setState(() {
        ptChoiseBtns[buttonIndex].backgroundColor = Colors.green.shade200;
        ntChoiseBtns[choiseWordIndex].backgroundColor = Colors.green.shade200;
        ptChoiseBtns[buttonIndex].clickable = false;
        ntChoiseBtns[choiseWordIndex].clickable = false;
        choiseWordKey = 0;
        choiseWordIndex = 0;
        firstChoise = true;
        blockPractice = false;
        blockNative = false;
      });
    } else if (wordKey != choiseWordKey && languageValue == 'nt') {
      setState(() {
        ntChoiseBtns[buttonIndex].backgroundColor = Colors.red.shade200;
        ptChoiseBtns[choiseWordIndex].backgroundColor = Colors.red.shade200;
        ntChoiseBtns[buttonIndex].clickable = false;
        ptChoiseBtns[choiseWordIndex].clickable = false;
        choiseWordKey = 0;
        choiseWordIndex = 0;
        firstChoise = true;
        blockPractice = false;
        blockNative = false;
      });
    } else if (wordKey != choiseWordKey && languageValue == 'pt') {
      setState(() {
        ptChoiseBtns[buttonIndex].backgroundColor = Colors.red.shade200;
        ntChoiseBtns[choiseWordIndex].backgroundColor = Colors.red.shade200;
        ptChoiseBtns[buttonIndex].clickable = false;
        ntChoiseBtns[choiseWordIndex].clickable = false;
        choiseWordKey = 0;
        choiseWordIndex = 0;
        firstChoise = true;
        blockPractice = false;
        blockNative = false;
      });
    }
  }

  String selectedOption = 'SelectNativeWord';

  void _onOptionSelected(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    AdMobService adMobService =
        AdMobService(); // AdMobService sınıfının örneğini oluşturuyoruz
    adMobService.initialize(); // Reklam servisini başlatıyoruz
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildSelectedView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    AdMobService adMobService =
        AdMobService(); // AdMobService sınıfının örneğini oluşturuyoruz
    adMobService.initialize(); // Reklam servisini başlatıyoruz
    switch (selectedOption) {
      //Select Native Word
      case 'SelectNativeWord':
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF00004D),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    "LUNGONLY",
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: "CsGordon",
                        color: Color(0xFFFFFAEF),
                        shadows: [
                          Shadow(
                            color: Color(0xFFFFC1B2),
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 3,
                  child: Center(
                    child: Text(
                      "Select Native Language",
                      style: TextStyle(
                          fontFamily: "Gotham",
                          fontSize: 23,
                          color: Colors.white),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectPracticeWord');
                              selectNativeLanguage = 1;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: SvgPicture.asset("assets/images/turkey.svg"),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectPracticeWord');
                              selectNativeLanguage = 2;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child:
                                SvgPicture.asset("assets/images/germany.svg"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectPracticeWord');
                              selectNativeLanguage = 3;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: SvgPicture.asset("assets/images/italy.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectPracticeWord');
                              selectNativeLanguage = 4;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: SvgPicture.asset("assets/images/france.svg"),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectPracticeWord');
                              selectNativeLanguage = 5;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child:
                                SvgPicture.asset("assets/images/england.svg"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: adMobService.showBannerAd(),
                ),
              ),
            ),
          ],
        );

      //Select Practice Word
      case 'SelectPracticeWord':
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF00004D),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    "LUNGONLY",
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: "CsGordon",
                        color: Color(0xFFFFFAEF),
                        shadows: [
                          Shadow(
                            color: Color(0xFFFFC1B2),
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 3,
                  child: Center(
                    child: Text(
                      "Select Practice Word",
                      style: TextStyle(
                          fontFamily: "Gotham",
                          fontSize: 23,
                          color: Colors.white),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectCategory');
                              selectPracticeLanguage = 1;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: SvgPicture.asset("assets/images/turkey.svg"),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectCategory');
                              selectPracticeLanguage = 2;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child:
                                SvgPicture.asset("assets/images/germany.svg"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectCategory');
                              selectPracticeLanguage = 3;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: SvgPicture.asset("assets/images/italy.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectCategory');
                              selectPracticeLanguage = 4;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: SvgPicture.asset("assets/images/france.svg"),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _onOptionSelected('SelectCategory');
                              selectPracticeLanguage = 5;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child:
                                SvgPicture.asset("assets/images/england.svg"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: adMobService.showBannerAd(),
                ),
              ),
            ),
          ],
        );

      //Select Category
      case 'SelectCategory':
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF00004D),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "LUNGONLY",
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: "CsGordon",
                        color: Color(0xFFFFFAEF),
                        shadows: [
                          Shadow(
                            color: Color(0xFFFFC1B2),
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Center(
                        child: Text(
                      "Select Category",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Gotham",
                          fontSize: 30),
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 1;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Verb",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 2;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Noun",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 3;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Proper Noun",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 4;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 90,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Adjective",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 5;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 85,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Adverb",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 6;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 90,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Numerals",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _onOptionSelected('RandomQuestionPage');
                            selectCategoryLanguage = 7;
                          });
                          _handleRandomWordButtonPressed(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 85,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF282559),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Interjection",
                              style: TextStyle(
                                  fontFamily: "Gotham", color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Container(
                    child: adMobService.showBannerAd(),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: adMobService.showBannerAd(),
                ),
              ),
            ),
          ],
        );
      
      //RandomQuestionPage
      case 'RandomQuestionPage':
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF00004D),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
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
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Native Language",
                            style: TextStyle(
                              fontFamily: "Gotham",
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _onOptionSelected('SelectNativeWord');
                              });
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: SvgPicture.asset(
                                selectNativeLanguage == 1
                                    ? "assets/images/turkey.svg"
                                    : selectNativeLanguage == 2
                                        ? "assets/images/germany.svg"
                                        : selectNativeLanguage == 3
                                            ? "assets/images/italy.svg"
                                            : selectNativeLanguage == 4
                                                ? "assets/images/france.svg"
                                                : selectNativeLanguage == 5
                                                    ? "assets/images/england.svg"
                                                    : "assets/images/randomquestion1.svg", // Varsayılan dil için bir SVG dosya belirleyin
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 65,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Practice Language",
                            style: TextStyle(
                              fontFamily: "Gotham",
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _onOptionSelected('SelectPracticeWord');
                              });
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: SvgPicture.asset(
                                selectPracticeLanguage == 1
                                    ? "assets/images/turkey.svg"
                                    : selectPracticeLanguage == 2
                                        ? "assets/images/germany.svg"
                                        : selectPracticeLanguage == 3
                                            ? "assets/images/italy.svg"
                                            : selectPracticeLanguage == 4
                                                ? "assets/images/france.svg"
                                                : selectPracticeLanguage == 5
                                                    ? "assets/images/england.svg"
                                                    : "assets/images/randomquestion1.svg", // Varsayılan dil için bir SVG dosya belirleyin
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 50, top: 20),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: blockNative == true
                                    ? null
                                    : ntChoiseBtns[0].clickable == true
                                        ? () => _checkAnswer(
                                            'nt', 0, ntChoiseBtns[0].wordKey)
                                        : null,
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ntChoiseBtns[0].backgroundColor ??
                                        Color(0xFF4495FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ntChoiseBtns[0].word,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: blockNative == true
                                    ? null
                                    : ntChoiseBtns[1].clickable == true
                                        ? () => _checkAnswer(
                                            'nt', 1, ntChoiseBtns[1].wordKey)
                                        : null,
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ntChoiseBtns[1].backgroundColor ??
                                        Color(0xFF4495FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ntChoiseBtns[1].word,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: blockNative == true
                                    ? null
                                    : ntChoiseBtns[2].clickable == true
                                        ? () => _checkAnswer(
                                            'nt', 2, ntChoiseBtns[2].wordKey)
                                        : null,
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ntChoiseBtns[2].backgroundColor ??
                                        Color(0xFF4495FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ntChoiseBtns[2].word,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: blockNative == true
                                    ? null
                                    : ntChoiseBtns[3].clickable == true
                                        ? () => _checkAnswer(
                                            'nt', 3, ntChoiseBtns[3].wordKey)
                                        : null,
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ntChoiseBtns[3].backgroundColor ??
                                        Color(0xFF4495FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ntChoiseBtns[3].word,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: blockNative == true
                                    ? null
                                    : ntChoiseBtns[4].clickable == true
                                        ? () => _checkAnswer(
                                            'nt', 4, ntChoiseBtns[4].wordKey)
                                        : null,
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ntChoiseBtns[4].backgroundColor ??
                                        Color(0xFF4495FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ntChoiseBtns[4].word,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, right: 50),
                          child: InkWell(
                            onTap: blockPractice == true
                                ? null
                                : ptChoiseBtns[0].clickable == true
                                    ? () => _checkAnswer(
                                        'pt', 0, ptChoiseBtns[0].wordKey)
                                    : null,
                            child: Column(
                              children: [
                                Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ptChoiseBtns[0].backgroundColor ??
                                        Color(0xFF4495FA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ptChoiseBtns[0].word,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: blockPractice == true
                                      ? null
                                      : ptChoiseBtns[1].clickable == true
                                          ? () => _checkAnswer(
                                              'pt', 1, ptChoiseBtns[1].wordKey)
                                          : null,
                                  child: Container(
                                    width: 90,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ptChoiseBtns[1].backgroundColor ??
                                          Color(0xFF4495FA),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ptChoiseBtns[1].word,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: blockPractice == true
                                      ? null
                                      : ptChoiseBtns[2].clickable == true
                                          ? () => _checkAnswer(
                                              'pt', 2, ptChoiseBtns[2].wordKey)
                                          : null,
                                  child: Container(
                                    width: 90,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ptChoiseBtns[2].backgroundColor ??
                                          Color(0xFF4495FA),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ptChoiseBtns[2].word,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: blockPractice == true
                                      ? null
                                      : ptChoiseBtns[3].clickable == true
                                          ? () => _checkAnswer(
                                              'pt', 3, ptChoiseBtns[3].wordKey)
                                          : null,
                                  child: Container(
                                    width: 90,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ptChoiseBtns[3].backgroundColor ??
                                          Color(0xFF4495FA),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ptChoiseBtns[3].word,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: blockPractice == true
                                      ? null
                                      : ptChoiseBtns[4].clickable == true
                                          ? () => _checkAnswer(
                                              'pt', 4, ptChoiseBtns[4].wordKey)
                                          : null,
                                  child: Container(
                                    width: 90,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ptChoiseBtns[4].backgroundColor ??
                                          Color(0xFF4495FA),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ptChoiseBtns[4].word,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _handleRandomWordButtonPressed(context),
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 150,
                      height: 50,
                      child:
                          SvgPicture.asset("assets/images/randomquestion2.svg"),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: adMobService.showBannerAd(),
                ),
              ),
            ),
            // Animasyonlu ekranı kontrol etmek için bir değişken kullanın
            animationScreenVisible
              ? GestureDetector(
                  onTap: () {
                    // Ekranın dışına tıkladığınızda animasyonu kapatın
                    setState(() {
                      animationScreenVisible = true;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: animationScreen, // Animasyonlu ekranı burada gösterin
                    ),
                  ),
                )
              : Container(),
          ],
        );

      default:
        return Container();
    }
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(
          seconds:
              2), // Mesajın ne kadar süreyle görüntüleneceğini belirleyebilirsiniz
    ),
  );
}
