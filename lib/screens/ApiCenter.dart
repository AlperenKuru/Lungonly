import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class ApiUserResponse {
  int id;
  String name;
  String surname;
  String email;

  ApiUserResponse(this.id, this.name, this.surname, this.email);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
    };
  }
}

class WordFlagProvider extends ChangeNotifier {
  bool newWordFlag = false;

  void setNewWordFlag(bool value) {
    newWordFlag = value;
    notifyListeners();
  }
}

class ApiKeywordListResponse {
  int id;
  int userId;
  String tr;
  String en;
  int status;

  ApiKeywordListResponse(this.id, this.userId, this.tr, this.en, this.status);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userid': userId,
      'tr': tr,
      'en': en,
      'status': status,
    };
  }
}

class KeywordListResult {
  final bool success;
  final String message;

  KeywordListResult(this.success, this.message);
}

class WordPoolResult {
  final bool success;
  final String message;
  final List<Map<String, dynamic>> nativeWordList;
  final List<Map<String, dynamic>> practiceWordList;

  WordPoolResult({
    required this.success,
    required this.message,
    this.nativeWordList = const [],
    this.practiceWordList = const [],
  });
}

class PracticeWordServiceResponse {
  final bool success;
  final String message;
  final List<Map<String, dynamic>> practiceWordList;

  PracticeWordServiceResponse({
    required this.success,
    required this.message,
    this.practiceWordList = const [],
  });
}

class NativeWordResponse {
  String word;
  int wordKey;

  NativeWordResponse(this.word, this.wordKey);

  // JSON dönüşümü için toJson yöntemi
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'wordKey': wordKey,
    };
  }
}

class PracticeWordResponse {
  String word;
  int wordKey;

  PracticeWordResponse(this.word, this.wordKey);

  // JSON dönüşümü için toJson yöntemi
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'wordKey': wordKey,
    };
  }
}

Map<String, dynamic> userData = {}; // WordList API Servisinde kullanılıyor.

class Message {
  String getMessage;

  Message(this.getMessage);
}

class LoginResult {
  final bool success;
  final String message;

  LoginResult(this.success, this.message);
}

class SaveWordResult {
  final bool success;
  final String message;

  SaveWordResult(this.success, this.message);
}

class ApiCenter {
  static const String login_Url =
      "YOUR_LOGIN_REQUEST_URL";

  // Login metodu
  static Future<dynamic> loginService(String email, String password) async {
    // Şifreyi md5 ile şifrele
    String hashedPassword = md5.convert(utf8.encode(password)).toString();

    // Tam URL'yi oluştur
    String loginUrl = "$login_Url/$email/$hashedPassword";

    // API isteğini gerçekleştir
    http.Response response = await http.get(Uri.parse(loginUrl));
    String responseBody = response.body;
    print(responseBody);
    try {
      // Başarılı cevabı al ve döndür
      String responseBody = response.body;
      // JSON verisini Dart nesnesine dönüştür
      dynamic jsonData = json.decode(responseBody);
      if (response.statusCode == 200 && jsonData.isNotEmpty) {
        int id = jsonData[0]['<Id>k__BackingField'] as int;
        String name = jsonData[0]['<Name>k__BackingField'] as String;
        String surname = jsonData[0]['<Surname>k__BackingField'] as String;
        String email = jsonData[0]['<Email>k__BackingField'] as String;

        ApiUserResponse userResponse =
            ApiUserResponse(id, name, surname, email);

        // Dosya sisteminde bir dosya oluştur
        Directory appDocDir = await getApplicationDocumentsDirectory();
        File file = File('${appDocDir.path}/user.txt');
        await file.writeAsString(jsonEncode(userResponse.toJson()));
        return LoginResult(true, "Successful");
      } else {
        return LoginResult(false, "UserNotFound");
      }
    } catch (e) {
      return LoginResult(false, "UnexpectedError");
    }
  }

  static const String signUp_Url =
      "YOUR_SIGNUP_REQUEST_URL";

  // signUp metodu
  static Future<dynamic> signUpService(
      String name, String surname, String email, String password) async {
    // Şifreyi md5 ile şifrele
    String hashedPassword = md5.convert(utf8.encode(password)).toString();

    // Tam URL'yi oluştur
    String signUpUrl = "$signUp_Url/$name/$surname/$email/$hashedPassword";

    // API isteğini gerçekleştir
    http.Response response = await http.post(Uri.parse(signUpUrl));
    String responseBody = response.body;
    print(responseBody);
    try {
      // Başarılı cevabı al ve döndür
      String responseBody = response.body;
      // JSON verisini Dart nesnesine dönüştür
      dynamic jsonData = json.decode(responseBody);
      if (response.statusCode == 200 && jsonData.isNotEmpty) {
        return responseBody; //burada
      } else {
        String message = "Cevap alınamadı"; // Başarısız mesajı
        return jsonData(-1, message); // -1, başarısız durumunu temsil edebilir
      }
    } catch (e) {
      String message = "İstek başarısız"; // Başarısız mesajı
      return message;
    }
  }

  static const String saveWord_Url =
      "YOUR_SAVEWORD_REQUEST_URL";

  // saveWord metodu
  static Future<dynamic> saveWordService(
      String idData, String nativeWord, String practiceWord) async {
    // Tam URL'yi oluştur
    String saveWordUrl = "$saveWord_Url/$idData/$nativeWord/$practiceWord";

    // API isteğini gerçekleştir
    http.Response response = await http.post(Uri.parse(saveWordUrl));
    String responseBody = response.body;
    print(responseBody);
    try {
      // Başarılı cevabı al ve döndür
      String responseBody = response.body;
      // JSON verisini Dart nesnesine dönüştür
      dynamic jsonData = json.decode(responseBody);
      if (response.statusCode == 200 &&
          responseBody.toString() == '"Kelime Eklendi"') {
        return SaveWordResult(true, "Successful Save Word");
      } else {
        return SaveWordResult(false, "UnexpectedError");
      }
    } catch (e) {
      return SaveWordResult(false, "UnexpectedError");
    }
  }

  // keywordList metodu
  static const String keywordList_Url =
      "YOUR_KEYWORDLIST_REQUEST_URL";

  static Future<dynamic> keywordListService() async {
    int idData = 0;
    String nameData = '0';
    String surnameData = '0';
    String emailData = '0';
    String passwordData = '0';
    int statusData = 0;

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
      return KeywordListResult(false, "Token Expired");
    }

    // Tam URL'yi oluştur
    String keywordListUrl = "$keywordList_Url/$idData";
    // API isteğini gerçekleştir
    http.Response response = await http.get(Uri.parse(keywordListUrl));
    String responseBody = response.body;
    print(responseBody);
    try {
      // Başarılı cevabı al ve döndür
      String responseBody = response.body;
      // JSON verisini Dart nesnesine dönüştür
      List<dynamic> jsonData = json.decode(responseBody);

      if (response.statusCode == 200 && jsonData.isNotEmpty) {
        List<Map<String, dynamic>> keywordList = [];

        for (var item in jsonData) {
          int id = item['<Id>k__BackingField'] as int;
          int userId = item['<UserId>k__BackingField'] as int;
          String tr = item['<TR>k__BackingField'] as String;
          String en = item['<EN>k__BackingField'] as String;
          int status = item['<Status>k__BackingField'] as int;

          ApiKeywordListResponse KeywordListResponse =
              ApiKeywordListResponse(id, userId, tr, en, status);
          keywordList.add(KeywordListResponse.toJson());
        }

        // Dosya sisteminde bir dosya oluştur
        Directory appDocDir = await getApplicationDocumentsDirectory();
        File file = File('${appDocDir.path}/keyword.txt');
        await file.writeAsString(jsonEncode(keywordList));

        return KeywordListResult(true, "Successful");
      } else {
        return KeywordListResult(false, "UserNotFound");
      }
    } catch (e) {
      return KeywordListResult(false, "Exception: $e");
    }
  }

// WordPoolNativeWord metodu
  static List<int> wordKeys = [];

  // shuffleWordKeys fonksiyonu
  static List<int> shuffleWordKeys(List<int> wordKeys) {
    final random = Random();
    for (var i = wordKeys.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = wordKeys[i];
      wordKeys[i] = wordKeys[j];
      wordKeys[j] = temp;
    }
    return wordKeys;
  }

  static const String WordPoolNativeWord_Url =
      "YOUR_NATIVE_RANDOMKEYWORD_REQUEST_URL";

  static Future<dynamic> RandomQuestionService(int selectNativeLanguage,
      int selectCategoryLanguage, int selectPracticeLanguage) async {
    // Tam URL'yi oluştur
    String WordPoolNativeWordUrl =
        "$WordPoolNativeWord_Url/$selectNativeLanguage/$selectCategoryLanguage";

    // API isteğini gerçekleştir
    http.Response response = await http.get(Uri.parse(WordPoolNativeWordUrl));
    print(response);
    String responseBody = response.body;
    print(responseBody);
    try {
      // Başarılı cevabı al ve döndür
      String responseBody = response.body;
      // JSON verisini Dart nesnesine dönüştür
      dynamic jsonData = json.decode(responseBody);
      if (response.statusCode == 200 && jsonData.isNotEmpty) {
        //ekrana yazdırırken nativeWordList kullanıcaksın unutma
        List<Map<String, dynamic>> nativeWordList = [];
        wordKeys.clear();

        for (var item in jsonData) {
          String word = item['<Word>k__BackingField'] as String;
          int wordKey = item['<WordKey>k__BackingField'] as int;

          NativeWordResponse nativeWordResponse =
              NativeWordResponse(word, wordKey);
          // wordKey'leri listeye ekle
          ApiCenter.wordKeys.add(wordKey);
          nativeWordList.add(nativeWordResponse.toJson());
        }

        // WordKey değerlerini karıştır
        ApiCenter.wordKeys = shuffleWordKeys(ApiCenter.wordKeys);

        dynamic practiceWordServiceResponse =
            await ApiCenter.WordPoolPracticeWordService(
                selectPracticeLanguage, selectCategoryLanguage);
        if (practiceWordServiceResponse.success) {
          List<Map<String, dynamic>> practiceWordList =
              practiceWordServiceResponse.practiceWordList;

          return WordPoolResult(
            success: true,
            message: "Successful",
            nativeWordList: nativeWordList,
            practiceWordList: practiceWordList,
          );
        } else {
          return WordPoolResult(
            success: false,
            message: "UserNotFound",
          );
        }
      }
      //return WordPoolResult(true, "Successful", nativeWordList: nativeWordList);

      else {
        //return WordPoolResult(false, "UserNotFound");
      }
    } catch (e) {
      //return WordPoolResult(false, "UnexpectedError");
    }
  }

  static const String WordPoolPracticeWord_Url =
      "YOUR_PACRTICE_RANDOMKEYWORD_REQUEST_URL";

  // WordPoolPracticeWord metodu
  static Future<PracticeWordServiceResponse> WordPoolPracticeWordService(
      int selectPracticeLanguage, int selectCategoryLanguage) async {
    List<int> shuffledWordKeys = ApiCenter.wordKeys;
    String WordKey1 =
        shuffledWordKeys.isNotEmpty ? shuffledWordKeys[0].toString() : '';
    String WordKey2 =
        shuffledWordKeys.isNotEmpty ? shuffledWordKeys[1].toString() : '';
    String WordKey3 =
        shuffledWordKeys.isNotEmpty ? shuffledWordKeys[2].toString() : '';
    String WordKey4 =
        shuffledWordKeys.isNotEmpty ? shuffledWordKeys[3].toString() : '';
    String WordKey5 =
        shuffledWordKeys.isNotEmpty ? shuffledWordKeys[4].toString() : '';

    // Tam URL'yi oluştur
    String WordPoolPracticeWordUrl =
        "$WordPoolPracticeWord_Url/$selectPracticeLanguage/$selectCategoryLanguage/$WordKey1/$WordKey2/$WordKey3/$WordKey4/$WordKey5/";

    // API isteğini gerçekleştir
    http.Response response = await http.get(Uri.parse(WordPoolPracticeWordUrl));
    String responseBody = response.body;
    print(responseBody);
    try {
      // Başarılı cevabı al ve döndür
      String responseBody = response.body;
      // JSON verisini Dart nesnesine dönüştür
      dynamic jsonData = json.decode(responseBody);
      if (response.statusCode == 200 && jsonData.isNotEmpty) {
        List<Map<String, dynamic>> practiceWordList = [];

        for (var item in jsonData) {
          String word = item['<Word>k__BackingField'] as String;
          int wordKey = item['<WordKey>k__BackingField'] as int;

          PracticeWordResponse practiceWordResponse =
              PracticeWordResponse(word, wordKey);
          practiceWordList.add(practiceWordResponse.toJson());
        }

        return PracticeWordServiceResponse(
          success: true,
          message: "Successful",
          practiceWordList: practiceWordList,
        );
      } else {
        return PracticeWordServiceResponse(
          success: false,
          message: "UserNotFound",
        );
      }
    } catch (e) {
      return PracticeWordServiceResponse(
        success: false,
        message: "UnexpectedError",
      );
    }
  }

}
