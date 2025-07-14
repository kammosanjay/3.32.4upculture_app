import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:upculture/screen/common/lngCodee.dart';

import '../../controller/artist/artist_onboarding_controller.dart';
import '../../dialog/custom_progress_dialog.dart';
import '../../dialog/error_dialog.dart';
import '../../local_database/key_constants.dart';
import '../../local_database/my_shared_preference.dart';

import '../../network/api_constants.dart';

import '../../resources/my_color.dart';
import '../../resources/my_font.dart';
import '../../resources/my_font_weight.dart';
import '../../resources/my_string.dart';
import '../../utils/my_style.dart';
import '../../utils/my_widget.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'artist_home_screen.dart';

// ignore: must_be_immutable
class RegisterStepSrc extends StatefulWidget {
  String lang_hold, name_hold, mobile_hold, email_hold, user_id, form_status;

  RegisterStepSrc(this.lang_hold, this.name_hold, this.mobile_hold,
      this.email_hold, this.user_id, this.form_status,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterStepSrcState(
        lang_hold, name_hold, mobile_hold, email_hold, user_id, form_status);
  }
}

class RegisterStepSrcState extends State<RegisterStepSrc> {
  ArtistOnboardingController getXController =
      Get.put(ArtistOnboardingController());
  late double height;
  late double width;
  List<String> genderArr = [];
  String? gendervalue;
  List<String> workExperienceArr = [];
  String? workExperienceValue;
  List<String> dateArr = [];
  String? dateValue;
  List<String> monthArr = [];
  String? monthValue;
  List<String> yearArr = [];
  String? yearValue;
  List<String> gradArr = [];
  String? gradValue;
  List<String> genreArr = [];
  String? genreValue;
  List<String> genreAreaArr = [];
  String? genreAreaValue;
  List<String> awardLevelArr = [];
  String? awardLevelValue;
  List<String> distArr = [];
  String? distValue;
  String step = "1";
  String lang_hold, name_hold, mobile_hold, email_hold, user_id, form_status;

  RegisterStepSrcState(this.lang_hold, this.name_hold, this.mobile_hold,
      this.email_hold, this.user_id, this.form_status);

  var saveProfileData;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  File? profileImage, trainingSertiImage, gradImage;
  List<File> artistImgList = [];
  String profimg_valid = "false";

  TextEditingController teamMemberController = TextEditingController();
  TextEditingController artistPriceController = TextEditingController();
  TextEditingController presentationController = TextEditingController();
  TextEditingController artistKnowController1 = TextEditingController();
  TextEditingController artistKnowController2 = TextEditingController();
  TextEditingController artistKnowController3 = TextEditingController();
  TextEditingController artistKnowController4 = TextEditingController();
  TextEditingController artistKnowController5 = TextEditingController();
  TextEditingController artistKnowController6 = TextEditingController();
  TextEditingController auditionLinkController = TextEditingController();
  TextEditingController otherAchievementsController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController facebookLinkController = TextEditingController();
  TextEditingController instaLinkController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<bool> isSelectedGenreArea = [];
  List<String> isSelectedGenreAreaStr = [];
  List<List<bool>> isSelectedGenreSubArea = [];
  List<List<String>> isSelectedGenreSubAreaStr = [];
  List<String> allSubAreaName = [];
  String training_certificate = "", grade_certificate = "";
  String artistPhotoListStr = "";
  String area_of_art_get_data = "";
  String sub_area_of_art_get_data = "";

  @override
  void initState() {
    super.initState();
    getDroupDownListStep1();
    getDroupDownListStep2();
    print("5trfvc $form_status");
    setState(() {
      step = form_status.toString();
    });
    // if(form_status!="1"){
    //   getUserDetails(user_id);
    // }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 40,
                color: MyColor.lightGreen,
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (step == "1") {
                          SystemNavigator.pop();
                        } else if (step == "2") {
                          setState(() {
                            step = "1";
                          });
                        } else {
                          setState(() {
                            step = "2";
                          });
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(right: 15),
                        child: const Icon(
                          Icons.keyboard_arrow_left_rounded,
                          color: MyColor.green,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/edit_pen_img.png",
                      height: 15,
                      width: 15,
                      fit: BoxFit.fill,
                      color: MyColor.green,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          step == "1"
                              ? MyString.registerStep1TopMsg
                              : step == "2"
                                  ? "Step 1 is completed, Please complete step 2"
                                  : "Step 2 is completed, Please complete step 3",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColor.green,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        "assets/images/close_img.png",
                        height: 20,
                        width: 20,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Text(
                  "Artists e-application for cultural programs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColor.appColor,
                    fontSize: 14,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_bold,
                  ),
                ),
              ),
              Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 30),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: width,
                        height: 2,
                        color: MyColor.lineColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                                color: MyColor.appColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35))),
                            child: Text(
                              "Step 1",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: step == "2" || step == "3"
                                    ? MyColor.appColor
                                    : MyColor.darkAppColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35))),
                            child: Text(
                              "Step 2",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: step == "3"
                                    ? MyColor.appColor
                                    : MyColor.darkAppColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35))),
                            child: Text(
                              "Step 3",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 170),
            child: step == "1"
                ? step1()
                : step == "2"
                    ? step2()
                    : step3(),
          ),
        ],
      ),
    ));
  }

  step1() {
    return Form(
      key: _formKey1,
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          Container(
            child: Text(
              // MyString.personalDetailsLbl,
              'personalDetailsLbl'.tr,
              style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(
              // "कलाकार अपनी फ़ोटो जोड़ें",
              'artPhoto'.tr,
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
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: MyColor.appColor, width: 1)),
            child: GestureDetector(
                onTap: () {
                  getImageGallery("profile");
                },
                child: profileImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/cloud_upload_img.png",
                            height: 25,
                            width: 25,
                            color: MyColor.appBlue,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              "Drag and drop here\n or",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColor.color4F4C4C,
                                fontSize: 10,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Browse",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyColor.appBlue,
                                fontSize: 10,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Image.file(
                          profileImage!,
                          width: 110,
                          fit: BoxFit.fill,
                        ),
                      )),
          ),
          Visibility(
            visible: profimg_valid == "true",
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(
                MyString.selectProfileImage,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_regular,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.artistNameLbl,
              'artistNameLbl'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              return value == null || value.isEmpty ? MyString.enterName : null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: nameController..text = name_hold,
            onChanged: (value) {
              name_hold = value;
            },
            style: TextStyle(
              color: MyColor.color4F4C4C,
              fontSize: 12,
              fontFamily: MyFont.poppins,
              fontWeight: MyFontWeight.poppins_medium,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.mobileNo,
              'mobileNo'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          TextFormField(
            controller: mobileController..text = mobile_hold,
            onChanged: (value) {
              mobile_hold = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              return value == null || value.isEmpty
                  ? MyString.enterMobileNo
                  : value.length != 10
                      ? MyString.validMobileNo
                      : null;
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
              fontSize: 12,
              fontFamily: MyFont.poppins,
              fontWeight: MyFontWeight.poppins_medium,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.address,
              'Address'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              return value == null || value.isEmpty
                  ? MyString.enterAddress
                  : null;
            },
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: addressController,
            onChanged: (value) {},
            style: TextStyle(
              color: MyColor.color4F4C4C,
              fontSize: 12,
              fontFamily: MyFont.poppins,
              fontWeight: MyFontWeight.poppins_medium,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.dob,
              'dob'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColor.appColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Date",
                            style: TextStyle(
                              color: MyColor.color4F4C4C,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          value: dateValue == null
                              ? null
                              : dateValue == ""
                                  ? null
                                  : dateValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: dateArr.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                  color: MyColor.color4F4C4C,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dateValue = newValue!;
                            });
                          },
                        ),
                      )),
                  Visibility(
                    visible: dateValue == "",
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        "तारीख़ चुनें",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_regular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColor.appColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Months",
                            style: TextStyle(
                              color: MyColor.color4F4C4C,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          value: monthValue == null
                              ? null
                              : monthValue == ""
                                  ? null
                                  : monthValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: monthArr.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                  color: MyColor.color4F4C4C,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              monthValue = newValue!;
                            });
                          },
                        ),
                      )),
                  Visibility(
                    visible: monthValue == "",
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        "महीना चुनिए",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_regular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColor.appColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text(
                            "Years",
                            style: TextStyle(
                              color: MyColor.color4F4C4C,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          value: yearValue == null
                              ? null
                              : yearValue == ""
                                  ? null
                                  : yearValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: yearArr.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                  color: MyColor.color4F4C4C,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              yearValue = newValue!;
                            });
                          },
                        ),
                      )),
                  Visibility(
                    visible: yearValue == "",
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        "वर्ष चुनें",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_regular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.email,
              'email'.tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
            ),
          ),
          TextFormField(
            controller: emailController..text = email_hold,
            onChanged: (value) {
              email_hold = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              return value == null || value.isEmpty
                  ? MyString.enterEmail
                  : !EmailValidator.validate(emailController.text.trim())
                      ? MyString.enterValidEmail
                      : null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: MyColor.color4F4C4C,
              fontSize: 12,
              fontFamily: MyFont.poppins,
              fontWeight: MyFontWeight.poppins_medium,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.gender,
              'gender'.tr,
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
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColor.appColor, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: gendervalue == null
                      ? null
                      : gendervalue == ""
                          ? null
                          : gendervalue,
                  hint: Text(
                    "Gender",
                    style: TextStyle(
                      color: MyColor.color4F4C4C,
                      fontSize: 12,
                      fontFamily: MyFont.poppins,
                      fontWeight: MyFontWeight.poppins_medium,
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: genderArr.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                          color: MyColor.color4F4C4C,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      gendervalue = newValue!;
                    });
                  },
                ),
              )),
          Visibility(
            visible: gendervalue == "",
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 10),
              child: Text(
                'gender'.tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_regular,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              // MyString.workExperience,
              'workExperience'.tr,
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
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColor.appColor, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text(
                    "Experience".tr,
                    style: TextStyle(
                      color: MyColor.color4F4C4C,
                      fontSize: 12,
                      fontFamily: MyFont.poppins,
                      fontWeight: MyFontWeight.poppins_medium,
                    ),
                  ),
                  value: workExperienceValue == null
                      ? null
                      : workExperienceValue == ""
                          ? null
                          : workExperienceValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: workExperienceArr.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                          color: MyColor.color4F4C4C,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      workExperienceValue = newValue!;
                    });
                  },
                ),
              )),
          Visibility(
            visible: workExperienceValue == "",
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 10),
              child: Text(
                'workExperience'.tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_regular,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: MyWidget.getButtonWidgetWithStyle(
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium),
                // label: MyString.nextPage,
                label: 'nextPage'.tr,
                height: 45.0,
                width: width,
                onPressed: () {
                  setState(() {
                    String validStatus = "0";
                    // step="2";
                    final form = _formKey1.currentState;
                    if (dateValue == null || dateValue == "") {
                      dateValue = "";
                      validStatus = "1";
                    }
                    if (monthValue == null || monthValue == "") {
                      monthValue = "";
                      validStatus = "1";
                    }
                    if (yearValue == null || yearValue == "") {
                      yearValue = "";
                      validStatus = "1";
                    }
                    if (gendervalue == null || gendervalue == "") {
                      gendervalue = "";
                      validStatus = "1";
                    }
                    if (workExperienceValue == null ||
                        workExperienceValue == "") {
                      workExperienceValue = "";
                      validStatus = "1";
                    }
                    setState(() {});
                    if (form!.validate()) {
                      String name = nameController.text;
                      String email = emailController.text;
                      String mobile = mobileController.text;
                      String address = addressController.text;
                      if (validStatus == "0") {
                        if (profimg_valid == "") {
                          // print("445rrrr "+user_id);
                          updateProfileStep1(
                              user_id,
                              name,
                              mobile,
                              dateValue!,
                              monthValue!,
                              yearValue!,
                              email,
                              gendervalue!,
                              workExperienceValue!,
                              profileImage!.path,
                              address);
                        } else {
                          profimg_valid = "true";
                        }
                      }
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }

  step2() {
    String gradeName = "",
        vidhaName = "",
        awardName = "",
        districtsName = "",
        teamMember = "",
        proposedRemuneration = "",
        seniorArtistName1 = "",
        seniorArtistDesignation1 = "",
        seniorArtistMobileNumber1 = "",
        seniorArtistName2 = "",
        seniorArtistDesignation2 = "",
        seniorArtistMobileNumber2 = "",
        auditionLink = "",
        otherInfo = "",
        // artistPhoto = "",
        youtubeLink = "",
        facebookLink = "",
        instagramLink = "",
        artistCostPrice = "";
    return Form(
        key: _formKey2,
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0, bottom: 4),
              child: Text(
                'akashwadi'.tr,
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.appColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      'SelectGrade'.tr,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    // value: gradValue == null
                    //     ? null
                    //     : gradValue == ""
                    //         ? null
                    //         : gradValue,
                      value: gradArr.contains(gradValue) ? gradValue : null,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: gradArr.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        gradValue = newValue!;
                      });
                    },
                  ),
                )),
            Visibility(
              visible: gradValue == "",
              child: Container(
                margin: const EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  "श्रेणी का चयन करें",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_regular,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'genre'.tr,
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.appColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      'Select Genre'.tr,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    // value: genreValue == null
                    //     ? null
                    //     : genreValue == ""
                    //         ? null
                    //         : genreValue,
                    value: genreArr.contains(genreValue) ? genreValue : null,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genreArr.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        genreValue = newValue!;
                        print(genreValue);
                        genreAreaArr = [];

                        print(genreArr);
                      });
                      getArtOfArea(newValue!);
                    },
                  ),
                )),

            // commented for genre value

            // Visibility(
            //   visible: genreValue == "",
            //   child: Container(
            //     margin: const EdgeInsets.only(top: 5, left: 10),
            //     child: Text(
            //       "विधा का नाम चयन करें",
            //       textAlign: TextAlign.left,
            //       style: TextStyle(
            //         color: Colors.red,
            //         fontSize: 10,
            //         fontFamily: MyFont.poppins,
            //         fontWeight: MyFontWeight.poppins_regular,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'genreArea'.tr,
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
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColor.appColor, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              // genreAreaValue
              // genreAreaArr
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  itemCount: genreAreaArr.length,
                  itemBuilder: (contex, index1) {
                    if (genreAreaArr.length != isSelectedGenreArea.length) {
                      isSelectedGenreArea.add(false);
                      if (area_of_art_get_data != "") {
                        List<String> artAreaList =
                            area_of_art_get_data.split(",");
                        for (int k = 0; k < artAreaList.length; k++) {
                          if (artAreaList[k].trim() ==
                              genreAreaArr[index1].trim()) {
                            isSelectedGenreAreaStr.add(artAreaList[k].trim());
                            isSelectedGenreArea[index1] = true;
                          }
                        }
                        // if(sub_area_of_art_get_data!=""){
                        //
                        // }
                      }

                      List<bool> booList = [];
                      isSelectedGenreSubArea.add(booList);
                    }
                    // getArtOfSubArea()
                    return Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                // Example with tristate
                                value: isSelectedGenreArea[index1],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    isSelectedGenreArea[index1] = newValue!;
                                    if (isSelectedGenreAreaStr
                                        .contains(genreAreaArr[index1])) {
                                      isSelectedGenreAreaStr
                                          .remove(genreAreaArr[index1]);
                                    } else {
                                      isSelectedGenreAreaStr
                                          .add(genreAreaArr[index1]);
                                    }
                                  });
                                },
                              ),
                              Text(
                                genreAreaArr[index1],
                                style: TextStyle(
                                  color: MyColor.color4F4C4C,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: isSelectedGenreArea[index1]
                              ? FutureBuilder(
                                  future: getArtOfSubArea(genreAreaArr[index1]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.hasData) {
                                      List? subAreaData;
                                      if (snapshot.data.toString() != "") {
                                        subAreaData = snapshot.data as List;
                                      }

                                      return snapshot.data.toString() != ""
                                          ? ListView.builder(
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics: const ScrollPhysics(),
                                              itemCount: subAreaData!.length,
                                              itemBuilder: (contex, index) {
                                                if (isSelectedGenreSubArea[
                                                            index1]
                                                        .length !=
                                                    subAreaData!.length) {
                                                  isSelectedGenreSubArea[index1]
                                                      .add(false);
                                                  if (sub_area_of_art_get_data !=
                                                      "") {
                                                    // print("trvcxdcs11 "+sub_area_of_art_get_data);
                                                    List<String> artAreaList =
                                                        sub_area_of_art_get_data
                                                            .split(",");
                                                    for (int k = 0;
                                                        k < artAreaList.length;
                                                        k++) {
                                                      // print("trvcxdcs "+artAreaList[k].trim()+"  "+subAreaData[index]['name'].trim());
                                                      if (artAreaList[k]
                                                              .trim() ==
                                                          subAreaData[index]
                                                                  ['name']
                                                              .trim()) {
                                                        allSubAreaName.add(
                                                            artAreaList[k]
                                                                .trim());
                                                        isSelectedGenreSubArea[
                                                                index1][index] =
                                                            true;
                                                      }
                                                    }
                                                    // if(sub_area_of_art_get_data!=""){
                                                    //
                                                    // }
                                                  }
                                                }

                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Checkbox(
                                                            // Example with tristate
                                                            value:
                                                                isSelectedGenreSubArea[
                                                                        index1]
                                                                    [index],
                                                            onChanged: (bool?
                                                                newValue) {
                                                              setState(() {
                                                                isSelectedGenreSubArea[
                                                                            index1]
                                                                        [
                                                                        index] =
                                                                    newValue!;
                                                                if (allSubAreaName.contains(
                                                                    subAreaData![
                                                                            index]
                                                                        [
                                                                        'name'])) {
                                                                  allSubAreaName.remove(
                                                                      subAreaData[
                                                                              index]
                                                                          [
                                                                          'name']);
                                                                } else {
                                                                  allSubAreaName.add(
                                                                      subAreaData[
                                                                              index]
                                                                          [
                                                                          'name']);
                                                                }
                                                                // if(isSelectedGenreSubAreaStr[index1].contains(subAreaData[index]['name'])){
                                                                //   isSelectedGenreSubAreaStr[index1].remove(subAreaData[index]['name']);
                                                                // }
                                                                // else{
                                                                //   isSelectedGenreSubAreaStr[index1].add(subAreaData[index]['name']);
                                                                // }
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            subAreaData[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                              color: MyColor
                                                                  .color4F4C4C,
                                                              fontSize: 12,
                                                              fontFamily: MyFont
                                                                  .poppins,
                                                              fontWeight:
                                                                  MyFontWeight
                                                                      .poppins_medium,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              })
                                          : Container();
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              : null,
                        )
                      ],
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'Artist Price'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: artistPriceController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                return value == null || value.isEmpty
                    ? "कृपया दर्ज करेंं"
                    : null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                "presentaionLvl".tr,
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.appColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      'Select'.tr,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    // value: awardLevelValue == null
                    //     ? null
                    //     : awardLevelValue == ""
                    //         ? null
                    //         : awardLevelValue,
                    value: awardLevelArr.contains(awardLevelValue)
                        ? awardLevelValue
                        : null,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: awardLevelArr.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        awardLevelValue = newValue!;
                      });
                    },
                  ),
                )),
            Visibility(
              visible: awardLevelValue == "",
              child: Container(
                margin: const EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  "पुरस्कार का नाम चयन करें",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_regular,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                "district".tr,
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.appColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                      'Select'.tr,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    // value: distValue == null
                    //     ? null
                    //     : distValue == ""
                    //         ? null
                    //         : distValue,
                    value: distArr.contains(distValue) ? distValue : null,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: distArr.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        distValue = newValue!;
                      });
                    },
                  ),
                )),
            Visibility(
              visible: distValue == "",
              child: Container(
                margin: const EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  "जिले का नाम चयन करें",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_regular,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'membersNo'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: teamMemberController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              validator: (String? value) {
                return value == null || value.isEmpty
                    ? "कृपया दल में सदस्यों की संख्या दर्ज करेंं"
                    : null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'presentatoinfee'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: presentationController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                return value == null || value.isEmpty
                    ? "कृपया आपकी प्रस्तुति दर्ज करेंं"
                    : null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'relativesNames'.tr,
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
              child: TextFormField(
                controller: artistKnowController1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return value == null || value.isEmpty
                      ? "कृपया वरिष्ठ कलाकार या राजपत्रित अधिकारी का नाम दर्ज करेंं"
                      : null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  hintText: 'name'.tr,
                  border: InputBorder.none,
                  enabledBorder: MyStyle.inputFocusBorder(),
                  disabledBorder: MyStyle.inputFocusBorder(),
                  focusedBorder: MyStyle.inputFocusBorder(),
                  errorBorder: MyStyle.inputErrorBorder(),
                  focusedErrorBorder: MyStyle.inputErrorBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: artistKnowController2,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return value == null || value.isEmpty
                      ? "कृपया वरिष्ठ कलाकार या राजपत्रित अधिकारी का पदनाम दर्ज करेंं"
                      : null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  // hintText: "पदनाम",
                  hintText: 'subname'.tr,
                  border: InputBorder.none,
                  enabledBorder: MyStyle.inputFocusBorder(),
                  disabledBorder: MyStyle.inputFocusBorder(),
                  focusedBorder: MyStyle.inputFocusBorder(),
                  errorBorder: MyStyle.inputErrorBorder(),
                  focusedErrorBorder: MyStyle.inputErrorBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: artistKnowController3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return value == null || value.isEmpty
                      ? MyString.enterMobileNo
                      : value.length != 10
                          ? MyString.validMobileNo
                          : null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
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
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  // hintText: MyString.mobileNo,
                  hintText: 'mobileNo'.tr,
                  border: InputBorder.none,
                  enabledBorder: MyStyle.inputFocusBorder(),
                  disabledBorder: MyStyle.inputFocusBorder(),
                  focusedBorder: MyStyle.inputFocusBorder(),
                  errorBorder: MyStyle.inputErrorBorder(),
                  focusedErrorBorder: MyStyle.inputErrorBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                "(II)",
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
              child: TextFormField(
                controller: artistKnowController4,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return value == null || value.isEmpty
                      ? "कृपया वरिष्ठ कलाकार या राजपत्रित अधिकारी का नाम दर्ज करेंं"
                      : null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  // hintText: "नाम",
                  hintText: 'name'.tr,
                  border: InputBorder.none,
                  enabledBorder: MyStyle.inputFocusBorder(),
                  disabledBorder: MyStyle.inputFocusBorder(),
                  focusedBorder: MyStyle.inputFocusBorder(),
                  errorBorder: MyStyle.inputErrorBorder(),
                  focusedErrorBorder: MyStyle.inputErrorBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: artistKnowController5,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return value == null || value.isEmpty
                      ? "कृपया वरिष्ठ कलाकार या राजपत्रित अधिकारी का पदनाम दर्ज करेंं"
                      : null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  // hintText: "पदनाम",
                  hintText: 'subname'.tr,
                  border: InputBorder.none,
                  enabledBorder: MyStyle.inputFocusBorder(),
                  disabledBorder: MyStyle.inputFocusBorder(),
                  focusedBorder: MyStyle.inputFocusBorder(),
                  errorBorder: MyStyle.inputErrorBorder(),
                  focusedErrorBorder: MyStyle.inputErrorBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: artistKnowController6,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  return value == null || value.isEmpty
                      ? MyString.enterMobileNo
                      : value.length != 10
                          ? MyString.validMobileNo
                          : null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {});
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
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  hintText: 'mobileNo'.tr,
                  border: InputBorder.none,
                  enabledBorder: MyStyle.inputFocusBorder(),
                  disabledBorder: MyStyle.inputFocusBorder(),
                  focusedBorder: MyStyle.inputFocusBorder(),
                  errorBorder: MyStyle.inputErrorBorder(),
                  focusedErrorBorder: MyStyle.inputErrorBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'trainingCerti'.tr,
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
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: MyColor.appColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      getDocuments("training");
                    },
                    child: Container(
                      height: 44,
                      width: 140,
                      margin: const EdgeInsets.only(right: 10, left: 2),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: MyColor.appBlue,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/cloud_upload_img.png",
                            height: 15,
                            width: 15,
                            color: Colors.white,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Text(
                              "Choose File",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            trainingSertiImage != null
                                ? (trainingSertiImage!.path).split("/").last
                                : training_certificate.isNotEmpty
                                    ? (training_certificate).split("/").last
                                    : "No file chosen",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                        ),
                        if (trainingSertiImage != null ||
                            training_certificate.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                trainingSertiImage = null;
                                training_certificate =
                                    ""; // Clear the selected file
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'doordarshan/airCerti'.tr,
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
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: MyColor.appColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      getDocuments("grade");
                    },
                    child: Container(
                      height: 44,
                      width: 140,
                      margin: const EdgeInsets.only(right: 10, left: 2),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: MyColor.appBlue,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/cloud_upload_img.png",
                            height: 15,
                            width: 15,
                            color: Colors.white,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Text(
                              "Choose File",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            gradImage != null
                                ? (gradImage!.path).split("/").last
                                : grade_certificate.isNotEmpty
                                    ? (grade_certificate).split("/").last
                                    : "No file chosen",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                        ),
                        if (gradImage != null || grade_certificate.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                gradImage = null;
                                grade_certificate =
                                    ""; // Clear the selected file
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'auditionLink'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: auditionLinkController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'twohundredwords'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: otherAchievementsController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                return value == null || value.isEmpty
                    ? "कृपया उपलब्धियां दर्ज करें"
                    : null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                'presentFivePhoto'.tr,
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
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: MyColor.appColor, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // getImageGallery("preject");
                      getImageGall();
                    },
                    child: Container(
                        height: 44,
                        width: 140,
                        margin: const EdgeInsets.only(right: 10, left: 2),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: MyColor.appBlue,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/cloud_upload_img.png",
                              height: 15,
                              width: 15,
                              color: Colors.white,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              child: Text(
                                "Choose File",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      child: Text(
                    artistImgList.isNotEmpty
                        ? "${artistImgList.length} File Selected"
                        : artistPhotoListStr != ""
                            ? "$artistPhotoListStr File Selected"
                            : "No file choosen",
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: MyFont.poppins,
                      fontWeight: MyFontWeight.poppins_medium,
                    ),
                  ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                "youtubeLink".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: videoLinkController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                hintText: "youtubeLink".tr,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                "facebookLink".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: facebookLinkController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                hintText: "facebookLink".tr,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                "instagramLink".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),
            TextFormField(
              controller: instaLinkController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 12,
                fontFamily: MyFont.poppins,
                fontWeight: MyFontWeight.poppins_medium,
              ),
              decoration: InputDecoration(
                hintText: "instagramLink".tr,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: MyWidget.getButtonWidgetWithStyle(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: MyFont.poppins,
                      fontWeight: MyFontWeight.poppins_medium),
                  // label: MyString.nextPage,
                  label: 'nextPage'.tr,
                  height: 45.0,
                  width: width,
                  onPressed: () {
                    String trainingCertificate1 = "", gradeCertificate1 = "";
                    // setState(() {
                    //   step="3";
                    // });
                    String areaOfArt = "";
                    String subAreaOfArt = "";
                    if (isSelectedGenreAreaStr.isNotEmpty) {
                      areaOfArt = isSelectedGenreAreaStr.toString();
                      areaOfArt = areaOfArt.replaceAll("[", "");
                      areaOfArt = areaOfArt.replaceAll("]", "");
                    }
                    if (allSubAreaName.isNotEmpty) {
                      subAreaOfArt = allSubAreaName.toString();
                      subAreaOfArt = subAreaOfArt.replaceAll("[", "");
                      subAreaOfArt = subAreaOfArt.replaceAll("]", "");
                    }
                    // print("areaName@@: "+isSelectedGenreAreaStr.toString()+"  SubAresName@@: "+allSubAreaName.toString());
                    String vailidStatus = "0";
                    if (gradValue == null || gradValue == "") {
                      gradValue = "";
                      vailidStatus = "1";
                    }
                    if (genreValue == null || genreValue == "") {
                      genreValue = "";
                      vailidStatus = "1";
                    }
                    if (awardLevelValue == null || awardLevelValue == "") {
                      awardLevelValue = "";
                      vailidStatus = "1";
                    }
                    if (distValue == null || distValue == "") {
                      distValue = "";
                      vailidStatus = "1";
                    }
                    setState(() {});

                    final form = _formKey2.currentState;
                    if (form!.validate()) {
                      if (vailidStatus == "0") {
                        // print("a444444");
                        setState(() {
                          gradeName = gradValue!;
                          vidhaName = genreValue!;
                          // area_of_art="";

                          awardName = awardLevelValue!;
                          districtsName = distValue!;
                          teamMember = teamMemberController.text;
                          proposedRemuneration = presentationController.text;
                          artistCostPrice = artistPriceController.text;
                          seniorArtistName1 = artistKnowController1.text;
                          seniorArtistDesignation1 = artistKnowController2.text;
                          seniorArtistMobileNumber1 =
                              artistKnowController3.text;
                          seniorArtistName2 = artistKnowController4.text;
                          seniorArtistDesignation2 = artistKnowController5.text;
                          seniorArtistMobileNumber2 =
                              artistKnowController6.text;

                          if (trainingSertiImage != null) {
                            training_certificate = trainingSertiImage!.path;
                            trainingCertificate1 = trainingSertiImage!.path;
                          }

                          if (gradImage != null) {
                            grade_certificate = gradImage!.path;
                            gradeCertificate1 = gradImage!.path;
                          }

                          auditionLink = auditionLinkController.text;
                          otherInfo = otherAchievementsController.text;
                          youtubeLink = videoLinkController.text;
                          facebookLink = facebookLinkController.text;
                          instagramLink = instaLinkController.text;

                          updateProfileStep2(
                            user_id,
                            gradeName,
                            vidhaName,
                            areaOfArt,
                            subAreaOfArt,
                            awardName,
                            districtsName,
                            teamMember,
                            proposedRemuneration,
                            artistCostPrice,
                            seniorArtistName1,
                            seniorArtistDesignation1,
                            seniorArtistMobileNumber1,
                            seniorArtistName2,
                            seniorArtistDesignation2,
                            seniorArtistMobileNumber2,
                            trainingCertificate1,
                            gradeCertificate1,
                            auditionLink,
                            otherInfo,
                            artistImgList,
                            youtubeLink,
                            facebookLink,
                            instagramLink,
                          );
                        });
                      }
                    }
                  }),
            ),
          ],
        ));
  }

  step3() {
    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        Container(
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: MyColor.appColor,
              border: Border.all(color: MyColor.appColor, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              children: [
                // image:profileImage!=null?FileImage(profileImage!):AssetImage("assets/images/user_img.png"),
                profileImage != null
                    ? Container(
                        width: 80.0,
                        height: 80.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: FileImage(profileImage!),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        ),
                      )
                    : Container(
                        width: 80.0,
                        height: 80.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/user_img.png"),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image_edit_img.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: const Color(0xffF6F6F6),
              border: Border.all(color: const Color(0xff50cdcdcd), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(children: [
                      Text(
                        "1. ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Artist Name'.tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      saveProfileData['name'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                  ))
                ],
              )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "2. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "Address".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          saveProfileData['address'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "3. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "dob".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['date']}/${saveProfileData['month']}/${saveProfileData['year']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "4. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "gender".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['gender']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "5. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "workExperience".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['experience']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "6. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "mobileNo".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['mobile_number']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "7. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "email".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['email_id']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "8. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "goToWebsite".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "not available".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "9. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "vidharupName".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['vidha_name']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "9.(1) ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "price".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['cost']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "10. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "genreArea".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['area_of_art']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "11. ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                "akashwadi".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['grade_name']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "12. ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                "presentaionLvl".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['presentation_level']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Text(
                            "13. ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                          Container(
                            child: Text(
                              "district".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: MyColor.darkGrey,
                                fontSize: 12,
                                fontFamily: MyFont.poppins,
                                fontWeight: MyFontWeight.poppins_medium,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['districts_name']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "14. ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                "membersNo".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              )),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['team_member']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "15. ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                "presentatoinfee".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: MyColor.darkGrey,
                                  fontSize: 12,
                                  fontFamily: MyFont.poppins,
                                  fontWeight: MyFontWeight.poppins_medium,
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${saveProfileData['proposed_remuneration']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.color4F4C4C,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ))
                    ],
                  )),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "16. ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "relativesNames".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "(I) ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "varisthkalakar".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  "${saveProfileData['senior_artist_name1']}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "(II) ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "varisthsubname".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  "${saveProfileData['senior_artist_designation1']}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "(III) ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "mobileNo".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  "${saveProfileData['senior_artist_mobile_number1']}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "2",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "(I) ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "varisthkalakar".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 35),
                child: Text(
                  "${saveProfileData['senior_artist_name2']}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "(II) ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "varisthsubname".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  "${saveProfileData['senior_artist_designation2']}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "(III) ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "mobileNo".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  "${saveProfileData['senior_artist_mobile_number2']}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "17. ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: MyColor.darkGrey,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "trainingCerti".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                    ),
                    Expanded(
                        child: saveProfileData['training_certificate'] != ""
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Colors.red.shade200),
                                child: Column(
                                  children: [
                                    // const Icon(
                                    //   Icons.picture_as_pdf,
                                    //   size: 80,
                                    //   color: Colors.red,
                                    // ),
                                    Container(
                                        height: 150,
                                        width: 150,
                                        padding: const EdgeInsets.all(1),
                                        child: SfPdfViewer.network(
                                            saveProfileData[
                                                'training_certificate']))
                                  ],
                                ))
                            : Container(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 80,
                                  color: Colors.red,
                                ),
                              ))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "18. ",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "doordarshan/airCerti".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: MyColor.darkGrey,
                              fontSize: 12,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.poppins_medium,
                            ),
                          ),
                        )
                      ],
                    )),
                    Expanded(
                        child: saveProfileData['grade_certificate'] != ""
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Colors.red.shade200),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      padding: const EdgeInsets.all(1),
                                      child: SfPdfViewer.network(
                                          saveProfileData['grade_certificate']),
                                    )
                                  ],
                                ))
                            : Container(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 80,
                                  color: Colors.red,
                                ),
                              ))
                    // const Icon(
                  ],
                ),
              ),
              Row(children: [
                Text(
                  "19. ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.darkGrey,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "auditionLink".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: MyColor.darkGrey,
                      fontSize: 12,
                      fontFamily: MyFont.poppins,
                      fontWeight: MyFontWeight.poppins_medium,
                    ),
                  ),
                ),
              ]),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 20),
                child: Text(
                  saveProfileData['audition_link'].toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: saveProfileData['audition_link']
                                .toString()
                                .contains("www") ||
                            saveProfileData['audition_link']
                                .toString()
                                .contains("http") ||
                            saveProfileData['audition_link']
                                .toString()
                                .contains("https")
                        ? MyColor.color0085FF
                        : MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "20. ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "twohundredwords".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 20),
                child: Text(
                  saveProfileData['other_info'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "21. ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "presentFivePhoto".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                // height: 140,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 20),
                // child: Image.network(saveProfileData['photo'][0]['photo'])
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: const EdgeInsets.only(top: 5),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            //change
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 60),
                    itemCount: (saveProfileData['photo']).length,
                    itemBuilder: (_, index) => Container(
                          child: Image.network(
                            saveProfileData['photo'][index]['photo'],
                            fit: BoxFit.cover,
                          ),
                        )),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "22. ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "youtubeLink".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 20),
                child: Text(
                  saveProfileData['youtube_link'].toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: saveProfileData['youtube_link']
                                .toString()
                                .contains("www") ||
                            saveProfileData['youtube_link']
                                .toString()
                                .contains("http") ||
                            saveProfileData['youtube_link']
                                .toString()
                                .contains("https")
                        ? MyColor.color0085FF
                        : MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "23. ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "facebookLink".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 20),
                child: Text(
                  saveProfileData['facebook_link'].toString() == null
                      ? ""
                      : saveProfileData['facebook_link'].toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: saveProfileData['facebook_link']
                                .toString()
                                .contains("www") ||
                            saveProfileData['facebook_link']
                                .toString()
                                .contains("http") ||
                            saveProfileData['facebook_link']
                                .toString()
                                .contains("https")
                        ? MyColor.color0085FF
                        : MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15, left: 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "24. ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColor.darkGrey,
                          fontSize: 12,
                          fontFamily: MyFont.poppins,
                          fontWeight: MyFontWeight.poppins_medium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "instagramLink".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: MyColor.darkGrey,
                            fontSize: 12,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 4, left: 20),
                child: Text(
                  (saveProfileData['instagram_link'].toString() == null)
                      ? ""
                      : saveProfileData['instagram_link'].toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: saveProfileData['instagram_link']
                                .toString()
                                .contains("www") ||
                            saveProfileData['instagram_link']
                                .toString()
                                .contains("http") ||
                            saveProfileData['instagram_link']
                                .toString()
                                .contains("https")
                        ? MyColor.color0085FF
                        : MyColor.appGreyColor,
                    fontSize: 12,
                    fontFamily: MyFont.poppins,
                    fontWeight: MyFontWeight.poppins_medium,
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
                    // label: "Save",
                    label: 'save'.tr,
                    height: 45.0,
                    width: width,
                    onPressed: () {
                      profileSaveFinal(user_id);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future getDroupDownListStep1() async {
    //replace your restFull API here.
    String url = ApiConstants.step1DroupDownDataApi;
    final response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "multipart/form-data"});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['code'] == 200) {
        var yearList = jsonResponse['data']['date_of_birth']['years'] as List;
        var monthList = jsonResponse['data']['date_of_birth']['months'] as List;
        var dayList = jsonResponse['data']['date_of_birth']['days'] as List;
        var gendersList = jsonResponse['data']['genders'] as List;
        var artistExperienceList =
            jsonResponse['data']['artistExperience'] as List;

        for (int i = 0; i < yearList.length; i++) {
          yearArr.add(yearList[i]['year'].toString());
        }
        for (int i = 0; i < monthList.length; i++) {
          monthArr.add(monthList[i]['month'].toString());
        }
        for (int i = 0; i < dayList.length; i++) {
          dateArr.add(dayList[i]['day'].toString());
        }
        for (int i = 0; i < artistExperienceList.length; i++) {
          workExperienceArr
              .add(artistExperienceList[i]['exprience'].toString());
        }
        for (int i = 0; i < gendersList.length; i++) {
          genderArr.add(gendersList[i]['name'].toString());
        }

        setState(() {});
        // var yearArr=jsonResponse['data']['date_of_birth']['years'];
        // var yearArr=jsonResponse['data']['date_of_birth']['years'];
      }
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future getDroupDownListStep2() async {
    //replace your restFull API here.
    String url = ApiConstants.step2DroupDownDataApi;
    final response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "multipart/form-data"});
    getUserDetails(user_id);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['code'] == 200) {
        var artistGradeList = jsonResponse['data']['artist_grade'] as List;
        var vidhaList = jsonResponse['data']['vidha_list'] as List;
        var presentationLevelList =
            jsonResponse['data']['presentation_level'] as List;
        var districtsList = jsonResponse['data']['districts_list'] as List;

        for (int i = 0; i < artistGradeList.length; i++) {
          gradArr.add(artistGradeList[i]['grade_name'].toString());
        }
        for (int i = 0; i < vidhaList.length; i++) {
          genreArr.add(vidhaList[i]['name'].toString());
        }
        for (int i = 0; i < presentationLevelList.length; i++) {
          awardLevelArr.add(presentationLevelList[i]['name'].toString());
        }
        for (int i = 0; i < districtsList.length; i++) {
          distArr.add(districtsList[i]['name'].toString());
        }
        getArtOfArea(genreValue.toString());
        setState(() {});
        // var yearArr=jsonResponse['data']['date_of_birth']['years'];
        // var yearArr=jsonResponse['data']['date_of_birth']['years'];
      }
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future getArtOfArea(String vidhaName) async {
    String url =
        "${ApiConstants.getArtOfAreaApi}?vidha_name=${vidhaName.trim()}";
    final response = await http.get(
      Uri.parse(url),
      // headers: {"Content-Type": "multipart/form-data"}
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['code'] == 200) {
        var genreAreaList = jsonResponse['data'] as List;

        for (int i = 0; i < genreAreaList.length; i++) {
          genreAreaArr.add(genreAreaList[i]['name'].toString());
        }
        setState(() {});
        // if(area_of_art_get_data!=""){
        //   List<String> artAreaList=area_of_art_get_data.split(",");
        //   for(int j=0;j<artAreaList.length;j++){
        //     isSelectedGenreAreaStr.add(artAreaList[j].trim());
        //     int ind=genreAreaArr.indexOf(artAreaList[j].trim());
        //     print("789778968967 "+ind.toString()+"  "+isSelectedGenreArea[ind].toString());
        //     // isSelectedGenreArea[ind]=true;
        //   }
        //   setState(() {
        //
        //   });
        // }

        // var yearArr=jsonResponse['data']['date_of_birth']['years'];
        // var yearArr=jsonResponse['data']['date_of_birth']['years'];
      } else {
        genreAreaArr = [];
        genreAreaValue = "";
        setState(() {});
      }
    } else {
      genreAreaArr = [];
      genreAreaValue = "";
      setState(() {});
      // throw Exception('Unexpected error occured!');
    }
  }

  Future<List<dynamic>> getArtOfSubArea(String artName) async {
    var genreSubAreaList = [];
    String url =
        "${ApiConstants.getArtOfSubAreaApi}?art_name=${artName.trim()}";
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['code'] == 200) {
        genreSubAreaList = jsonResponse['data'];
        return genreSubAreaList;
      } else {
        return genreSubAreaList;
      }
    } else {
      return genreSubAreaList;
    }
  }

  Future getImageGallery(String imgFor) async {
    ImagePicker picker = ImagePicker();
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 90)
        .then((xFile) {
      if (xFile != null) {
        File imageFile = File(xFile.path);
        setState(() {
          if (imgFor == "profile") {
            profileImage = imageFile;
            profimg_valid = "";
          } else if (imgFor == "preject") {
            step = "2";
            artistImgList.add(imageFile);
          }
        });
      }
    });
  }

  Future getImageGall() async {
    ImagePicker picker = ImagePicker();
    await picker.pickMultiImage(imageQuality: 70).then((xFile) {
      if (xFile.isNotEmpty) {
        artistImgList = [];
        if (artistPhotoListStr == "") {
          if (xFile.length <= 5) {
            for (var i in xFile) {
              artistImgList.add(File(i.path));
            }
          } else {
            _showMaxImagesAlert();
          }
          setState(() {});
        } else {
          int totLength = xFile.length + (int.parse(artistPhotoListStr));
          if (totLength <= 5) {
            for (var i in xFile) {
              artistImgList.add(File(i.path));
            }
          } else {
            _showMaxImagesAlert();
          }
          setState(() {});
        }
      }
    });
  }

  void _showMaxImagesAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limit Reached'),
          content: const Text('You can only select up to 5 images.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void updateProfileStep1(
      String userId,
      String name,
      String mobileNumber,
      String date,
      String month,
      String year,
      String emailId,
      String gender,
      String experience,
      String photo,
      String address) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    var uri = Uri.parse(ApiConstants.updateProfileStep1);
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = userId;
    request.fields['name'] = name;
    request.fields['mobile_number'] = mobileNumber;
    request.fields['date'] = date;
    request.fields['month'] = month;
    request.fields['year'] = year;
    request.fields['email_id'] = emailId;
    request.fields['gender'] = gender;
    request.fields['experience'] = experience;
    request.fields['address'] = address;
    request.files.add(await http.MultipartFile.fromPath('photo', photo));
    var response = await request.send();
    Get.back();
    //
    // response.stream.transform(utf8.decoder).listen((value) {
    //   var jsonResponse = json.decode(value);
    //   print("2222222333 $jsonResponse");
    //   if (jsonResponse['code'] == 200) {
    //     setState(() {
    //       step = "2";
    //     });
    //   } else {
    //     String errorMsg = "";
    //     jsonResponse['errors'].keys.forEach((key) {
    //       if (errorMsg == "") {
    //         errorMsg = jsonResponse['errors'][key][0].toString();
    //       } else {
    //         errorMsg = "$errorMsg\n\n ${jsonResponse['errors'][key][0]}";
    //       }
    //     });
    //     Get.dialog(ErrorDialog(msg: errorMsg), barrierDismissible: false);
    //     // Get.dialog(ErrorDialog(msg: jsonResponse['message'].toString()));
    //   }
    // });
    response.stream.transform(utf8.decoder).listen((value) {
      var jsonResponse = json.decode(value);
      print("2222222333 $jsonResponse");

      if (jsonResponse['code'] == 200) {
        // Success case
        setState(() {
          step = "2";
        });
      } else if (jsonResponse.containsKey('errors') &&
          jsonResponse['errors'] != null) {
        // Error case - handle errors if present
        String errorMsg = "";
        jsonResponse['errors'].keys.forEach((key) {
          if (errorMsg.isEmpty) {
            errorMsg = jsonResponse['errors'][key][0].toString();
          } else {
            errorMsg = "$errorMsg\n\n${jsonResponse['errors'][key][0]}";
          }
        });
        Get.dialog(ErrorDialog(msg: errorMsg), barrierDismissible: false);
      } else {
        // General failure case
        String message =
            jsonResponse['message'] ?? "An unknown error occurred.";
        Get.dialog(ErrorDialog(msg: message), barrierDismissible: false);
      }
    });

    if (response.statusCode == 200) {}
  }

  void updateProfileStep2(
    String userId,
    String gradeName,
    String vidhaName,
    String areaOfArt,
    String subAreaOfArt,
    String awardName,
    String districtsName,
    String teamMember,
    String proposedRemuneration,
    String artistCostPrice,
    String seniorArtistName1,
    String seniorArtistDesignation1,
    String seniorArtistMobileNumber1,
    String seniorArtistName2,
    String seniorArtistDesignation2,
    String seniorArtistMobileNumber2,
    String trainingCertificate,
    String gradeCertificate,
    String auditionLink,
    String otherInfo,
    List<File> artistImgList,
    String youtubeLink,
    String facebookLink,
    String instagramLink,
  ) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    var uri = Uri.parse(ApiConstants.updateProfileStep2);
    var request = http.MultipartRequest('POST', uri);

    print("Vidha ka naam: " + vidhaName);
    request.fields['user_id'] = userId;
    request.fields['grade_name'] = gradeName;
    request.fields['vidha_name'] = vidhaName;

    request.fields['area_of_art'] = areaOfArt;
    request.fields['sub_area_of_art'] = subAreaOfArt;
    request.fields['presentation_level'] = awardName;
    request.fields['districts_name'] = districtsName;
    request.fields['team_member'] = teamMember;
    request.fields['proposed_remuneration'] = proposedRemuneration;
    request.fields['cost'] = artistCostPrice;

    request.fields['senior_artist_name1'] = seniorArtistName1;
    request.fields['senior_artist_designation1'] = seniorArtistDesignation1;
    request.fields['senior_artist_mobile_number1'] = seniorArtistMobileNumber1;
    request.fields['senior_artist_name2'] = seniorArtistName2;
    request.fields['senior_artist_designation2'] = seniorArtistDesignation2;
    request.fields['senior_artist_mobile_number2'] = seniorArtistMobileNumber2;
    request.fields['audition_link'] = auditionLink;
    request.fields['other_info'] = otherInfo;
    request.fields['youtube_link'] = youtubeLink;
    request.fields['facebook_link'] = facebookLink;
    request.fields['instagram_link'] = instagramLink;

    if (trainingCertificate == "") {
      request.fields['training_certificate'] = "";
    } else {
      request.files.add(await http.MultipartFile.fromPath(
          'training_certificate', trainingCertificate));
    }

    if (gradeCertificate == "") {
      request.fields['grade_certificate'] = "";
    } else {
      request.files.add(await http.MultipartFile.fromPath(
          'grade_certificate', gradeCertificate));
    }

    if (artistImgList.isEmpty) {
      request.fields['artist_photo[]'] = "";
    } else {
      for (int i = 0; i < artistImgList.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'artist_photo[]', artistImgList[i].path));
      }
    }

    var response = await request.send();
    print("kamleshTested"+response.toString());

    Get.back();
    response.stream.transform(utf8.decoder).listen((value) {
      var jsonResponse = json.decode(value);
      print("2222222333 " + jsonResponse.toString());
      if (jsonResponse['code'] == 200) {
        setState(() {
          saveProfileData = jsonResponse['data'];
          print("--->" + saveProfileData.toString());
          // print("cxcxz2222222 "+saveProfileData.toString());
          step = "3";
        });
      } else {
        String errorMsg = "";
        jsonResponse['errors'].keys.forEach((key) {
          if (errorMsg == "") {
            errorMsg = jsonResponse['errors'][key][0].toString();
          } else {
            errorMsg = "$errorMsg\n\n ${jsonResponse['errors'][key][0]}";
          }
        });
        print("what is ===> $errorMsg");
        Get.dialog(ErrorDialog(msg: errorMsg), barrierDismissible: false);
        // Get.dialog(ErrorDialog(msg: jsonResponse['message'].toString()));
      }
    });
  }

  void getDocuments(String fileFor) async {
    await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ).then((result) {
      File file = File(result!.files.single.path!);
      setState(() {
        if (fileFor == "training") {
          trainingSertiImage = file;
        } else if (fileFor == "grade") {
          gradImage = file;
        }
      });
    });
  }

  void profileSaveFinal(String userId) async {
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    var uri = Uri.parse(ApiConstants.artistProfileDetailSace);
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = userId;
    var response = await request.send();
    Get.back();
    // print("cxcxz55555 "+response.toString());
    // if(response.statusCode==200){
    //   login(int.parse(user_id));
    // }
    login(int.parse(userId));
  }

  void getUserDetails(String userId) async {
    try {
      http.Response response =
          await post(Uri.parse(ApiConstants.getArtistDetailsApi), body: {
        'user_id': userId,
      });
      var data = jsonDecode(response.body.toString());
      print("opofjvknfivf $data");
      if (data['code'] == 200) {
        if (data['data']['user_id'].toString() != "") {
          gendervalue = data['data']['gender'].toString();
          workExperienceValue = data['data']['experience'].toString();
          dateValue = data['data']['date'].toString();
          monthValue = data['data']['month'].toString();
          yearValue = data['data']['year'].toString();
          addressController.text = data['data']['address'].toString();

          if (data['data']['grade_name'].toString() != "") {
            gradValue = data['data']['grade_name'].toString();
            genreValue = data['data']['vidha_name'].toString();

            genreAreaValue = data['data']['area_of_art'].toString();
            awardLevelValue = data['data']['presentation_level'].toString();
            distValue = data['data']['districts_name'].toString();
            teamMemberController.text = data['data']['team_member'].toString();
            presentationController.text =
                data['data']['proposed_remuneration'].toString();
            artistPriceController.text = data['data']['cost'].toString();

            artistKnowController1.text =
                data['data']['senior_artist_name1'].toString();
            artistKnowController2.text =
                data['data']['senior_artist_designation1'].toString();
            artistKnowController3.text =
                data['data']['senior_artist_mobile_number1'].toString();
            artistKnowController4.text =
                data['data']['senior_artist_name2'].toString();
            artistKnowController5.text =
                data['data']['senior_artist_designation2'].toString();
            artistKnowController6.text =
                data['data']['senior_artist_mobile_number2'].toString();
            auditionLinkController.text =
                data['data']['audition_link'].toString();
            otherAchievementsController.text =
                data['data']['other_info'].toString();
            videoLinkController.text = data['data']['youtube_link'].toString();
            facebookLinkController.text =
                data['data']['facebook_link'].toString();
            instaLinkController.text =
                data['data']['instagram_link'].toString();
            training_certificate =
                data['data']['training_certificate'].toString();
            grade_certificate = data['data']['grade_certificate'].toString();
            artistPhotoListStr =
                ((data['data']['photo']) as List).length.toString();
            area_of_art_get_data = data['data']['area_of_art'].toString();
            sub_area_of_art_get_data =
                data['data']['sub_area_of_art'].toString();
            getArtOfArea(genreValue! ?? "");
            setState(() {});
          }

          setState(() {});
        }
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
    } catch (e) {}
  }

  login(int userId) {
    // print("cxcxz55555 "+user_id.toString());
    MySharedPreference.setBool(KeyConstants.keyIsLogin, true);
    MySharedPreference.setInt(KeyConstants.keyUserId, userId);
    // MySharedPreference.setInt(KeyConstants.keyUserId, userId.value);
    // Get.offAll(() => const ArtistProfileScreen());
    Get.offAll(() => ArtistHomeScreen(
          callFrom: 'Artist',
          lang: MyLangCode.langcode,
        ));
  }
}
