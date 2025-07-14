import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LangController extends GetxController {
  void changeLang({required String lang, required String countryCode}) {
    Get.updateLocale(Locale(lang, countryCode));
  }
}
