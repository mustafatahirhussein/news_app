//@dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_btn.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/text_fields.dart';
import 'package:news_app_jawan_pakistan/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var email = TextEditingController();
  var pass = TextEditingController();

  var username = TextEditingController();
  var address = TextEditingController();
  var cnt = TextEditingController();

  String paymentOpt = "Cash";
  var items = ["Cash", "Credit", "Debit", "Cheque"];

  File image;
  bool _isVisible = true;

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential userCredential;
  SharedPreferences sharedPreferences;

  String url = "";

  loadImage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppButton(
                      text: "Pictures",
                      onPressed: () async {
                        var picker = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (picker.path.isNotEmpty) {
                          setState(() {
                            image = File(picker.path);
                          });

                          String fileName = path.basename(image.path);

                          Reference firebaseStorageRef =
                          FirebaseStorage.instance.ref().child(fileName);

                          UploadTask uploadTask =
                          firebaseStorageRef.putFile(image);
                          TaskSnapshot taskSnapshot = await uploadTask;
                          url = await firebaseStorageRef.getDownloadURL();

                          setState(() {});
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppButton(
                      text: "Camera",
                      onPressed: () async {
                        var picker = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        if (picker.path.isNotEmpty) {
                          setState(() {
                            image = File(picker.path);
                          });

                          String fileName = path.basename(image.path);

                          Reference firebaseStorageRef =
                          FirebaseStorage.instance.ref().child(fileName);

                          UploadTask uploadTask =
                          firebaseStorageRef.putFile(image);
                          TaskSnapshot taskSnapshot = await uploadTask;
                          url = await firebaseStorageRef.getDownloadURL();

                          setState(() {});
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ));
  }

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
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image == null
                      ? InkWell(
                          onTap: () {
                            loadImage(context);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.color,
                                border: Border.all(
                                    color: const Color(0xffffffff), width: 1)),
                            child: Center(
                                child: Text(
                              "Add Picture",
                              style: AppTheme.btnStyle,
                            )),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            loadImage(context);
                          },
                          child: ClipOval(
                            child: Image.file(
                              image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Field.formField(
                    username,
                    "Username",
                    TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Field.formField(
                    email,
                    "Email",
                    TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Field.formFieldWithPass(pass, "Password", toggle, _isVisible),
                  const SizedBox(
                    height: 20,
                  ),
                  Field.formField(
                    address,
                    "Address",
                    TextInputType.streetAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Field.formField(
                    cnt,
                    "Contact",
                    TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffffffff)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: DropdownButton(
                      underline: Container(),
                      selectedItemBuilder: (BuildContext context) {
                        return items.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: AppTheme.btnStyle,
                            ),
                          );
                        }).toList();
                      },
                      iconEnabledColor: const Color(0xffffffff),
                      value: paymentOpt,
                      items: items.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style:
                                AppTheme.btnStyle.copyWith(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          paymentOpt = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppButton(
                      text: "Register",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          try {
                            userCredential =
                                await auth.createUserWithEmailAndPassword(
                                    email: email.text, password: pass.text);

                            if (userCredential.user != null) {
                              createUser(userCredential.user.uid);
                              Fluttertoast.showToast(
                                  msg: "Signed Successfully!");
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              debugPrint('The password provided is too weak.');

                              Fluttertoast.showToast(msg: "Password is weak");
                            } else if (e.code == 'email-already-in-use') {
                              debugPrint(
                                  'The account already exists for that email.');

                              Fluttertoast.showToast(
                                  msg: "User already exists");
                            }
                          } catch (e) {
                            debugPrint(e);
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

  Future<void> createUser(String uid) async {
    Map<String, dynamic> data = {
      "username": username.text,
      "email": email.text,
      "address": address.text,
      "cnt": cnt.text,
      "payment": paymentOpt,
      "image": url,
    };
    FirebaseFirestore.instance.collection("Users").doc(uid).set(data);

    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("col_id", uid);

    if (data == null) {
      debugPrint('Email is not valid');
    } else {
      debugPrint(data.toString());

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false);
    }
  }

  toggle() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
