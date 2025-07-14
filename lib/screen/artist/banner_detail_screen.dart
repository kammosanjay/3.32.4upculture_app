
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/banner_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:upculture/utils/my_global.dart';

class BannerDetailScreen extends StatefulWidget {
  int bannerId;

  BannerDetailScreen({Key? key, required this.bannerId}) : super(key: key);

  @override
  State<BannerDetailScreen> createState() => _BannerDetailScreenState();
}

class _BannerDetailScreenState extends State<BannerDetailScreen> {
  BannerController getXController = Get.put(BannerController());
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(), () {
      getXController.getGalleryDetail(bannerId: widget.bannerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 30,
          title: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  /*Image(
                        image: backArrow,
                        height: 24.0,
                        width: 24.0,
                        color: Colors.white,
                      ),
*/

                  // const SizedBox(width: 10,),
                  Image(
                    image: upGovLogo,
                    height: 30.0,
                    width: 30.0,
                    color: Colors.white,
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      // MyString.drawerTitle
                      'drawerTitle'.tr,
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontFamily: MyFont.roboto,
                          fontWeight: MyFontWeight.regular,
                          fontSize: 20),
                    ),
                  ),
                ],
              )),
              InkWell(
                  onTap: () {
                    Get.to(const SearchScreen());
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            children: [
              getXController.bannerGallery.isNotEmpty
                  ? bannerGallery()
                  : const SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      MyGlobal.checkNullData(
                          getXController.bannerDetail.value.name),
                      style: TextStyle(
                          color: MyColor.color1F140A,
                          fontFamily: MyFont.roboto,
                          fontWeight: MyFontWeight.semiBold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Text(
                  MyGlobal.checkNullData(
                      getXController.bannerDetail.value.description),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: MyColor.color4F4C4C,
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.regular,
                      fontSize: 14),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  bannerGallery() {
    return Column(
      children: [
        Container(
          height: height * 0.2,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: buttonCarouselController,
                  itemCount: getXController.bannerGallery.length,
                  itemBuilder: (context, index, position) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: getXController.bannerGallery[index].photo !=
                                  null &&
                              getXController
                                  .bannerGallery[index].photo!.isNotEmpty
                          ? Image.network(
                              getXController.bannerGallery[index].photo!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Image(
                              image: noImage,
                              width: double.infinity,
                              height: height * 0.2,
                              fit: BoxFit.fill,
                            ),
                    );
                  },
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: getXController.bannerGallery.length != 1
                          ? true
                          : false,
                      enableInfiniteScroll:
                          getXController.bannerGallery.length != 1
                              ? true
                              : false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPos = index;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getXController.bannerGallery.map((url) {
              int index = getXController.bannerGallery.indexOf(url);
              return Container(
                width: 15.0,
                height: 7.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPos == index
                      ? MyColor.appColor
                      : const Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
