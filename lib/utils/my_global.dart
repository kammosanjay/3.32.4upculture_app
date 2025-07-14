import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'dart:math' as math;


class MyGlobal{


  ///
  ///
  ///
  static  dateInServerFormat({required date}){
    // DateTime parseDate = DateTime.parse(date!);
    DateTime dateTime = DateTime(date.year, date.month, date.day, 00, 00, 00);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return  formattedDate;
  }

  ///
  ///
  ///
  static String checkNullData(String? data){
    if(data == null){
      return '';
    }else{
      return data;
    }
  }


  ///
  ///
  ///
  static Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["byte", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  ///
  ///
  ///
  static get12HrTimeFormat({required date, required time}){
    log('Time $time');
    DateTime dateTime = DateTime(date.year, date.month, date.day, int.parse(time.toString().substring(0,2)), int.parse(time.toString().substring(3,5)));
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return  formattedTime;
  }

}