import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lungonly/main.dart';
import 'package:lungonly/screens/LoginPage.dart';
import 'package:lungonly/screens/SignUpPage.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool icondata = true;

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
                  Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: -0.5,
                            child: Row(
                              children: [
                                Text(
                                  "WORD",
                                  style: TextStyle(
                                      fontSize: 52,
                                      fontFamily: "CsGordon",
                                      color: Color(0xFF212163),
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFFF5F5F5),
                                          offset: Offset(2, 2),
                                          blurRadius: 3,
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 100),
                          Container(
                            margin: EdgeInsets.only(left: 100),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/regirl.svg', // SVG dosya yolunu ayarlayın
                                  width: 300,
                                  height: 200,
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 150),
                                  child: SvgPicture.asset(
                                    'assets/images/chinatext.svg', // SVG dosya yolunu ayarlayın
                                    width: 100,
                                    height: 60,
                                  ),
                                ),
                              ],
                            ),
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
                                margin: EdgeInsets.only(top: 70, left: 40),
                                child: Text(
                                  "Reset \nPassword",
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: TextField(
                              obscureText: icondata,
                              style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  color: Colors.black,
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
                                    color: Color(0xFF00004D),
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: "New Password",
                                hintStyle: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    color: Color(0xFF212163),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: TextField(
                              obscureText: icondata,
                              style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  color: Colors.black,
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
                                    color: Color(0xFF00004D),
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: "Confirm New Password",
                                hintStyle: GoogleFonts.quicksand(
                                    fontSize: 15,
                                    color: Color(0xFF212163),
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage(),
                                ));
                          },
                          child: Container(
                            width: 350,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xFF212163),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: GoogleFonts.quicksand(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
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
