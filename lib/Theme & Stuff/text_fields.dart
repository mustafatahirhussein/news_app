import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';

class Field {
  static Widget formField(TextEditingController controller, String label,TextInputType textInputType) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: const Color(0xffffffff),
      style: AppTheme.splashStyle.copyWith(fontSize: 14),
      decoration: InputDecoration(
        errorStyle: AppTheme.splashStyle.copyWith(fontSize: 14),
        labelText: label,
        focusedBorder:const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        labelStyle: AppTheme.splashStyle.copyWith(fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(.2),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      validator: (val) => val.isEmpty ? "Empty" : null,
    );
  }

  static Widget formFieldWithPass(
      TextEditingController controller, String label, Function onTap,bool visible) {
    return TextFormField(
      controller: controller,
      obscureText: visible,
      cursorColor: const Color(0xffffffff),
      style: AppTheme.splashStyle.copyWith(fontSize: 14),
      decoration: InputDecoration(
        errorStyle: AppTheme.splashStyle.copyWith(fontSize: 14),
        labelText: label,
        focusedBorder:const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        labelStyle: AppTheme.splashStyle.copyWith(fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(.2),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: InkWell(
          child: Icon(visible ? Icons.visibility_off : Icons.visibility,color: const Color(0xffffffff),),
          onTap: onTap,
        ),
      ),
      validator: (val) => val.isEmpty ? "Empty" : null,
    );
  }
}
