
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_btn.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/route_and_message.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/text_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SharedPreferences sharedPreferences;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var email = TextEditingController();
  var username = TextEditingController();
  var address = TextEditingController();
  var cnt = TextEditingController();
  var pay = TextEditingController();

  bool _editMode = false;

  File? image;
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

                        if (picker!.path.isNotEmpty) {
                          setState(() {
                            image = File(picker.path);
                          });
                          Navigator.pop(context);

                          String fileName = path.basename(image!.path);

                          Reference firebaseStorageRef =
                              FirebaseStorage.instance.ref().child(fileName);

                          UploadTask uploadTask =
                              firebaseStorageRef.putFile(image!);
                          TaskSnapshot taskSnapshot = await uploadTask;
                          url = await firebaseStorageRef.getDownloadURL();

                          setState(() {});
                        }
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

                        if (picker!.path.isNotEmpty) {
                          setState(() {
                            image = File(picker.path);
                          });
                          Navigator.pop(context);

                          String fileName = path.basename(image!.path);

                          Reference firebaseStorageRef =
                              FirebaseStorage.instance.ref().child(fileName);

                          UploadTask uploadTask =
                              firebaseStorageRef.putFile(image!);
                          TaskSnapshot taskSnapshot = await uploadTask;
                          url = await firebaseStorageRef.getDownloadURL();

                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ));
  }

  getUserInfo(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    //Document ID
    String? colID = sharedPreferences.getString("col_id");

    if (userID != "null") {

      return StreamBuilder<DocumentSnapshot>(
        stream: firebaseFirestore.collection("Users").doc(colID).snapshots(),
        builder: (context, s) {
          if (s.data != null) {
            username.text = s.data!["username"];
            email.text = s.data!["email"];
            address.text = s.data!["address"];
            cnt.text = s.data!["cnt"];

            pay.text = s.data!["payment"];

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  s.data!["image"].isEmpty
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
                                  color: const Color(0xffffffff), width: 1),
                            ),
                            child: Center(
                                child: Text(
                              "Add Picture",
                              style: AppTheme.btnStyle,
                            )),
                          ),
                        )
                      : image == null
                          ? InkWell(
                              onTap: () {
                                loadImage(context);
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: s.data!["image"],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, _) =>
                                      AppTheme.loader(const Color(0xffffffff)),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                loadImage(context);
                              },
                              child: ClipOval(
                                child: Image.file(
                                  image!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 10,
                  ),
                  _editMode
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AppButton(
                            text: "Update",
                            onPressed: () {
                              updateProfile(s.data!["image"], s.data!["payment"]);
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          }
          return AppTheme.loader(const Color(0xffffffff));
        },
      );
    }
    if (userID == "null") {
      return RouteMsg.routeAndMessage(context,
          "Become a Member of News App by Signing Up yourself\n or Login");
    }
  }

  checkEditMode() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    if (userID != "null") {
      return Row(
        children: [
          Text(
            "Edit Mode",
            style: AppTheme.splashStyle.copyWith(fontSize: 8),
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
        title: Text(
          "Profile",
          style: AppTheme.appBarStyle,
        ),
        actions: [
          FutureBuilder(
              future: checkEditMode(),
              builder: (context, s) {
                if (s.data != null) {
                  return s.data as Widget ;
                }
                return Container();
              }),
        ],
      ),
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
          child: FutureBuilder(
            future: getUserInfo(context),
            builder: (context, s) {
              if (s.data != null) {
                return s.data as Widget;
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  updateProfile(String image, String payment) async {
    sharedPreferences = await SharedPreferences.getInstance();

    String? colID = sharedPreferences.getString("col_id");

    Map<String, dynamic> update = {
      "image": url.isEmpty ? image : url,
      "address": address.text,
      "payment": pay.text.isEmpty ? payment : pay.text,
      "cnt": cnt.text,
      "username": username.text,
    };

    firebaseFirestore.collection("Users").doc(colID).update(update);

    RouteMsg.msg("Profile updated successfully!");
  }
}
