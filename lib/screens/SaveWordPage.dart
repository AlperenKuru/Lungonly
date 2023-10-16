import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lungonly/main.dart';
import 'package:lungonly/screens/LoginPage.dart';
import 'package:lungonly/screens/RandomQuesitonPage.dart';
import 'package:lungonly/screens/ResetPasswordPage.dart';
import 'package:lungonly/screens/SignUpPage.dart';
import 'package:lungonly/screens/WordListPage.dart';
import 'package:lungonly/screens/WordQuesitonPage.dart';
import 'package:rive/rive.dart';

import 'AdMobService.dart';
import 'ApiCenter.dart';
import 'BottomNavigationBar.dart';

class SaveWordPage extends StatelessWidget {
  // Kullanıcıdan alınacak veriler için controller tanımlandı.
  final TextEditingController nativeWordController = TextEditingController();
  final TextEditingController practiceWordController = TextEditingController();

  Map<String, dynamic> userData =
      {}; // UserData başlangıçta boş bir harita olarak tanımlanır

  // Save Word butonuna basıldığında gerçekleşecek fonksiyon tanımlandı
  void _handleSaveWordButtonPressed(BuildContext context) async {
    int idData = 0;
    String nameData = '0';
    String surnameData = '0';
    String emailData = '0';
    String passwordData = '0';
    int statusData = 0;

    String nativeWord = nativeWordController.text;
    String practiceWord = practiceWordController.text;

    // Dosyadan kullanıcı bilgilerini okuma ve değişkenlere atama işlemi yapıldı.
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File('${appDocDir.path}/user.txt');
      String contents = await file.readAsString();
      userData = json.decode(contents);
      idData = userData['id'];
      nameData = userData['name'];
      surnameData = userData['surname'];
      emailData = userData['email'];
    } catch (e) {
      print("User Information expired: $e");
      showSnackBar(context, "Token Expired.");
    }

    if (nativeWord.isEmpty || practiceWord.isEmpty) {
      showSnackBar(context, "Email ve şifre alanları boş bırakılamaz.");
      return;
    }

    // API isteği için saveWordService metodunu çağırın ve yanıtı alın
    dynamic response = await ApiCenter.saveWordService(
        idData.toString(), nativeWord, practiceWord);

    if (response.success == true) {
      // Başarılı cevap alındı, işlemleri burada yapabilirsiniz.
      showSnackBar(context, "Ekleme işlemi başarılı.");
    } else {
      // API isteğinde hata oluştu veya giriş başarısız oldu,
      showSnackBar(context, "Ekleme işlemi başarısız.");
    }
  }

  @override
  Widget build(BuildContext context) {
    //AdMobService.dart dosyasından reklam görüntüsünü eklemek için kullanılır.
    AdMobService adMobService =
        AdMobService(); // AdMobService sınıfının örneğini oluşturuldu
    adMobService.initialize(); // Reklam servisini başlatıldı
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF00004D),
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
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Save World",
                  style: TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontFamily: "Gotham",
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70),
                  width: 320,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF212163),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      controller: nativeWordController,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Color(0xFFF5F5F5),
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/images/star.svg",
                          ),
                        ),
                        hintText: "Native Word",
                        hintStyle: TextStyle(
                          fontFamily: "Gotham",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: 320,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF212163),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      controller: practiceWordController,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Color(0xFFF5F5F5),
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/images/star2.svg",
                          ),
                        ),
                        hintText: "Practice Word",
                        hintStyle: TextStyle(
                          fontFamily: "Gotham",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordListPage(),
                      ),
                    );
                  },
                  child: InkWell(
                    onTap: () => _handleSaveWordButtonPressed(context),
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      width: 120,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Gotham",
                            fontSize: 18,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF282559),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                  child: Center(
                    child: RiveAnimation.asset("assets/animation.riv"),
                  ),
                )
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
}
