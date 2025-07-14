import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:upculture/screen/artist/register_step_src.dart';

import '../../dialog/custom_progress_dialog.dart';
import '../../dialog/error_dialog.dart';
import '../../network/api_constants.dart';
import '../../resources/my_color.dart';
import '../../resources/my_font.dart';
import '../../resources/my_font_weight.dart';

import 'package:http/http.dart' as http;
import '../../utils/my_widget.dart';

// ignore: must_be_immutable
class NewRegisterOtpSrc extends StatefulWidget {
  String lang, name, mobile, email, userId, otp;
  NewRegisterOtpSrc(
      this.lang, this.name, this.mobile, this.email, this.userId, this.otp,
      {super.key});
  @override
  State<StatefulWidget> createState() {
    return NewRegisterOtpSrcState();
  }
}

class NewRegisterOtpSrcState extends State<NewRegisterOtpSrc> {
  late double height;
  late double width;
  TextEditingController pinController = TextEditingController();
  // String lang, name, mobile, email, userId, otp;
  // NewRegisterOtpSrcState(
  //     this.lang, this.name, this.mobile, this.email, this.userId, this.otp);
  @override
  void initState() {
    super.initState();
    pinController.text = widget.otp;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 140),
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: Text(
              // MyString.otpVerificationMsg,
              "otpVerificationMsg".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 25,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            alignment: Alignment.center,
            child: Text(
              // MyString.OtpLbl,
              'OtpLbl'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          Container(
              child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: PinCodeTextField(
              autoDisposeControllers: false,
              controller: pinController,
              appContext: context,
              textStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontFamily: MyFont.roboto),
              length: 4,
              animationType: AnimationType.slide,
              errorTextDirection: TextDirection.rtl,
              errorTextSpace: 30,
              // validator: (v) {
              //   if (v!.length < 4) {
              //     return MyString.otpErrorMsg;
              //   } else if (pinController.text.trim() != ""){
              //     return MyString.otpErrorMsg;
              //   } else {
              //     return null;
              //   }
              // },
              pinTheme: PinTheme(
                borderWidth: 1,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 45,
                fieldWidth: width / 5,
                activeColor: MyColor.activeOtp,
                activeFillColor: MyColor.activeOtp,
                selectedColor: MyColor.selectedOtp,
                selectedFillColor: MyColor.selectedOtp,
                inactiveColor: MyColor.inactiveOtp,
                inactiveFillColor: MyColor.inactiveOtp,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: false,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                print("onCompletedonCompleted");
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          )),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              resendOtp(widget.userId);
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      // MyString.resendOtp,
                      'resendOtp'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColor.color1F140A,
                        fontSize: 14,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: MyWidget.getButtonWidgetWithStyle(
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium),
                // label: MyString.registerLbl,
                label: 'registerLbl'.tr,
                height: 45.0,
                width: width,
                onPressed: () {
                  // navigateToRegisterStep();
                  // if(pinController.text==""){
                  //
                  // }
                  // else{
                  verifyOtp(pinController.text, widget.userId);
                  // }
                }),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 40, right: 40),
            alignment: Alignment.center,
            child: Text(
              // MyString.otpMsg,
              'otpMsg'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // void verifyLoginOtp(user_id,otp) async {
  //   ArtistVerifyRegisterOtpRequest request = ArtistVerifyRegisterOtpRequest(
  //       user_id: int.parse(user_id), otp: int.parse(otp));
  //   ArtistVerifyLoginOtpResponse? response =
  //   await Repository.hitVerifyRegisterOtpApi(request);
  //   print("cccccc  "+response!.message.toString()+"  "+response.code.toString());
  //   if (response != null) {
  //     if (response.code == 200) {
  //       if (response.type == 'success') {
  //         Get.offAll(() => RegisterStepSrc(lang,name,mobile,email,user_id));
  //       }
  //     }
  //     else{
  //       Get.dialog(ErrorDialog(msg: response.message!),
  //           barrierDismissible: false);
  //     }
  //   }
  // }

  void verifyOtp(String otp, String userId) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    try {
      http.Response response = await post(
          Uri.parse(ApiConstants.artistVerifyLoginOtpApi),
          body: {'user_id': userId, 'otp': otp});
      var data = jsonDecode(response.body.toString());
      Get.back();

      if (data['code'] == 200) {
        navigateToRegisterStep();
        // Get.offAll(() => RegisterStepSrc(lang,name,mobile,email,user_id));
      } else if (data['code'] == 403) {
        Get.dialog(ErrorDialog(msg: data['message'].toString()),
            barrierDismissible: false);
      } else {
        String errorMsg = "";
        data['errors'].keys.forEach((key) {
          if (errorMsg == "") {
            errorMsg = data['errors'][key][0].toString();
          } else {
            errorMsg = "$errorMsg\n\n ${data['errors'][key][0]}";
          }
        });
        Get.dialog(ErrorDialog(msg: errorMsg), barrierDismissible: true);
      }
    } catch (e) {
      Get.back();
      print(e.toString());
      print("error232323 $e");
    }
  }

  void resendOtp(String userId) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    try {
      http.Response response =
          await post(Uri.parse(ApiConstants.resendOtpApi), body: {
        'user_id': userId,
      });
      var data = jsonDecode(response.body.toString());
      Get.back();

      if (data['code'] == 200) {
        String msg = data['message'].toString();
        String otp = data['data']['otp'].toString();
        pinController.text = otp;
        Get.dialog(ErrorDialog(msg: msg), barrierDismissible: false);
      } else {
        String msg = data['message'].toString();
        Get.dialog(ErrorDialog(msg: msg), barrierDismissible: false);
      }
    } catch (e) {
      Get.back();
      print(e.toString());
    }
  }

  void dismissMessage() {
    Get.back();
  }

  navigateToRegisterStep() async {
    Navigator.pop(context, true);
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegisterStepSrc(widget.lang, widget.name, widget.mobile,
          widget.email, widget.userId, "1");
    }));
  }
}
