import 'dart:convert';

import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/model/artist/response/artist_registration_response_new.dart';
import 'package:upculture/model/artist/response/language_list_response.dart';
import 'package:upculture/screen/artist/register_otp_src.dart';

import '../../dialog/custom_progress_dialog.dart';
import '../../dialog/error_dialog.dart';
import '../../dialog/success_dialog.dart';
import '../../model/artist/request/artist_registration_request_new.dart';

import '../../network/api_constants.dart';
import '../../network/repository.dart';
import '../../resources/my_color.dart';
import '../../resources/my_font.dart';
import '../../resources/my_font_weight.dart';
import '../../resources/my_string.dart';
import '../../utils/my_style.dart';
import '../../utils/my_widget.dart';

import 'artist_login_screen.dart';
import 'package:http/http.dart' as http;

class NewRegisterSrc extends StatefulWidget {
  const NewRegisterSrc({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewRegisterSrcState();
  }
}

class NewRegisterSrcState extends State<NewRegisterSrc> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var controller = Get.find<ArtistHomeController>();
  late double height;
  late double width;
  List<String> items = [];

  String? dropdownvalue = MyString.selectDroupDown;

  final List<Map<String, String>> languages = [
    {'value': 'en', 'label': 'English'},
    {'value': 'hi', 'label': 'हिंदी'},
  ];
  String selectedLanguage = 'en';
  @override
  void initState() {
    super.initState();
    getLanguageList();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    Locale savedLocale = await MySharedPreference().getSavedLocale();
    setState(() {
      selectedLanguage = savedLocale.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: MyColor.appColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                // MyString.artistRegistrationTitle,
                'artistRegistrationTitle'.tr,
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
              height: height * 0.55,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 5,
                        offset: Offset(1, 2)),
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(-3, -5))
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 4),
                      child: Text(
                        // MyString.chooseLanguage,
                        'chooseLanguage'.tr,
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
                            border:
                                Border.all(color: MyColor.appColor, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child:
                            // DropdownButtonHideUnderline(
                            //   child: DropdownButton(
                            //     hint: Text(
                            //       MyString.selectDroupDown,
                            //       style: TextStyle(
                            //         color: MyColor.color4F4C4C,
                            //         fontSize: 12,
                            //         fontFamily: MyFont.poppins,
                            //         fontWeight: MyFontWeight.poppins_medium,
                            //       ),
                            //     ),
                            //     value: dropdownvalue == null
                            //         ? null
                            //         : dropdownvalue == ""
                            //             ? null
                            //             : dropdownvalue,
                            //     // icon: const Icon(Icons.keyboard_arrow_down),
                            //     icon: Container(),
                            //     items: items.map((String items) {
                            //       return DropdownMenuItem(
                            //         value: items,
                            //         child: Text(
                            //           items,
                            //           style: TextStyle(
                            //             color: MyColor.color4F4C4C,
                            //             fontSize: 12,
                            //             fontFamily: MyFont.poppins,
                            //             fontWeight: MyFontWeight.poppins_medium,
                            //           ),
                            //         ),
                            //       );
                            //     }).toList(),
                            //     onChanged: (String? newValue) {
                            //       setState(() {
                            //         dropdownvalue = newValue!;
                            //       });
                            //     },
                            //   ),
                            // )
                            DropdownButton<String>(
                          value: selectedLanguage,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: languages.map((lang) {
                            return DropdownMenuItem<String>(
                              value: lang['value'],
                              child: Text(lang['label']!),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              if (newValue == 'hi') {
                                controller.getCategoriesData(langCode: 1);
                                Locale newLocale = const Locale('hi', 'IN');
                                await MySharedPreference()
                                    .saveLocale(newLocale);
                                Get.updateLocale(Locale(newLocale.toString()));
                              } else if (newValue == 'en') {
                                ///
                                controller.getCategoriesData(langCode: 2);
                                Locale newLocale = const Locale('en', 'US');
                                await MySharedPreference()
                                    .saveLocale(newLocale);
                                Get.updateLocale(Locale(newLocale.toString()));
                              }

                              setState(() {
                                selectedLanguage = newValue;
                              });

                              // Update the app's language using GetX or similar state management

                              print('Selected Language: $newValue');
                            }
                          },
                        )),
                    Visibility(
                      visible: dropdownvalue == "",
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          "भाषा चुने",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_medium,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 4),
                      child: Text(
                        // MyString.artistNameLbl,
                        "artistNameLbl".tr,
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
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return value == null || value.isEmpty
                            ? MyString.enterName
                            : null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // setState(() {});
                          return null;
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
                        prefixIcon: Icon(Icons.person_2),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
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
                      controller: mobileController,
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
                          // setState(() {});
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only n
                      maxLength: 10,
                      style: TextStyle(
                        color: MyColor.color4F4C4C,
                        fontSize: 12,
                        fontFamily: MyFont.poppins,
                        fontWeight: MyFontWeight.poppins_medium,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mobile_friendly_outlined),
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
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
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        return value == null || value.isEmpty
                            ? MyString.enterEmail
                            : !EmailValidator.validate(
                                    emailController.text.trim())
                                ? MyString.enterValidEmail
                                : null;
                      },
                        onChanged: (value) {
                        if (value.isNotEmpty) {
                          // setState(() {});
                          return null;
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
                        prefixIcon: Icon(Icons.mail_outline),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        border: InputBorder.none,
                        enabledBorder: MyStyle.inputFocusBorder(),
                        disabledBorder: MyStyle.inputFocusBorder(),
                        focusedBorder: MyStyle.inputFocusBorder(),
                        errorBorder: MyStyle.inputErrorBorder(),
                        focusedErrorBorder: MyStyle.inputErrorBorder(),
                      ),
                    ),

                    //  SizedBox(height: 100,),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          print("this is user registration1");
                          final form = _formKey.currentState;
                          if (dropdownvalue == null || dropdownvalue == "") {
                            setState(() {
                              dropdownvalue = "";
                            });
                          }
                          if (form!.validate()) {
                            print("this is user registration2");
                            registerArtits2();
                          }
                        },
                        child: Text(
                          'registerLbl'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: MyFont.poppins,
                              fontWeight: MyFontWeight.bold),
                        ))),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Get.offAll(() => const ArtistLoginScreen(),
                              transition: Transition.zoom);
                        },
                        child: Text(
                          'loginLbl'.tr,
                          style: TextStyle(
                            color: MyColor.indiaWhite,
                            fontSize: 16,
                            fontFamily: MyFont.poppins,
                            fontWeight: MyFontWeight.poppins_semiBold,
                          ),
                        ))),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              alignment: Alignment.center,
              child: Text(
                // MyString.alreadyRegiterLblNameLbl,
                'alreadyRegiterLblNameLbl'.tr,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 12,
                  fontFamily: MyFont.poppins,
                  fontWeight: MyFontWeight.poppins_medium,
                ),
              ),
            ),

            // Row(
            //   children: [
            //     Container(
            //       child: MyWidget.getButtonWidgetWithStyle(
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 16,
            //               fontFamily: MyFont.poppins,
            //               fontWeight: MyFontWeight.bold),
            //           // label: MyString.registerLbl,
            //           label: 'registerLbl'.tr,
            //           height: 45.0,
            //           width: width,
            //           onPressed: () {
            //             print("this is user registration1");
            //             final form = _formKey.currentState;
            //             if (dropdownvalue == null || dropdownvalue == "") {
            //               setState(() {
            //                 dropdownvalue = "";
            //               });
            //             }
            //             if (form!.validate()) {
            //               print("this is user registration2");
            //               registerArtits2();
            //               // String userName=nameController.text.trim();
            //               // String userMobile=mobileController.text.trim();
            //               // String userEmail=emailController.text.trim();
            //               // navigateToOtp(dropdownvalue,userName,userMobile,userEmail,"153","1234");
            //             }
            //           }),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         // Navigator.pop(context,true);
            //         Get.offAll(() => const ArtistLoginScreen(),
            //             transition: Transition.zoom);
            //         // navigateToOtp("lang","name","mobile","email","184","1234");
            //       },
            //       child: Container(
            //         margin: EdgeInsets.symmetric(
            //             horizontal: width * 0.25, vertical: 10),
            //         padding: EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //             color: MyColor.appColor,
            //             borderRadius: BorderRadius.circular(5)),
            //         child: Center(
            //           child: Text(
            //             // MyString.loginLbl,
            //             'loginLbl'.tr,
            //             style: TextStyle(
            //               color: MyColor.indiaWhite,
            //               fontSize: 16,
            //               fontFamily: MyFont.poppins,
            //               fontWeight: MyFontWeight.poppins_semiBold,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // Container(
            //   child: MyWidget.getButtonWidgetWithStyle(
            //       style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //           fontFamily: MyFont.poppins,
            //           fontWeight: MyFontWeight.bold),
            //       // label: MyString.registerLbl,
            //       label: 'registerLbl'.tr,
            //       height: 45.0,
            //       width: width,
            //       onPressed: () {
            //         print("this is user registration1");
            //         final form = _formKey.currentState;
            //         if (dropdownvalue == null || dropdownvalue == "") {
            //           setState(() {
            //             dropdownvalue = "";
            //           });
            //         }
            //         if (form!.validate()) {
            //           print("this is user registration2");
            //           registerArtits2();
            //         }
            //       }),
            // ),

            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 15,
            //   ),
            //   alignment: Alignment.center,
            //   child: Text(
            //     // MyString.alreadyRegiterLblNameLbl,
            //     'alreadyRegiterLblNameLbl'.tr,
            //     style: TextStyle(
            //       color: MyColor.color4F4C4C,
            //       fontSize: 12,
            //       fontFamily: MyFont.poppins,
            //       fontWeight: MyFontWeight.poppins_medium,
            //     ),
            //   ),
            // ),

            // GestureDetector(
            //   onTap: () {
            //     // Navigator.pop(context,true);
            //     Get.offAll(() => const ArtistLoginScreen(),
            //         transition: Transition.zoom);
            //     // navigateToOtp("lang","name","mobile","email","184","1234");
            //   },
            //   child: Container(
            //     margin: EdgeInsets.symmetric(
            //         horizontal: width * 0.25, vertical: 10),
            //     padding: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //         color: MyColor.appColor,
            //         borderRadius: BorderRadius.circular(5)),
            //     child: Center(
            //       child: Text(
            //         // MyString.loginLbl,
            //         'loginLbl'.tr,
            //         style: TextStyle(
            //           color: MyColor.indiaWhite,
            //           fontSize: 16,
            //           fontFamily: MyFont.poppins,
            //           fontWeight: MyFontWeight.poppins_semiBold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }

  void getLanguageList() async {
    LanguageListResponse? response = await Repository.hitLanguageListApi();
    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          var genderList = response.data!;
          // print("ssssss "+genderList[0].name.toString());
          for (int i = 0; i < genderList.length; i++) {
            items.add(genderList[i].name.toString());
            // print("ssssss "+genderList[i].name.toString());
          }
          setState(() {});
        }
      }
    }
  }

  registerArtits() async {
    String userName = nameController.text.trim();
    String userMobile = mobileController.text.trim();
    String userEmail = emailController.text.trim();
    ArtistRegistrationRequestNew request = ArtistRegistrationRequestNew(
        name: userName,
        mobile: int.parse(mobileController.text.trim()),
        email: userEmail,
        language: dropdownvalue);

    ArtistRegistrationResponseNew? response =
        await Repository.hitArtistRegistrationApiNew(request);

    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        String userId = response.data!.user_id.toString();
        String otp = response.data!.otp.toString();
        print("eeeeeeeasasaas $userId  $otp");
        Get.dialog(
            SuccessDialog(
              msg: response.message!,
              yesFunction: successFunction(
                  dropdownvalue, userName, userMobile, userEmail, userId, otp),
            ),
            barrierDismissible: false);
      } else {
        Get.dialog(ErrorDialog(msg: response.message!),
            barrierDismissible: false);
      }
    }
  }

  void registerArtits2() async {
    String userName = nameController.text.trim();
    String userMobile = mobileController.text.trim();
    String userEmail = emailController.text.trim();
    Get.dialog(const ProgressDialogWidget(),
        barrierDismissible: false, barrierColor: Colors.transparent);
    try {
      http.Response response =
          await post(Uri.parse(ApiConstants.artistRegistrationApi), body: {
        'name': userName,
        'mobile': userMobile,
        'email': userEmail,
        'language': dropdownvalue,
      });

      var data = jsonDecode(response.body.toString());
      Get.back();
      // print("eeeeeeeasasaas "+data.toString());
      if (data['code'] == 200 && data['type'] == 'success') {
        successFunction(dropdownvalue, userName, userMobile, userEmail,
            data['data']['user_id'].toString(), data['data']['otp'].toString());
        print("newperson userId: " + data['data']['user_id'].toString());
      } else {
        String errorMsg = "";
        data['errors'].keys.forEach((key) {
          if (errorMsg == "") {
            errorMsg = data['errors'][key][0].toString();
          } else {
            errorMsg = "$errorMsg\n\n ${data['errors'][key][0]}";
          }
        });
        Get.dialog(ErrorDialog(msg: errorMsg), barrierDismissible: false);
      }
    } catch (e) {
      Get.back();
    }
  }

  successFunction(lang, name, mobile, email, userId, otp) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewRegisterOtpSrc(lang, name, mobile, email, userId, otp);
    }));
  }

  navigateToOtp(lang, name, mobile, email, userId, otp) async {
    // print("eeeeeeeasasaas "+userId+"  "+otp);
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewRegisterOtpSrc(lang, name, mobile, email, userId, otp);
    }));
  }
}
