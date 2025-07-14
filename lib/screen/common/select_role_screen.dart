import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/screen/artist/artist_login_screen.dart';

import 'package:upculture/screen/artist/select_language.dart';
import 'package:upculture/screen/common/sliding.dart';

import '../artist/register_src_new.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({Key? key}) : super(key: key);

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen>
    with SingleTickerProviderStateMixin {
  late double height;
  late double width;
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
        body: Stack(children: [
      SequentialSlidingFooter(),
      Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glowing circular logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MyColor.appColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Card(
                  shape: const CircleBorder(),
                  elevation: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/images/up_gov_logo.png",
                      height: 90,
                      width: 90,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'userLogin'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColor.color1F140A,
                  fontSize: 22,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.bold,
                  shadows: [
                    Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 4),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // User Button
              optionWidget(
                icon: userIc,
                label: 'generalUser'.tr,
                callFrom: 'User',
              ),
              const SizedBox(height: 20),

              // Artist Button
              optionWidget(
                icon: artistIc,
                label: 'artistLogin'.tr,
                callFrom: 'Artist',
              ),
            ],
          ),
        ),
      )
   
   
   
    ]));
  }

  ///
  ///
  ///

  Widget optionWidget({
    required ImageProvider icon,
    required String label,
    required String callFrom,
  }) {
    return Bounceable(
      onTap: () {
        // if (callFrom == 'Artist') {
        //   print('Artist login');
        //   Get.to(() => ArtistLoginScreen(), transition: Transition.zoom);
        // } else {
        //   print('General User');
        //   Get.to(() => SelectLangWithoutLogin(), transition: Transition.zoom);
        // }
        Get.to(() => SelectLangWithoutLogin(), transition: Transition.zoom);
      },
      child: Container(
        height: height * 0.08,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), // semi-transparent
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyColor.appColor.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              MyColor.appColor.withOpacity(0.08),
              Colors.white.withOpacity(0.05)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: height * 0.08,
              height: height * 0.08,
              decoration: BoxDecoration(
                color: MyColor.appColor.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
              ),
              padding: const EdgeInsets.all(12),
              child: Image(image: icon),
            ),
            const SizedBox(width: 12),

            // Label text
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 16,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  positionTween({required Offset begin, required Offset end}) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    );
  }
}
