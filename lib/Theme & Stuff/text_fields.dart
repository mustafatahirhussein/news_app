import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Field {
  static Widget formField(TextEditingController controller, String label,TextInputType textInputType) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: label,
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: InkWell(
          child: Icon(visible ? Icons.visibility_off : Icons.visibility),
          onTap: onTap,
        ),
      ),
      validator: (val) => val.isEmpty ? "Empty" : null,
    );
  }
}
