import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;

  const AppButton({Key? key, required this.onPressed, required this.text, this.icon})
      : super(key: key);

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
            borderRadius: const BorderRadius.all(Radius.circular(14))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon == null
              ? Text(text,
                  textAlign: TextAlign.center,
                  style: AppTheme.btnStyle.copyWith(fontSize: 20))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 30,
                      color: const Color(0xffffffff),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(text,
                        textAlign: TextAlign.center,
                        style: AppTheme.btnStyle.copyWith(fontSize: 20)),
                  ],
                ),
        ),
      ),
    );
  }
}
