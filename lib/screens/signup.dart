//@dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
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
                  ElevatedButton(
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
                      child: Text("Pictures")),
                  ElevatedButton(
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
                      child: Text("Camera")),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      color: Color(0xffffffff),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
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
                        ),
                        child: Center(
                            child: Text(
                          "image",
                          style: style,
                        )),
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                        image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (val) => val.isEmpty ? "Empty" : null,
              ),
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: address,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                validator: (val) => val.isEmpty ? "Empty" : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cnt,
                decoration: InputDecoration(
                  labelText: 'Contact',
                ),
                validator: (val) => val.isEmpty ? "Empty" : null,
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton(
                value: paymentOpt,
                items: items.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    paymentOpt = val;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        userCredential =
                            await auth.createUserWithEmailAndPassword(
                                email: email.text, password: pass.text);

                        createUser();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          debugPrint('The password provided is too weak.');

                          Fluttertoast.showToast(msg: "Password is weak");
                        } else if (e.code == 'email-already-in-use') {
                          debugPrint(
                              'The account already exists for that email.');

                          Fluttertoast.showToast(msg: "User already exists");
                        }
                      } catch (e) {
                        debugPrint(e);
                      }
                    }
                  },
                  child: Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }

  void createUser() {
    Map<String, dynamic> data = {
      "username": username.text,
      "email": email.text,
      "address": address.text,
      "cnt": cnt.text,
      "payment": paymentOpt,
      "image": url,
    };
    FirebaseFirestore.instance.collection("Users").add(data).then((value) async {
      sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.setString(
          "col_id", value.id);

      print(value.id);
    });
    if (data == null) {
      debugPrint('Email is not valid');
    } else {
      debugPrint(data.toString());

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
              (Route<dynamic> route) => false);
    }
  }
}
