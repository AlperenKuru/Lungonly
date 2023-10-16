import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lungonly/main.dart';
import 'package:lungonly/screens/BottomNavigationBar.dart';
import 'package:lungonly/screens/SignUpPage.dart';
import 'package:lungonly/screens/forgotPasswordPage.dart';
import 'AdMobService.dart';
import 'ApiCenter.dart';
import 'SaveWordPage.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Artboard? _riveArtboard;

  Future<Artboard?>? _loadAnimationFuture;

  @override
  void initState() {
    super.initState();
    _loadAnimationFuture = _loadAnimation();
  }

  Future<Artboard?> _loadAnimation() async {
    final file = await RiveFile.asset('assets/animation.riv');
    final artboard = file.mainArtboard;
    return artboard;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLoginButtonPressed(BuildContext context) async {
    String email = nameController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, "Email ve şifre alanları boş bırakılamaz.");
      return;
    }

    // API isteği için login metodunu çağır
    dynamic response = await ApiCenter.loginService(email, password);

    if (response.success == true) {
      // Başarılı cevap alındı, işlemleri burada yapabilirsiniz.
      showSnackBar(context, "Giriş başarılı.");

      // Animasyonu yükle
      await _loadAnimation();

      // Animasyon yüklendikten sonra anasayfaya yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBarPage()),
      );
    } else {
      // API isteğinde hata oluştu veya giriş başarısız oldu,
      showSnackBar(context, "İşlem başarısız.");
    }
  }

  bool icondata = true;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xFF00004D),
            ),
            child: Center(
              child: Column(
                children: [
                  Flexible(
                    flex: 2, // Resim ve başlık alanının esnekliği
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 38,
                              fontFamily: "Gotham",
                              color: Color(0xFF212163),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "LUNGONLY",
                            style: TextStyle(
                                fontSize: 35,
                                fontFamily: "CsGordon",
                                color: Color(0xFF212163),
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFFFC1B2),
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                  )
                                ]),
                          ),
                          SvgPicture.asset(
                            'assets/images/mans.svg',
                            width: 230,
                            height: 180,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3, // Giriş alanı ve düğmelerin esnekliği
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 70),
                            width: 320,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF212163),
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextField(
                                controller: nameController,
                                style: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    color: Color(0xFFF5F5F5),
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.account_circle_outlined,
                                    color: Color(0xFFF9FAFB),
                                  ),
                                  hintText: "Username",
                                  hintStyle: GoogleFonts.quicksand(
                                      fontSize: 15,
                                      color: Color(0xFFF5F5F5),
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 320,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF212163),
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextField(
                                controller: passwordController,
                                obscureText: icondata,
                                style: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    color: Color(0xFFF5F5F5),
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        icondata = !icondata;
                                      });
                                    },
                                    icon: Icon(
                                      icondata
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: Color(0xFFF9FAFB),
                                  ),
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.quicksand(
                                      fontSize: 15,
                                      color: Color(0xFFF5F5F5),
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                Text("Remember Password",
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white)),
                                SizedBox(width: 20),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage()));
                                  },
                                  child: Text("Forgot Password",
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => _handleLoginButtonPressed(context),
                            child: Container(
                              width: 350,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xFF212163),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                              child: Text(
                                "Don't Have an Account? \n             Sign Up",
                                style:
                                    GoogleFonts.quicksand(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
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
