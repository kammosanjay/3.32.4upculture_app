import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/artist/artist_home_controller.dart';

class MiscDetailsScreen extends StatefulWidget {
  int id;

  MiscDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<MiscDetailsScreen> createState() => _MiscDetailsScreenState();
}

class _MiscDetailsScreenState extends State<MiscDetailsScreen> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  ArtistHomeController getXController = Get.put(ArtistHomeController());
  late int index;
  late double height;
  late double width;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });

    // TODO: implement initState
    super.initState();
  }

  // getData() async {
  //   getXController.miscDetailsData.clear();
  //   getXController.miscSliderData.clear();
  //   setState(() {});
  //   await getXController.getMiscSliderData(widget.id);
  //   setState(() {});
  //   await getXController.getMiscDetailsData(widget.id);
  //   setState(() {});
  // }
  getData() async {
    setState(() {
      getXController.miscDetailsData.clear();
      getXController.miscSliderData.clear();
    });

    await getXController.getMiscSliderData(widget.id);
    await getXController.getMiscDetailsData(widget.id);

    setState(() {}); // Only one setState after data is fully loaded
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.appColor,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 30,
        title: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Image(
                    image: upGovLogo,
                    height: 30.0,
                    width: 30.0,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
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
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            // const Icon(
            //   Icons.search,
            //   color: Colors.white,
            // )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
        child: Column(
          children: [
            getXController.miscSliderData.isNotEmpty
                ? categoryGallery()
                : const SizedBox(),
            if (getXController.miscDetailsData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: getXController.miscDetailsData.length,
                  // scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  MyGlobal.checkNullData(
                                    getXController.miscDetailsData[index].name,
                                  ),
                                  style: TextStyle(
                                    color: MyColor.color1F140A,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.semiBold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (getXController.miscDetailsData[index].startTime !=
                                null &&
                            getXController.miscDetailsData[index].startTime
                                .toString()
                                .isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.appColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "समय",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: MyFont.roboto,
                                          fontWeight: MyFontWeight.regular,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        MyGlobal.checkNullData(
                                          "${getXController.miscDetailsData[index].startTime!} से ${getXController.miscDetailsData[index].endTime!}",
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: MyFont.roboto,
                                          fontWeight: MyFontWeight.medium,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (getXController.miscDetailsData[index].address !=
                                null &&
                            getXController.miscDetailsData[index].address
                                .toString()
                                .isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.appColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "पता",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: MyFont.roboto,
                                          fontWeight: MyFontWeight.regular,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        MyGlobal.checkNullData(
                                          getXController
                                              .miscDetailsData[index]
                                              .address!,
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: MyFont.roboto,
                                          fontWeight: MyFontWeight.medium,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        MyGlobal.checkNullData(
                              getXController.miscDetailsData[index].description,
                            ).isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Html(
                                  data:
                                      '${getXController.miscDetailsData[index].description}',
                                  onLinkTap: (str, data, element) {
                                    print(str);
                                    launchUrl(
                                      Uri.parse(str!),
                                      mode: LaunchMode.inAppWebView,
                                    );
                                  },
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  categoryGallery() {
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
                  itemCount: getXController.miscSliderData.length,
                  itemBuilder: (context, index, position) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child:
                          getXController.miscSliderData[index].photo != null &&
                              getXController
                                  .miscSliderData[index]
                                  .photo!
                                  .isNotEmpty
                          ? Image.network(
                              getXController.miscSliderData[index].photo!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder:
                                  (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
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
                    enlargeFactor: 0.2,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    autoPlay: getXController.miscSliderData.length != 1
                        ? true
                        : false,
                    enableInfiniteScroll:
                        getXController.miscSliderData.length != 1
                        ? true
                        : false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPos = index;
                      });
                    },
                  ),
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
            children: getXController.miscSliderData.map((url) {
              int index = getXController.miscSliderData.indexOf(url);
              return Container(
                width: 15.0,
                height: 7.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPos == index
                      ? MyColor.appColor
                      : const Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
