//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_jawan_pakistan/screens/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SharedPreferences sharedPreferences;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (val) => val.isEmpty ? "Empty" : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pass,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (val) => val.isEmpty ? "Empty" : null,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                          email: email.text,
                          password: pass.text,
                        );

                        sharedPreferences =
                            await SharedPreferences.getInstance();

                        sharedPreferences.setString(
                            "uid", userCredential.user.uid);

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const MainSection()),
                            (Route<dynamic> route) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(msg: "User not found");

                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');

                          Fluttertoast.showToast(msg: "Wrong Password");
                        }
                      }
                    }
                  },
                  child: Text("Login")),
            ],
          ),
        ),
      )),
    );
  }
}
