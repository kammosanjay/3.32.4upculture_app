import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:upculture/controller/artist/artist_onboarding_controller.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/register_step_src.dart';
import 'package:upculture/screen/common/lngCodee.dart';
import 'package:upculture/utils/my_widget.dart';
import 'package:http/http.dart' as http;
import '../../dialog/custom_progress_dialog.dart';
import '../../dialog/error_dialog.dart';
import '../../local_database/key_constants.dart';
import '../../local_database/my_shared_preference.dart';
import '../../network/api_constants.dart';
import 'artist_home_screen.dart';

class ArtistOtpScreen extends StatefulWidget {
  ArtistOnboardingController getXController;
  String otp_value, userId;

  ArtistOtpScreen(
      {Key? key,
      required this.getXController,
      required this.otp_value,
      required this.userId})
      : super(key: key);

  @override
  State<ArtistOtpScreen> createState() => _ArtistOtpScreenState();
}

class _ArtistOtpScreenState extends State<ArtistOtpScreen> {
  late ArtistOnboardingController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
    getXController.otpController.clear();
    getXController.enteredOtp.value = '';
    getXController.otpController.text = widget.otp_value;
    getXController.otpFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Form(
        key: getXController.otpFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MyColor.appColor)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // MyString.enterOtp,
                    'otpVerificationMsg'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColor.color1F140A,
                      fontSize: 22,
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.regular,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.030),
                    child: otpField(),
                  ),
                  MyWidget.getButtonWidget(
                      // label: MyString.sendOtp,
                      label: 'send'.tr,
                      onPressed: () {
                        // getXController.isOtpValidate();
                        // final form = getXController.otpFormKey.currentState;
                        // if(form!.validate()){
                        //
                        // }
                        verifyOtp(
                            getXController.otpController.text, widget.userId);
                      },
                      height: 40.0,
                      width: width),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
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
        getXController.otpController.text = otp;
        getXController.loginResponseOtp.value = otp;
        Get.dialog(ErrorDialog(msg: msg), barrierDismissible: false);
      } else {
        String msg = data['message'].toString();
        Get.dialog(ErrorDialog(msg: msg), barrierDismissible: false);
      }
    } catch (e) {
      Get.back();
      print(e.toString());
      print("error232323 $e");
    }
  }

  ///
  ///
  ///
  otpField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: PinCodeTextField(
        autoDisposeControllers: false,
        controller: getXController.otpController,
        appContext: context,
        textStyle: const TextStyle(
            fontSize: 16.0, color: Colors.black, fontFamily: MyFont.roboto),
        length: 4,
        animationType: AnimationType.slide,
        errorTextDirection: TextDirection.rtl,
        errorTextSpace: 30,
        // validator: (v) {
        //   print(getXController.otpController.text);
        //   print(getXController.loginResponseOtp.value);
        //   if (v!.length < 4) {
        //     return MyString.otpErrorMsg;
        //   } else if (getXController.otpController.text.trim() != getXController.loginResponseOtp.value){
        //     return MyString.otpErrorMsg;
        //   } else {
        //     return null;
        //   }
        // },
        pinTheme: PinTheme(
          borderWidth: 1,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 40,
          fieldWidth: 40,
          activeColor: MyColor.activeOtp,
          activeFillColor: MyColor.activeOtp,
          selectedColor: MyColor.selectedOtp,
          selectedFillColor: MyColor.selectedOtp,
          inactiveColor: MyColor.inactiveOtp,
          inactiveFillColor: MyColor.inactiveOtp,
        ),
        cursorColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        errorAnimationController: getXController.errorController,
        onCompleted: (v) {
          getXController.enteredOtp.value = v;
          log('OtpVerification Value : $v');
          log('OtpVerification EnteredOtp : ${getXController.enteredOtp.value}');
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  void verifyOtp(String otp, String userId) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    try {
      http.Response response = await post(
          Uri.parse(ApiConstants.artistVerifyLoginOtpApi),
          body: {'user_id': userId, 'otp': otp});
      var data = jsonDecode(response.body.toString());
      Get.back();
      print("form_status1111 $data");
      if (data['code'] == 200) {
        if (data['data']['form_status'].toString() == "3") {
          MySharedPreference.setBool(KeyConstants.keyIsLogin, true);
          Get.offAll(() => ArtistHomeScreen(
                callFrom: 'Artist',
                lang: MyLangCode.langcode,
                
              ),
              
              );
        } else {
          Get.offAll(() => RegisterStepSrc(
              data['data']['language'].toString(),
              data['data']['name'].toString(),
              data['data']['mobile'].toString(),
              data['data']['email'].toString(),
              data['data']['id'].toString(),
              data['data']['form_status'].toString()));
        }
        // MySharedPreference.setBool(KeyConstants.keyIsLogin, true);
        // // Get.offAll(() => const ArtistProfileScreen());
        // Get.offAll(() => ArtistHomeScreen(
        //   callFrom: 'Artist',
        // ));
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
    }
  }
}
