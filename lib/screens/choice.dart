//@dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_btn.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/screens/bottomnav.dart';
import 'package:news_app_jawan_pakistan/screens/login.dart';
import 'package:news_app_jawan_pakistan/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Choice extends StatelessWidget {
  const Choice({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/back.jpg"),
          fit: BoxFit.cover,
        )),
        child: Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  saveBool();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const MainSection()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  "Skip",
                  style: AppTheme.splashStyle.copyWith(
                      fontSize: 26,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppButton(
                        text: "Sign Up",
                        onPressed: () {
                          // saveBool();
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => const SignUp()),
                          //     (Route<dynamic> route) => false);


                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppButton(
                        text: "Sign In",
                        onPressed: () {
                          // saveBool();
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => const Login()),
                          //     (Route<dynamic> route) => false);

                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveBool() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("did_choice", true);
  }
}
