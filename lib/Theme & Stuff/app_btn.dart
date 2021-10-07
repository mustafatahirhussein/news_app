import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';

class AppButton extends StatelessWidget {

  final Function onPressed;
  final String text;

  const AppButton({Key key,this.onPressed,this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.8),
          border: Border.all(color: const Color(0xffffffff)),
          borderRadius: const BorderRadius.all(Radius.circular(14))
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(text,textAlign: TextAlign.center,style: AppTheme.btnStyle.copyWith(fontSize: 20)),
        ),
      ),
    );
  }
}
