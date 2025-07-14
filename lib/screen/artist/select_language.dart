import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/screen/artist/artist_home_screen.dart';
import 'package:upculture/screen/common/sliding.dart';

// ignore: must_be_immutable
class SelectLangWithoutLogin extends StatefulWidget {
  SelectLangWithoutLogin({super.key});

  @override
  State<SelectLangWithoutLogin> createState() => _SelectLangWithoutLoginState();
}

class _SelectLangWithoutLoginState extends State<SelectLangWithoutLogin>
    with SingleTickerProviderStateMixin {
  var controller = Get.find<ArtistHomeController>();
  var categoryC = Get.put(CategoryController());
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
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

  int currentIndex = 0;
  List<String> panoImages = [
    'assets/images/ramji.webp',
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SequentialSlidingFooter(),
        Column(
          children: [
            // Expanded(
            //   child:
            //    Panorama(
            //     child: Image.asset(
            //       panoImages[currentIndex],
            //       fit: BoxFit.cover,
            //     ),
            //     animSpeed: 2,
            //     maxZoom: 2,
            //     minZoom: 1,
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(panoImages.length, (index) {
            //     return IconButton(
            //       icon: Icon(Icons.circle,
            //           color: index == currentIndex ? Colors.blue : Colors.grey),
            //       onPressed: () {
            //         setState(() {
            //           currentIndex = index;
            //         });
            //       },
            //     );
            //   }),
            // )
          ],
        ),
        Positioned(
          top: 40,
          left: 10,
          right: 10,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/splash/splash_img1.png'),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.3),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shape: CircleBorder(),
                      elevation: 10,
                      child: Image.asset(
                        "assets/images/up_gov_logo.png",
                        height: 100,
                      ),
                    ),SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(top: 100),
                    //   child: Center(
                    //     child: Text(
                    //       "Choose Language",
                    //       style: TextStyle(
                    //           fontSize: 26,
                    //           fontWeight: FontWeight.bold,
                    //           color: MyColor.appColor),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 50,
                    // ),
                    Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                          color: MyColor.appColor.withOpacity(0.6),
                          borderRadius:
                              BorderRadiusDirectional.circular(10)),
                      child: TextButton.icon(
                        onPressed: () async {
                          controller.getCategoriesData(langCode: 1);
                    
                          Locale newLocale = const Locale('hi', 'IN');
                    
                          await MySharedPreference().saveLocale(newLocale);
                          Get.updateLocale(Locale(newLocale.toString()));
                          Get.offAll(
                              () => ArtistHomeScreen(
                                    callFrom: 'User',
                                    lang: 1,
                                  ),
                              transition: Transition.zoom);
                        },
                        icon: Icon(Icons.h_mobiledata,color: MyColor.indiaWhite),
                        label: Text(
                          "हिंदी",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyColor.indiaWhite),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                          color: MyColor.appColor.withOpacity(0.6),
                          borderRadius:
                              BorderRadiusDirectional.circular(10)),
                      child: TextButton.icon(
                          onPressed: () async {
                            controller.getCategoriesData(langCode: 2);
                            Locale newLocale = const Locale('en', 'US');
                    
                            await MySharedPreference()
                                .saveLocale(newLocale);
                            Get.updateLocale(Locale(newLocale.toString()));
                            Get.offAll(
                                () => ArtistHomeScreen(
                                      callFrom: 'User',
                                      lang: 2,
                                    ),
                                transition: Transition.zoom);
                          },
                          icon: Icon(Icons.e_mobiledata,color: MyColor.indiaWhite),
                          label: Text(
                            "English",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyColor.indiaWhite),
                          )),
                    )
                  ],
                ),
              )),
        ),
      ]),
    );
  }

  positionTween({required Offset begin, required Offset end}) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    );
  }
}
