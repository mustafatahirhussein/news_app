//@dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/text_fields.dart';
import 'package:news_app_jawan_pakistan/screens/bottomnav.dart';
import 'package:news_app_jawan_pakistan/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences sharedPreferences;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var email = TextEditingController();
  var username = TextEditingController();
  var address = TextEditingController();
  var cnt = TextEditingController();
  var pay = TextEditingController();

  bool _editMode = false;

  File image;
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

                          url = await firebaseStorageRef.getDownloadURL();

                          setState(() {});
                        }

                        Navigator.pop(context);
                      },
                      child: const Text("Pictures")),
                  const SizedBox(width: 10),
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

                          url = await firebaseStorageRef.getDownloadURL();

                          setState(() {});
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Camera")),
                ],
              ),
            ));
  }

  getUserInfo() async {
    var style = const TextStyle(
      color: Color(0xffffffff),
    );

    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    //Document ID
    String colID = sharedPreferences.getString("col_id");

    if (userID != "null") {
      return StreamBuilder(
        stream: firebaseFirestore.collection("Users").doc(colID).snapshots(),
        builder: (context, s) {
          if (s.data != null) {
            username.text = s.data["username"];
            email.text = s.data["email"];
            address.text = s.data["address"];
            cnt.text = s.data["cnt"];

            pay.text = s.data["payment"];

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  s.data["image"].isEmpty
                      ? InkWell(
                          onTap: () {
                            loadImage(context);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
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
                      : image == null
                          ? InkWell(
                              onTap: () {
                                loadImage(context);
                              },
                              child: ClipOval(
                                child: Image.network(
                                  s.data["image"],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
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
                  Field.formField(
                    pay,
                    "Payment Type",
                    TextInputType.text,
                  ),
                  _editMode
                      ? ElevatedButton(
                          onPressed: () {
                            updateProfile(s.data["image"], s.data["payment"]);
                          },
                          child: const Text("Update"),
                        )
                      : Container(),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    if (userID == "null") {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You have not registered!!\nSign up or Login"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text("Sign in"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      );
    }
  }

  checkEditMode() async {
    var style = const TextStyle(
      color: Color(0xffffffff),
    );

    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    if (userID != "null") {
      return Row(
        children: [
          Text(
            "Edit Mode",
            style: style.copyWith(fontSize: 8),
          ),
          Switch(
            activeColor: Colors.green,
            inactiveTrackColor: Colors.grey,
            value: _editMode,
            onChanged: (val) {
              setState(() {
                _editMode = !_editMode;
              });
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.color,
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          FutureBuilder(
              future: checkEditMode(),
              builder: (context, s) {
                if (s.data != null) {
                  return s.data;
                }
                return Container();
              }),
        ],
      ),
      body: FutureBuilder(
          future: getUserInfo(),
          builder: (context, s) {
            if (s.data != null) {
              return s.data;
            }
            return Container();
          }),
    );
  }

  updateProfile(String image, String payment) async {
    sharedPreferences = await SharedPreferences.getInstance();

    String colID = sharedPreferences.getString("col_id");

    Map<String, dynamic> update = {
      "image": url.isEmpty ? image : url,
      "address": address.text,
      "payment": pay.text.isEmpty ? payment : pay.text,
      "cnt": cnt.text,
      "username": username.text,
    };

    firebaseFirestore.collection("Users").doc(colID).update(update);

    Fluttertoast.showToast(msg: "Profile updated successfully!");
  }
}
