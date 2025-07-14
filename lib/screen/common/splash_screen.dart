import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:upculture/controller/artist/artist_onboarding_controller.dart';
import 'package:upculture/local_database/key_constants.dart';
import 'package:upculture/local_database/my_shared_preference.dart';

import 'package:upculture/screen/artist/artist_home_screen.dart';
import 'package:upculture/screen/artist/select_language.dart';
import 'package:upculture/screen/common/lngCodee.dart';
import 'package:upculture/screen/common/select_role_screen.dart';
import 'package:upculture/screen/common/splashanimation.dart';
import 'package:upculture/screen/common/splashscreenone.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ArtistOnboardingController getXController =
      Get.put(ArtistOnboardingController());
  late double height;
  late double width;

  final _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    // Initialize shared preferences
    MySharedPreference.getInstance();

    // Call getTypesOfArtist with a delay
    Future.delayed(const Duration(seconds: 5), () {
      getXController.getTypesOfArtist();
    });

    // Add a small delay before changing the page
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.animateToPage(
          1, // Navigate to page 1
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    handleSession();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [SplashScreenPage(), SplashScreenone()],
        scrollDirection: Axis.horizontal,
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  ///
  ///
  ///
  void handleSession() {
    // print("testing===>${MySharedPreference.getInt(KeyConstants.keyUserId)}");
    Future.delayed(const Duration(seconds: 2), () {
      // if (MySharedPreference.getBool(KeyConstants.keyIsLogin) != null &&
      //     MySharedPreference.getBool(KeyConstants.keyIsLogin)) {
      //   if (MySharedPreference.getInt(KeyConstants.keyUserId) != null &&
      //       MySharedPreference.getInt(KeyConstants.keyUserId) != 0) {
      //     Get.offAll(() => ArtistHomeScreen(
      //           callFrom: 'Artist',
      //           lang: MyLangCode.langcode,
      //         ));

      //         print("artishomescreelang->"+MyLangCode.langcode.toString());
      //   }
      // } else {

      Timer(Duration(seconds: 3), () {
        // Get.offAll(() => const SelectRoleScreen(),transition:Transition.zoom);
        Get.offAll(() => SelectLangWithoutLogin(), transition: Transition.zoom);
      });
    }
        // }
        );
  }
}
