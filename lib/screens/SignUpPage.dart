import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lungonly/main.dart';
import 'package:lungonly/screens/LoginPage.dart';
import 'package:lungonly/screens/SignUpPage.dart';
import 'package:animated/animated.dart';

import 'ApiCenter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Kullanıcı adı, soyadı, e-posta ve şifre için kontrolleri tanımlandı.
  final TextEditingController NameController = TextEditingController();
  final TextEditingController SurnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController Password2Controller = TextEditingController();
  
  // Sign up butonuna tıklanıldığında çağırılacak fonksiyon oluşturuldu.
  void _handleSignUpButtonPressed(BuildContext context) async {
    // Kullanıcıdan alınan verileri değişkenlere atandı
    String name = NameController.text;
    String surname = SurnameController.text;
    String email = emailController.text;
    String password = PasswordController.text;
    String password2 = Password2Controller.text;

    // Boş alanları kontrol edildi eğer boş ise uyarı gösterildi.
    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty || password2.isEmpty) {
      showSnackBar(context, "isim ve diğer alanlar boş olamaz.");
    }
    // Şifrelerin eşleşip eşleşmediğini kontrol edildi ve eğer boş ise uyarı gösterildi.
    if (password != password2){
      showSnackBar(context, "Şifre uyuşmuyor");
    }

    // API isteği için signup metodu çağırıldı.
    dynamic response =
        await ApiCenter.signUpService(name, surname, email, password);

    if (Message != null) {
      // Başarılı cevap alındı, işlemleri burada yapabilirsiniz.
      showSnackBar(context, response);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // API isteğinde hata oluştu veya giriş başarısız oldu,
      showSnackBar(context, "işlem başarısız.");
    }
  }

  bool icondata = true;
  bool scaled = false;
  @override
  Widget build(BuildContext context) {
    bool icondata = true;
    bool _isChecked = false;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF00004D),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/girl.svg',
                            width: 150,
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50, left: 40),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontFamily: "Gotham",
                                      fontSize: 40,
                                      color: Colors.white),
                                ),
                              ),
                            ],
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
                              controller: NameController,
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
                                hintText: "Name",
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
                              controller: SurnameController,
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
                                hintText: "Surname",
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
                              controller: emailController,
                              style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  color: Color(0xFFF5F5F5),
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFFF9FAFB),
                                ),
                                hintText: "Email",
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
                              controller: PasswordController,
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
                          margin: EdgeInsets.only(top: 20),
                          width: 320,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF212163),
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextField(
                              controller: Password2Controller,
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
                                hintText: "Confirm Password",
                                hintStyle: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    color: Color(0xFFF5F5F5),
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, top: 10),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () => _handleSignUpButtonPressed(context),
                          child: Container(
                            width: 350,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF212163),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Sign Up",
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
                                      builder: (context) => LoginPage()));
                            },
                            child: Text(
                              "Already Have Account?  \n             Sign In",
                              style: GoogleFonts.quicksand(color: Colors.white),
                            )),
                      ],
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
}

// Uyarı göstermek için bir fonksiyon tanımlandı
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(
          seconds:
              2), // Mesajın ne kadar süreyle görüntüleneceğini burada belirlendi.
    ),
  );
}