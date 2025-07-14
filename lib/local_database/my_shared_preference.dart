import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upculture/screen/common/lngCodee.dart';

class MySharedPreference {
  static SharedPreferences? _sharedPreferences;
  static MySharedPreference? _mySharedPreference;

  ///*
  ///
  ///
  static Future<MySharedPreference?> getInstance() async {
    _mySharedPreference ??=
        MySharedPreference(); // ?? (_mySharedPreference == null){_mySharedPreference = MySharedPreference()}
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _mySharedPreference;
  }

 
  Future<void> saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  Future<Locale> getSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? langCode =
    //     prefs.getString('languageCode') ?? MyLangCode.langcode.toString();
    String langCode = prefs.getString('languageCode') ?? 'hi';
    return (langCode == 'en')
        ? const Locale('en', 'US')
        : const Locale('hi', 'IN');
  }

  ///*
  ///
  ///
  static logout() {
    if (_sharedPreferences != null) {
      _sharedPreferences!.clear();
    }
  }

  ///*
  ///
  ///
  static setString(String key, String? value) {
    _sharedPreferences!.setString(key, value!);
  }

  ///*
  ///
  static getString(String key) {
    return _sharedPreferences!.getString(key);
  }

  ///*
  ///
  ///
  static setBool(String key, bool value) {
    _sharedPreferences!.setBool(key, value);
  }

  ///*
  ///
  ///
  static getBool(String key) {
    return _sharedPreferences!.getBool(key) ?? false;
  }

  ///*
  ///
  static setInt(String key, int? value) {
    _sharedPreferences!.setInt(key, value!);
  }

  ///*
  ///
  ///
  static getInt(String key) {
    return _sharedPreferences!.getInt(key);
  }



  
}
