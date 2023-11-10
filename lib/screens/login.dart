
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_btn.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/route_and_message.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/text_fields.dart';
import 'package:news_app_jawan_pakistan/screens/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isVisible = true;

  late SharedPreferences sharedPreferences;

  FirebaseAuth auth = FirebaseAuth.instance;

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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Field.formField(email, "Email", TextInputType.emailAddress),
                  const SizedBox(
                    height: 20,
                  ),
                  Field.formFieldWithPass(pass, "Password", toggle, _isVisible),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: AppButton(
                      text: "Sign In",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            UserCredential userCredential =
                                await auth.signInWithEmailAndPassword(
                              email: email.text,
                              password: pass.text,
                            );

                            if (userCredential.user != null) {
                              sharedPreferences =
                                  await SharedPreferences.getInstance();

                              sharedPreferences.setString(
                                  "uid", userCredential.user!.uid);

                              RouteMsg.msg("Logged In Successfully!");

                            }

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const MainSection()),
                                (Route<dynamic> route) => false);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {

                              RouteMsg.msg("User not found");


                              debugPrint('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              debugPrint(
                                  'Wrong password provided for that user.');


                              RouteMsg.msg("Wrong Password");
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  toggle() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
