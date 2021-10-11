import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_btn.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/route_and_message.dart';
import 'package:news_app_jawan_pakistan/screens/login.dart';
import 'package:news_app_jawan_pakistan/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({Key key}) : super(key: key);

  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  SharedPreferences sharedPreferences;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    var style =
        AppTheme.splashStyle.copyWith(color: Colors.black, fontSize: 17);

    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    //Document ID
    String colID = sharedPreferences.getString("col_id");

    if (userID != "null") {
      return StreamBuilder(
        stream: firebaseFirestore.collection("Users").doc(colID).snapshots(),
        builder: (context, s) {
          if (s.hasData) {
            return Drawer(
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: Colors.grey[100]),
                curve: Curves.easeInBack,
                child: ListView(
                  children: [
                    Center(
                      child: ClipOval(
                        child: Image.network(
                          s.data["image"].isEmpty
                              ? "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png"
                              : s.data["image"],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      s.data["username"],
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Flutter PreRequisite Hackathon\nNews App by Jawan Pakistan",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                        onPressed: () async {
                          sharedPreferences =
                              await SharedPreferences.getInstance();

                          sharedPreferences.remove("uid");
                          await auth.signOut();

                          RouteMsg.msg("Signed Out Successfully!");

                          Navigator.pop(context);
                        },
                        text: "LogOut",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return AppTheme.loader(const Color(0xff260666));
        },
      );
    }
    if (userID == "null") {
      return Drawer(
        child: DrawerHeader(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(color: Colors.grey[100]),
          curve: Curves.easeInBack,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text(
                  "Login or Register yourself for an awesome experience of News App",
                  textAlign: TextAlign.center,
                  style: style,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Login()));
                    },
                    text: "Sign in",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUp()));
                    },
                    text: "Sign Up",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Flutter PreRequisite Hackathon\nNews App by Jawan Pakistan",
                  textAlign: TextAlign.center,
                  style:
                      style.copyWith(fontSize: 22, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentUser(),
        builder: (context, s) {
          if (s.data != null) {
            return s.data;
          }
          return Container();
        });
  }
}
