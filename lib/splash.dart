//@dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/screens/bottomnav.dart';
import 'package:news_app_jawan_pakistan/screens/choice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Duration duration = const Duration(seconds: 4);
  SharedPreferences sharedPreferences;

  runSplash(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();

    bool check = sharedPreferences.get("did_choice") ?? false;

    Timer.periodic(duration, (timer) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  check ? const MainSection() : const Choice()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    runSplash(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff260666),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/news.png",
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "News App",
            style: AppTheme.splashStyle,
          ),
          const SizedBox(
            height: 30,
          ),
          const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff)))
        ],
      )),
    );
  }
}
