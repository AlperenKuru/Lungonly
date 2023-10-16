import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lungonly/screens/ResetPasswordPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
                    flex: 3,
                    child: Container(
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
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            SvgPicture.asset(
                              'assets/images/friends.svg',
                              width: 300,
                              height: 200,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 70, left: 40),
                                  child: Text(
                                    "Forgot \nPassword",
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
