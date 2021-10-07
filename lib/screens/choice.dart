//@dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/screens/bottomnav.dart';
import 'package:news_app_jawan_pakistan/screens/login.dart';
import 'package:news_app_jawan_pakistan/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Choice extends StatelessWidget {
  const Choice({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var style = const TextStyle(
      color: Color(0xffffffff),
    );


    return Scaffold(
      backgroundColor: const Color(0xff260666),
      body: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                // saveBool();
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //         builder: (context) => const MainSection()),
                //     (Route<dynamic> route) => false);


                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainSection()),
                );

              },
              child: Text("Skip",style: style,),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // saveBool();
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => const Login()),
                    //     (Route<dynamic> route) => false);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()),
                         );



                  },
                  child: const Text("Sign in"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // saveBool();
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => const SignUp()),
                    //     (Route<dynamic> route) => false);

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );


                  },
                  child: const Text("Sign up"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveBool() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("did_choice", true);
  }
}
