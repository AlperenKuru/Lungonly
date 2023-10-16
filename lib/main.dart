import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lungonly/screens/ApiCenter.dart';
import 'package:lungonly/screens/LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/BottomNavigationBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        // Diğer providerlar
        Provider<WordFlagProvider>(
          create: (_) => WordFlagProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkUserFileExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Bekleme göster
          } else if (snapshot.hasError) {
            return const Text('Hata oluştu.'); // Hata durumunda hata mesajı göster
          } else if (snapshot.data == true) {
            return BottomBarPage(); // Dosya varsa BottomBarPage'e yönlendir
          } else {
            return LoginPage(); // Dosya yoksa LoginPage'e yönlendir
          }
        },
      ),
    );
  }

  Future<bool> checkUserFileExists() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/user.txt';

    return File(filePath).exists();
  }
}
