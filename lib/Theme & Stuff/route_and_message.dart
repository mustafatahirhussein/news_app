import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_jawan_pakistan/screens/login.dart';
import 'package:news_app_jawan_pakistan/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_btn.dart';
import 'app_theme.dart';

class RouteMsg {
  static routeAndMessage(BuildContext context, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            msg,
            textAlign: TextAlign.center,
            style: AppTheme.splashStyle.copyWith(fontSize: 24),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: AppButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              text: "Sign in",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: AppButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              text: "Sign Up",
            ),
          ),
        ],
      ),
    );
  }

  static Future<String> userExistCheck() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    return userID;
  }

  static msg(String msg) {
    Fluttertoast.showToast(
        msg:
        msg);
  }
}
