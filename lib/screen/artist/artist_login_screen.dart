import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:upculture/controller/artist/artist_onboarding_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/register_src_new.dart';
// import 'package:upculture/screen/artist/registration_screen.dart';
import 'package:upculture/utils/my_style.dart';
import 'package:upculture/utils/my_widget.dart';

import '../../dialog/custom_progress_dialog.dart';
import '../../dialog/error_dialog.dart';
import '../../local_database/key_constants.dart';
import '../../network/api_constants.dart';
import 'package:http/http.dart' as http;

import 'artist_otp_screen.dart';

class ArtistLoginScreen extends StatefulWidget {
  const ArtistLoginScreen({Key? key}) : super(key: key);

  @override
  State<ArtistLoginScreen> createState() => _ArtistLoginScreenState();
}

class _ArtistLoginScreenState extends State<ArtistLoginScreen> {
  ArtistOnboardingController getXController =
      Get.put(ArtistOnboardingController());
  late double height;
  late double width;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreference.getInstance();
    getXController.getXController = getXController;
    getXController.loginFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Stack(children: [
            // SizedBox(
            //   height: height * 0.1,
            // ),

            // SizedBox(
            //   height: height * 0.1,
            // ),
            Positioned.fill(
              top: 100,
              bottom: 150,
              child: Form(
                key: getXController.loginFormKey,
                child: Container(
                  height: height * 0.5,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: const Color(0xFFE0E5EC),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 15,
                            // inset: true,
                            offset: Offset(1, 2)),
                        BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 15,
                            // inset: true,
                            offset: Offset(-1, -2))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: MyColor.appColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          // MyString.artistLogin,
                          'artLogin'.tr,

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MyColor.indiaWhite,
                            fontSize: 20,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.semiBold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // MyString.mobileNo,
                              'mobileNo'.tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.color4F4C4C,
                                fontSize: 14,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.regular,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      mobileNoField(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 30.0),
                        child: MyWidget.getButtonWidget(
                            // label: MyString.send,
                            label: 'send'.tr,
                            height: 40.0,
                            width: width,
                            onPressed: () {
                              // getXController.isLoginValid();
                              final form =
                                  getXController.loginFormKey.currentState;
                              if (form!.validate()) {
                                loginwithMobile(
                                    getXController.mobileController.text);
                              }
                            }),
                      ),
                      orWidget(),
                      const SizedBox(
                        height: 30,
                      ),
                      registrationWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 100,
              right: 100,
              child: Card(
                shape: CircleBorder(),
                elevation: 10,
                child: Image.asset(
                  "assets/images/up_gov_logo.png", height: 100,

                  // Width should be equal to height for a perfect circle
                  // Ensures the image covers the circle
                ),
              ),
            ),

          ]),
        ));
  }

  void loginwithMobile(String mobile) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    try {
      http.Response response =
          await post(Uri.parse(ApiConstants.artistLoginApi), body: {
        'mobile': mobile,
      });
      var data = jsonDecode(response.body.toString());
      Get.back();
      print("form_status111 $data");
      if (data['code'] == 200) {
        String userId = data['data']['user_id'].toString();
        MySharedPreference.setInt(KeyConstants.keyUserId, int.parse(userId));
        Get.to(() => ArtistOtpScreen(
            getXController: getXController,
            otp_value: data['data']['otp'].toString(),
            userId: userId));
      } else if (data['code'] == 404) {
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

  ///
  ///
  ///
  mobileNoField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: getXController.mobileController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        validator: (String? value) {
          return value == null || value.isEmpty
              ? MyString.enterMobileNo
              : value.length != 10
                  ? MyString.validMobileNo
                  : null;
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            // setState(() {});
            return null;
          }
        },
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        // Only n
        maxLength: 10,
        style: TextStyle(
            color: MyColor.color4F4C4C,
            fontSize: 14,
            fontFamily: MyFont.roboto,
            fontWeight: MyFontWeight.regular),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mobile_friendly_rounded),
          counterText: '',
          filled: true,
          fillColor: MyColor.colorFBE5D6,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: InputBorder.none,
          enabledBorder: MyStyle.inputFocusBorder(),
          disabledBorder: MyStyle.inputFocusBorder(),
          focusedBorder: MyStyle.inputFocusBorder(),
          errorBorder: MyStyle.inputErrorBorder(),
        ),
      ),
    );
  }

  ///
  ///
  ///
  orWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 1.0,
            color: MyColor.color4F4C4C,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              // MyString.or,
              'or'.tr,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 1.0,
            color: MyColor.color4F4C4C,
          )
        ],
      ),
    );
  }

  ///
  ///
  ///
  registrationWidget() {
    return InkWell(
      onTap: () {
        // Get.to(() => ArtistRegistrationScreen(getXController: getXController,));
        Get.to(() => const NewRegisterSrc(), transition: Transition.zoom);
      },
      child: Container(
        height: 40,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: MyColor.appColor)),
        child: Text(
          // MyString.register,
          'register'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColor.appColor,
            fontSize: 18,
            fontFamily: MyFont.roboto,
            fontWeight: MyFontWeight.regular,
          ),
        ),
      ),
    );
  }
}
