//@dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.color,
        centerTitle: true,
        title: const Text("About App"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/back.jpg"),
          fit: BoxFit.cover,
        )),
        child:  Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Text("News App\nA PreRequisite Hackathon by Jawan Pakistan",textAlign: TextAlign.center,style: AppTheme.splashStyle.copyWith(fontSize: 24),),
          ),
        ),
      ),
    );
  }
}
