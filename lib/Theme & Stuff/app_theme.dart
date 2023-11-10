import 'package:flutter/material.dart';

class AppTheme {
  static const Color color = Color(0xff260666);

  static TextStyle splashStyle = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w500,
      color: Color(0xffffffff),
      fontFamily: 'Dosis');

  static TextStyle btnStyle = const TextStyle(
      fontWeight: FontWeight.w100,
      color: Color(0xffffffff),
      fontFamily: 'Dosis');

  static TextStyle appBarStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xffffffff),
      fontSize: 18,
      fontFamily: 'Dosis');

  static loader(Color color) {
    return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color)),
    );
  }
}
