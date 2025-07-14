import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';

class AskDialog extends StatelessWidget {
  final String msg;
  final Function yesFunction;

  const AskDialog({super.key,
    required this.msg,
    required this.yesFunction,});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(top: 10),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: <Color>[
                  MyColor.indiaOrange,
                  MyColor.indiaWhite,
                  MyColor.indiaGreen,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                image: askQueIc,
                height: 50,
                width: 50,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 15,
                left: 15.0, right: 15.0, bottom: 0.0),
            child: Text(msg,
                textAlign: TextAlign.center,
                style: labelStyle()),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 35,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: MyColor.appColor),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                      yesFunction.call();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.transparent),
                        elevation:MaterialStatePropertyAll(0)),
                    child: Text('yes'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.medium))),
              ),

              Container(
                width: 80,
                height: 35,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey),
                child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.transparent),
                        elevation: MaterialStatePropertyAll(0)),
                    child: Text('no'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.medium))),
              ),
            ],
          )
        ],
      ),
    );
  }


  ///*
  ///
  TextStyle labelStyle() {
    return  TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: MyFont.roboto,
        fontWeight: MyFontWeight.medium
    );
  }

  ///*
  ///
  TextStyle titleStyle() {
    return  TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: MyFont.roboto,
        fontWeight: MyFontWeight.medium
    );
  }

}
