import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lungonly/screens/RandomQuesitonPage.dart';
import 'package:lungonly/screens/WordListPage.dart';
import 'package:lungonly/screens/WordQuesitonPage.dart';
import 'package:lungonly/screens/SaveWordPage.dart';

import 'AdMobService.dart';

class BottomBarPage extends StatefulWidget {
  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    SaveWordPage(),
    WordListPage(),
    WordQuestionPage(),
    RandomQuestionPage(),
  ];

  AdMobService adMobService =
      AdMobService(); // AdMobService sınıfının örneğini oluşturuyoruz

  @override
  void initState() {
    super.initState();
    adMobService.initialize(); // Reklam servisini başlatıyoruz
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF00004D),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              adMobService.closeBannerAd();
              _currentIndex = index;
              adMobService.showBannerAd();
            });
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: SvgPicture.asset('assets/images/WordSave.svg',
                  width: 25, height: 50),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: SvgPicture.asset('assets/images/WordList.svg',
                  width: 25, height: 50),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: SvgPicture.asset('assets/images/WordQuesiton.svg',
                  width: 25, height: 50),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: SvgPicture.asset('assets/images/RandomQuestion.svg',
                  width: 25, height: 50),
              label: '',
            ),
          ],
          type: BottomNavigationBarType.shifting,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontFamily: "Gotham"),
        ),
      ),
    );
  }
}
