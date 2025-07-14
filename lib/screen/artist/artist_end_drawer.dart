import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/dialog/ask_dialog.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/screen/artist/addition_sub_screen.dart';
import 'package:upculture/screen/common/lngCodee.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/artist/response/artist_profile_response.dart';
import 'package:upculture/screen/artist/artist_profile_screen.dart';
import 'package:upculture/screen/common/select_role_screen.dart';
import '../common/sliding.dart';
import 'about_us.dart';

class ArtistEndDrawer extends StatefulWidget {
  final String? callFrom;
  final Data? profileData;

  ArtistEndDrawer({Key? key, this.callFrom, required this.profileData})
      : super(key: key);

  @override
  State<ArtistEndDrawer> createState() => _ArtistEndDrawerState();
}

class _ArtistEndDrawerState extends State<ArtistEndDrawer>
    with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  ArtistHomeController artistHomeController = Get.find<ArtistHomeController>();
  CategoryController categoryController = Get.put(CategoryController());
  late AnimationController _controller;

  int selectlang = 1;

  Future<void> openInAppWebViewPolicy() async {
    if (!await launchUrl(
        Uri.parse(
            "https://upcultureapp.artistdirectoryupculture.com/privacy-policy"),
        mode: LaunchMode.inAppWebView)) ;
  }

  Future<void> openInAppWebViewTerms() async {
    if (!await launchUrl(
        Uri.parse("https://upculture.up.nic.in/hi/naiyama-aura-sarataen"),
        mode: LaunchMode.inAppWebView)) ;
  }

  String selectedLanguage = 'hi';

  final List<Map<String, String>> languages = [
    {'value': 'hi', 'label': 'हिंदी'},
    {'value': 'en', 'label': 'English'},
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _loadSavedLanguage();
  // }
  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return Drawer(
      child: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  print(widget.callFrom);
                  if (widget.callFrom == 'Artist') {
                    Get.to(() => ArtistProfileScreen());
                  } else {
                    Get.defaultDialog(
                        title: "guest".tr, middleText: "guser".tr);
                  }
                },
                child: Container(
                  child: header(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    Get.back();
                    Get.to(() => const AboutUsScreen());
                  },
                  horizontalTitleGap: 20,
                  minLeadingWidth: 18.0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 9),
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  tileColor: MyColor.appColor,
                  leading: Image(
                    image: aboutUsIc,
                    height: 18.0,
                    width: 18.0,
                    color: Colors.white,
                  ),
                  title: Text(
                    'aboutUs'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.regular),
                  ),
                ),
              ),
              language(),
              menuWidget(
                  icon: newAdditionIc,
                  menu: 'newChanges'.tr,
                  onTap: () {
                    Get.back();
                    Get.to(() => const AdditionSubScreen());
                  }),
              menuWidget(
                  icon: policiesIc,
                  menu: 'privacyPolicy'.tr,
                  onTap: () {
                    openInAppWebViewPolicy();
                    Get.back();
                  }),
              menuWidget(
                  icon: policiesIc,
                  menu: 'TandC'.tr,
                  onTap: () {
                    openInAppWebViewTerms();
                    Get.back();
                  }),
              //Hide Logout
              // menuWidget(
              //     icon: logoutIc,
              //     menu: 'logout'.tr,
              //     onTap: () {
              //       Get.dialog(AskDialog(
              //           msg: 'confirmLogout'.tr, yesFunction: yesFunction));
              //     }),
              SizedBox(
                height: height * 0.02,
              ),
              divider(),
              SizedBox(
                height: height * 0.05,
              ),
              media()
            ],
          ),
        ),
      ),
    );
  }

  ///
  ///
  ///

  // Widget language() {
  //   return Card(
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 2,
  //           child: ListTile(
  //             horizontalTitleGap: 20,
  //             minLeadingWidth: 18.0,
  //             onTap: () {},
  //             leading: Icon(
  //               Icons.language_outlined,
  //               color: MyColor.appColor,
  //               size: 20,
  //             ),
  //             title: Text(
  //               "App Language".tr,
  //               style: TextStyle(
  //                   color: MyColor.color4F4C4C,
  //                   fontSize: 16,
  //                   fontFamily: MyFont.roboto,
  //                   fontWeight: MyFontWeight.regular),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: DropdownButton<String>(
  //               value: selectedLanguage,
  //               hint: Text("Select"),
  //               items: languages.map((lang) {
  //                 return DropdownMenuItem<String>(
  //                   value: lang['value'],
  //                   child: Text(lang['label']!),
  //                 );
  //               }).toList(),
  //               // onChanged: (String? newValue) async {
  //               //   if (newValue != null) {
  //               //     setState(() {
  //               //       selectedLanguage = newValue;
  //               //       MyLangCode.langcode = (newValue == 'en') ? 2 : 1;
  //               //     });
  //               onChanged: (String? newValue) async {
  //                 if (newValue != null) {
  //                   setState(() {
  //                     selectedLanguage = newValue;
  //                   });
  //                   // Set new locale

  //                   Locale newLocale = (newValue == 'hi')
  //                       ? const Locale('hi', 'IN')
  //                       : const Locale('en', 'US');
  //                   await MySharedPreference().saveLocale(newLocale);

  //                   // Update global langcode
  //                   MyLangCode.langcode = (newValue == 'en') ? 2 : 1;

  //                   // Update GetX locale
  //                   Get.updateLocale(newLocale);

  //                   artistHomeController.getCategoriesData(
  //                       langCode: MyLangCode.langcode);

  //                   // Locale newLocale = (newValue == 'en')
  //                   //     ? const Locale('en', 'US')
  //                   //     : const Locale('hi', 'IN');

  //                   // await MySharedPreference().saveLocale(newLocale);
  //                   // Get.updateLocale(newLocale);

  //                   print('Selected Language: $newValue');
  //                 }
  //               }),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget language() {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListTile(
              horizontalTitleGap: 20,
              minLeadingWidth: 18.0,
              onTap: () {},
              leading: Icon(
                Icons.language_outlined,
                color: MyColor.appColor,
                size: 20,
              ),
              title: Text(
                "App Language".tr,
                style: TextStyle(
                    color: MyColor.color4F4C4C,
                    fontSize: 16,
                    fontFamily: MyFont.roboto,
                    fontWeight: MyFontWeight.regular),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EN',
                  style: TextStyle(
                      fontSize: 14,
                      color: selectedLanguage == 'en'
                          ? MyColor.appColor
                          : Colors.grey),
                ),
                Switch(
                  value: selectedLanguage == 'hi',
                  activeColor: MyColor.appColor,
                  onChanged: (bool isHindi) async {
                    String newValue = isHindi ? 'hi' : 'en';

                    setState(() {
                      selectedLanguage = newValue;
                    });

                    Locale newLocale = (newValue == 'hi')
                        ? const Locale('hi', 'IN')
                        : const Locale('en', 'US');

                    await MySharedPreference().saveLocale(newLocale);
                    MyLangCode.langcode = (newValue == 'en') ? 2 : 1;
                    Get.updateLocale(newLocale);

                    artistHomeController.getCategoriesData(
                        langCode: MyLangCode.langcode);

                    print('Selected Language: $newValue');
                  },
                ),
                Text(
                  'HI',
                  style: TextStyle(
                      fontSize: 14,
                      color: selectedLanguage == 'hi'
                          ? MyColor.appColor
                          : Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  header() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), // optional: add some curve
        bottomLeft: Radius.circular(10),
      ),
      child: Container(
          height: height * 0.164,
          width: width,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 13, bottom: 0, top: 40),
          child: Container(
            // height: height * 0.164,
            // width: width,
            // color: MyColor.appColor.withAlpha(90),
            // padding: const EdgeInsets.only(left: 13, bottom: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // widget.callFrom == 'Artist'
                //     ?
                // Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border: Border.all(width: 1.5, color: Colors.white),
                //     ),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(height / 2),
                //       child: widget.profileData?.userProfile != null &&
                //               widget.profileData!.userProfile!.isNotEmpty
                //           ? Image.network(
                //               widget.profileData!.userProfile!,
                //               width: 120,
                //               height: 120,
                //               fit: BoxFit.cover,
                //               errorBuilder: (context, exception, stackTrace) {
                //                 return Image(
                //                   image: noProfilePic,
                //                   width: 45,
                //                   height: 45,
                //                 );
                //               },
                //             )
                //           : Image(
                //               image: noProfilePic,
                //               width: 120,
                //               height: 120,
                //             ),
                //     ),
                //   ),
                // :
                // CircleAvatar(
                //     radius: 50,
                //     backgroundColor: Colors.grey.shade300,
                //     child: Image.asset(
                //       "assets/images/user.png",
                //       height: 70,
                //     )),

                const SizedBox(height: 10),

                // Name below the image
                // widget.callFrom == 'Artist'
                //     ? Text(
                //         widget.profileData!.name.toString(),
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           // color: MyColor.appColor,
                //           color: Colors.black,
                //           fontFamily: MyFont.roboto,
                //           fontWeight: MyFontWeight.regular,
                //           fontSize: 17,
                //         ),
                //       )
                //     : Text(
                //         'drawerTitle'.tr,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           // color: MyColor.appColor,
                //           color: Colors.black,
                //           fontFamily: MyFont.roboto,
                //           fontWeight: MyFontWeight.regular,
                //           fontSize: 20,
                //         ),
                //       ),
                // widget.callFrom == 'Artist'
                //     ? Text(
                //         widget.profileData!.email_id.toString(),
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           // color: MyColor.appColor,
                //           color: Colors.black,
                //           fontFamily: MyFont.roboto,
                //           fontWeight: MyFontWeight.regular,
                //           fontSize: 17,
                //         ),
                //       )
                //     : Text(
                //         'drawerTitle'.tr,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           // color: MyColor.appColor,
                //           color: Colors.black,
                //           fontFamily: MyFont.roboto,
                //           fontWeight: MyFontWeight.regular,
                //           fontSize: 20,
                //         ),
                //       ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SequentialSlidingFooter(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // widget.callFrom == 'Artist'
                          //     ? widget.profileData?.name ?? ''
                          //     :
                          'Welcome'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.regular,
                            fontSize:
                                // widget.callFrom == 'Artist' ? 17 :
                                16,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          // widget.callFrom == 'Artist'
                          //     ? widget.profileData?.email_id ?? ''
                          //     :
                          'guest'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.regular,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ) // your full Column here
          ),
    );
  }

  ///
  ///
  ///
  // menuWidget({required icon, required menu, required Function() onTap}) {
  //   return Card(
  //     child: ListTile(
  //       horizontalTitleGap: 20,
  //       minLeadingWidth: 18.0,
  //       onTap: onTap,
  //       leading: Image(
  //         image: icon,
  //         height: 18.0,
  //         width: 18.0,
  //         color: MyColor.appColor,
  //       ),
  //       title: Text(
  //         menu,
  //         style: TextStyle(
  //             color: MyColor.color4F4C4C,
  //             fontSize: 16,
  //             fontFamily: MyFont.roboto,
  //             fontWeight: MyFontWeight.regular),
  //       ),
  //     ),
  //   );
  // }

  positionTween({required Offset begin, required Offset end}) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    );
  }

  Widget menuWidget({
    required ImageProvider icon,
    required String menu,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white, // or Theme.of(context).cardColor
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColor.appColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image(
                image: icon,
                height: 22,
                width: 22,
                color: MyColor.appColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                menu,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 16,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.medium,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  divider() {
    return Container(
      height: 20,
      decoration:
          BoxDecoration(image: DecorationImage(image: gradientDividerImg)),
    );
  }

  Future<void> openMediaApp(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  ///
  ///
  ///
  media() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              openMediaApp("https://www.instagram.com/upculturedept/");
            },
            borderRadius: BorderRadius.circular(100),
            child: Image(
              image: instagramIc,
              height: 30.0,
              width: 30.0,
            ),
          ),
          InkWell(
            onTap: () {
              openMediaApp(
                  "https://www.youtube.com/c/UPCultureDepartmentOfficial");
            },
            borderRadius: BorderRadius.circular(100),
            child: Image(
              image: youtubeIc,
              height: 30.0,
              width: 30.0,
            ),
          ),
          InkWell(
            onTap: () {
              openMediaApp("https://www.facebook.com/upculturedept");
            },
            borderRadius: BorderRadius.circular(100),
            child: Image(
              image: facebookIc,
              height: 30.0,
              width: 30.0,
            ),
          )
        ],
      ),
    );
  }

  ///
  ///
  ///
  yesFunction() {
    MySharedPreference.logout();
    Get.offAll(() => const SelectRoleScreen());
  }
}
