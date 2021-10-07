//@dart=2.9
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("News App\nPreRequisite Hackathon by Jawan Pakistan"),
      ),
    );
  }
}
