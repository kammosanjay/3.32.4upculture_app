import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:upculture/controller/artist/artist_profile_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';

import 'package:http/http.dart' as http;
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

import 'package:upculture/screen/artist/register_step_src.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:upculture/utils/my_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dialog/custom_progress_dialog.dart';

import '../../local_database/key_constants.dart';
import '../../network/api_constants.dart';
import 'artist_home_screen.dart';

class ArtistProfileScreen extends StatefulWidget {
  ArtistProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  ArtistProfileController getXController = Get.put(ArtistProfileController());
  late double height;
  late double width;
  var saveProfileData;

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

  Widget shimmerWidget() {
    return Shimmer(
      child: Container(
        width: 80.0,
        height: 80.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: Colors.white,
            width: 4.0,
          ),
        ),
      ),
      gradient: LinearGradient(
          colors: [MyColor.appColor, MyColor.indiaWhite],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight),
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 2),
    );
  }

  login(int userId) {
    // print("cxcxz55555 "+user_id.toString());
    MySharedPreference.setBool(KeyConstants.keyIsLogin, true);
    MySharedPreference.setInt(KeyConstants.keyUserId, userId);
    // MySharedPreference.setInt(KeyConstants.keyUserId, userId.value);
    // Get.offAll(() => const ArtistProfileScreen());
    Get.offAll(() => ArtistHomeScreen(
          callFrom: 'Artist',
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreference.getInstance();
    Future.delayed(const Duration(), () {
      getXController.artistProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: MyColor.appColor,
    ));

    return Obx(() {
      var userData = getXController.profileData.value;
      return WillPopScope(
        onWillPop: () async {
          Get.offAll(() => ArtistHomeScreen(
                callFrom: 'Artist',
              ));
          return true;
        },
        child: Scaffold(
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        // MyString.artistDetails,
                        'artistDetails'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColor.color1F140A,
                          fontSize: 20,
                          fontFamily: MyFont.roboto,
                          fontWeight: MyFontWeight.regular,

                          
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 104,
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
                        userData.userProfile != null
                            ? Container(
                                width: 80.0,
                                height: 80.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    scale: 1,
                                    image: NetworkImage(userData.userProfile!),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0)),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4.0,
                                  ),
                                ),
                              )
                            : shimmerWidget(),
                      ],
                    ),
                  ),
                ),
                MyGlobal.checkNullData(userData.name).isNotEmpty
                    ? Expanded(
                        child: ListView(
                          children: [
                            // photoNameWidget(),

                            Container(
                              margin: const EdgeInsets.only(top: 0),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: const Color(0xffF6F6F6),
                                  border: Border.all(
                                      color: const Color(0xff50cdcdcd),
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '1. ',
                                        style: TextStyle(
                                          color: MyColor.darkGrey,
                                          fontSize: 12,
                                          fontFamily: MyFont.poppins,
                                          fontWeight:
                                              MyFontWeight.poppins_medium,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            "Artist Name".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          // saveProfileData['name'],
                                          userData.name.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.color4F4C4C,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ),
                                      ))
                                    ],
                                  )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '2. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "Address".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              // saveProfileData['address'],
                                              userData.address.toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '3. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "dob".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${userData.date}/${userData.month}/${userData.year}",

                                              // "${saveProfileData['date']}/${saveProfileData['month']}/${saveProfileData['year']}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '4. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "gender".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.gender.toString(),
                                              // "test",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '5. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "workExperience".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.experience!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '6. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "mobileNo".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.mobile_number!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '7. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "email".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.email_id.toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '8. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "goToWebsite".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
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
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '9. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
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
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.vidha_name!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  //
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '9.1 ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
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
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.cost!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  //

                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '10. ',
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "genreArea".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.area_of_art.toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "11. ",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    "akashwadi".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
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
                                              userData.grade_name.toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "12. ",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    "presentaionLvl".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
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
                                              userData.presentation_level!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "13. ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "district".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: MyColor.darkGrey,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userData.districts_name
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "14. ",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    "membersNo".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
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
                                              userData.team_member!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "15. ",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    "presentatoinfee".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: MyColor.darkGrey,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
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
                                              userData.proposed_remuneration
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.color4F4C4C,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          ))
                                        ],
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "16. ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "1",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 40),
                                    child: Text(
                                      userData.seniorArtistName1.toString(),
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
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "(II) ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 40),
                                    child: Text(
                                      userData.seniorArtistDesignation1
                                          .toString(),
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
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "(III) ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 40),
                                    child: Text(
                                      userData.seniorArtistMobileNumber1
                                          .toString(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "2",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.color4F4C4C,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 35),
                                    child: Text(
                                      userData.seniorArtistName2.toString(),
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
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "(II) ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 40),
                                    child: Text(
                                      userData.seniorArtistDesignation2
                                          .toString(),
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
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "(III) ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 40),
                                    child: Text(
                                      userData.seniorArtistMobileNumber2
                                          .toString(),
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
                                    margin:
                                        const EdgeInsets.only(top: 15, left: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "17. ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: userData.trainingCertificate !=
                                                  ""
                                              ? Container(
                                                  padding: EdgeInsets.all(1),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.red.shade200),
                                                  child: SfPdfViewer.network(
                                                      userData
                                                          .trainingCertificate
                                                          .toString()),
                                                )
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      color:
                                                          Colors.red.shade200),
                                                  child: Column(
                                                    children: [
                                                      const Icon(
                                                        Icons.picture_as_pdf,
                                                        size: 80,
                                                        color: Colors.red,
                                                      ),
                                                      // child: SfPdfViewer.network(saveProfileData['grade_certificate'])

                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          // ((saveProfileData['training_certificate']).toString().split("/")).last,
                                                          // "name",
                                                          "",
                                                          textAlign:
                                                              TextAlign.start,

                                                          style: TextStyle(
                                                            color: MyColor
                                                                .darkGrey,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                MyFont.poppins,
                                                            fontWeight: MyFontWeight
                                                                .poppins_medium,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 15, left: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "18. ",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: MyColor.darkGrey,
                                                fontSize: 12,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
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
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                        Expanded(
                                          child: userData.gradeCertificate != ""
                                              ? Container(
                                                  padding: EdgeInsets.all(1),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.red.shade200),
                                                  child: SfPdfViewer.network(
                                                      userData.gradeCertificate
                                                          .toString()),
                                                )
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10)),
                                                      color:
                                                          Colors.red.shade200),
                                                  child: Column(
                                                    children: [
                                                      const Icon(
                                                        Icons.picture_as_pdf,
                                                        size: 80,
                                                        color: Colors.red,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          userData
                                                              .gradeCertificate
                                                              .toString()
                                                              .split("/")
                                                              .last,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: MyColor
                                                                .darkGrey,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                MyFont.poppins,
                                                            fontWeight: MyFontWeight
                                                                .poppins_medium,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "19. ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          "auditionLink".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 20),
                                    child: Text(
                                      userData.auditionLink
                                          .toString()
                                          .split("/")
                                          .last,
                                      textAlign: TextAlign.start,

                                      // style: TextStyle(
                                      //   color:
                                      //   saveProfileData['audition_link'].toString().contains("www")||saveProfileData['audition_link'].toString().contains("http")||saveProfileData['audition_link'].toString().contains("https") ?MyColor.color0085FF :MyColor.appGreyColor,
                                      //   fontSize: 12,
                                      //   fontFamily: MyFont.poppins,
                                      //   fontWeight: MyFontWeight.poppins_medium,
                                      // ),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, left: 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "20. ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
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
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 20),
                                    child: Text(
                                      userData.otherInfo.toString(),
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
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "21. ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: MyColor.darkGrey,
                                            fontSize: 12,
                                            fontFamily: MyFont.poppins,
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
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
                                            fontWeight:
                                                MyFontWeight.poppins_medium,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // height: 140,
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 20),
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
                                          mainAxisExtent: 60
                                        ),
                                        itemCount: userData.photo!.length,
                                        itemBuilder: (_, index) => Container(
                                              child: Image.network(
                                                userData.photo![index]['photo'],
                                                
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, left: 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "22. ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
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
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 20),
                                    child: Text(
                                      userData.youtubeLink.toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, left: 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "23. ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
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
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 20),
                                    child: Text(
                                      userData.facebookLink.toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, left: 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "24. ",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: MyColor.darkGrey,
                                              fontSize: 12,
                                              fontFamily: MyFont.poppins,
                                              fontWeight:
                                                  MyFontWeight.poppins_medium,
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
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        const EdgeInsets.only(top: 4, left: 20),
                                    child: Text(
                                      userData.instagramLink.toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: OutlinedButton(
                                              child: Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: MyColor.appColor,
                                                    fontSize: 16,
                                                    fontFamily: MyFont.poppins,
                                                    fontWeight: MyFontWeight
                                                        .poppins_medium),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: MyColor.appColor,
                                                      width: 2.0),
                                                  fixedSize: Size(100, 45)),
                                              onPressed: () {
                                                Get.to(RegisterStepSrc(
                                                    'hindi',
                                                    userData.name.toString(),
                                                    userData.mobile_number
                                                        .toString(),
                                                    userData.email_id
                                                        .toString(),
                                                    MySharedPreference.getInt(
                                                            KeyConstants
                                                                .keyUserId)
                                                        .toString(),
                                                    '1'));
                                              },
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child:
                                              MyWidget.getButtonWidgetWithStyle(
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium),
                                                  label: "save",
                                                  height: 45.0,
                                                  width: width,
                                                  onPressed: () {
                                                    // profileSaveFinal(user_id);
                                                    Get.back();
                                                  }),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      );
    });
  }

  artistDataWidget({required label, required value, type}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          minVerticalPadding: 0,
          minLeadingWidth: 0,
          horizontalTitleGap: 7,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: MyColor.appColor,
            size: 16,
          ),
          title: Text(
            label,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
          ),
          subtitle: Text(
            MyGlobal.checkNullData(value).isNotEmpty ? value : '-',
            style: TextStyle(
                color: type != null ? MyColor.color0085FF : MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
          ),
        )
      ],
    );
  }

  Future<void> openMediaApp(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
