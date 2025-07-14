import 'package:flutter/material.dart';
import 'package:upculture/resources/my_font.dart';

import '../resources/my_color.dart';

class MyStyle{

  ///
  ///
  ///
  static OutlineInputBorder inputFocusBorder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(color: MyColor.appColor,width: 1),
    );
  }


  ///
  ///
  ///
  static OutlineInputBorder inputEnableBorder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black38,width: 1)
    );
  }

  ///
  ///
  ///
  static OutlineInputBorder inputErrorBorder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red,width: 1)
    );
  }

  ///
  ///
  ///
  static InputDecoration dropdownSearchStyle({required hint}){
    return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.black38,
            fontSize: 14,
            fontFamily: MyFont.roboto
        ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      prefixIcon: const Icon(
        Icons.search,
        color: MyColor.appColor,
      ),
      border: InputBorder.none,
      disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.appColor, width: 1),
          borderRadius: BorderRadius.circular(50)
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.appColor, width: 1),
          borderRadius: BorderRadius.circular(50)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.appColor, width: 1),
          borderRadius: BorderRadius.circular(50)
      ),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColor.appColor, width: 1),
          borderRadius: BorderRadius.circular(50)
      ),
    );
  }

}