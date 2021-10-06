//@dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences sharedPreferences;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var email = TextEditingController();
  var username = TextEditingController();
  var address = TextEditingController();
  var cnt = TextEditingController();

  String paymentOpt = "Cash";
  var items = ["Cash", "Credit", "Debit", "Cheque"];

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

  getUserInfo() async {
    var style = TextStyle(
      color: Color(0xffffffff),
    );

    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("col_id");

    if (userID.isNotEmpty) {
      final DocumentReference document =
          firebaseFirestore.collection("Users").doc(userID);

      return StreamBuilder(
        stream: firebaseFirestore.collection("Users").doc(userID).snapshots(),
        builder: (context, s) {
          if (s.hasData) {
            username.text = s.data["username"];
            email.text = s.data["email"];
            address.text = s.data["address"];
            cnt.text = s.data["cnt"];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                s.data["image"] == null
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
                        child: Image.network(
                          s.data["image"],
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
                      s.data["payment"] = paymentOpt;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    updateProfile(s.data["image"],s.data["payment"]);
                  },
                  child: Text("Update"),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    if (userID.isEmpty) {
      return Center(
        child: Text("You have not registered!!"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  updateProfile(String image,String pay) async {
    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("col_id");

    Map<String, dynamic> update = {
      "image": url.isEmpty ? image : url,
      "address": address.text,
      "payment": pay,
      "cnt": cnt.text,
      "username": username.text,
    };

    firebaseFirestore.collection("Users").doc(userID).update(update);

    Fluttertoast.showToast(msg: "Profile updated successfully!");
  }
}
