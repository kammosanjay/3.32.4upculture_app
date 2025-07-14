import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:url_launcher/url_launcher.dart';

class CultureSubCategoryProductListScreen extends StatefulWidget {
  int cultureSubCategoryId;
  CategoryController getXController;
  bool forSearch;
  String sliderUrl = "";
  CultureSubCategoryProductListScreen(
      {Key? key,
      required this.cultureSubCategoryId,
      this.forSearch = false,
      required this.getXController,
      this.sliderUrl = ""})
      : super(key: key);

  @override
  State<CultureSubCategoryProductListScreen> createState() =>
      _CultureSubCategoryProductListScreenState();
}

class _CultureSubCategoryProductListScreenState
    extends State<CultureSubCategoryProductListScreen> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  late CategoryController getXController;
  late double height;
  late double width;
  final RxDouble fontSize = 14.0.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
    Future.delayed(const Duration(), () {
      if (widget.forSearch) {
        getXController.getCultureSubCategorySliderItemDetail(
            cultureSubCategoryId: widget.cultureSubCategoryId,
            sliderUrl: widget.sliderUrl);
      } else {
        getXController.getCultureSubCategorySlider(
            cultureSubCategoryId: widget.cultureSubCategoryId);
      }
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
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: Column(
            children: [
              // getXController.cultureSubCategorySliderList.isNotEmpty
              //     ? subCategorySlider()
              //     : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text('Text Size'),
                        Container(
                          width: 150,
                          child: Slider(
                            value: fontSize.value,
                            min: 14.0, // Minimum font size
                            max: 25.0, // Maximum font size
                            divisions: 30, // Optional, for smooth stepping
                            label: fontSize.value.toStringAsFixed(1),
                            onChanged: (value) {
                              fontSize.value = value;
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              getXController.cultureSubCategoryProductList.isNotEmpty
                  ? productList()
                  : const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  subCategorySlider() {
    return SizedBox(
      height: height * 0.3,
      child: Column(
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
                    itemCount:
                        getXController.cultureSubCategorySliderList.length,
                    itemBuilder: (context, index, position) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: getXController
                                        .cultureSubCategorySliderList[index]
                                        .photo !=
                                    null &&
                                getXController
                                    .cultureSubCategorySliderList[index]
                                    .photo!
                                    .isNotEmpty
                            ? Image.network(
                                getXController
                                    .cultureSubCategorySliderList[index].photo!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                        autoPlay: getXController
                                    .cultureSubCategorySliderList.length !=
                                1
                            ? true
                            : false,
                        enableInfiniteScroll: getXController
                                    .cultureSubCategorySliderList.length !=
                                1
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
            height: 10,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getXController.cultureSubCategorySliderList.map((url) {
                int index =
                    getXController.cultureSubCategorySliderList.indexOf(url);
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
      ),
    );
  }

  ///
  ///
  ///
  productList() {
    return Expanded(
      child: ListView.builder(
        // separatorBuilder: (BuildContext context, int index) => Divider(height: 1.5, color: MyColor.appColor,),
        itemCount: getXController.cultureSubCategoryProductList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*Row(
                         children: [
                           Expanded(
                             child: Text(
                               MyGlobal.checkNullData(getXController.cultureSubCategoryProductList[index].name),
                               style: TextStyle(
                                   color: MyColor.color1F140A,
                                   fontFamily: MyFont.roboto,
                                   fontWeight: MyFontWeight.semiBold,
                                   fontSize: 16
                               ),
                             ),
                           ),
                         ],
                       ),
*/

                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: getXController.cultureSubCategoryProductList[index]
                                      .photo !=
                                  null &&
                              getXController
                                  .cultureSubCategoryProductList[index]
                                  .photo!
                                  .isNotEmpty
                          ? Image.network(
                              getXController
                                  .cultureSubCategoryProductList[index].photo!,
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
                              height: height * 0.16,
                              fit: BoxFit.fill,
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    /*Text(
                         MyGlobal.checkNullData(getXController.cultureSubCategoryProductList[index].description),
                         textAlign: TextAlign.start,
                         style: TextStyle(
                             color: MyColor.color4F4C4C,
                             fontFamily: MyFont.roboto,
                             fontWeight: MyFontWeight.regular,
                             fontSize: 14
                         ),
                       )*/

                    MyGlobal.checkNullData(getXController
                                .cultureSubCategoryProductList[index]
                                .description)
                            .isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Html(
                              data:
                                  '${getXController.cultureSubCategoryProductList[index].description}',
                              onLinkTap: (str, data, element) {
                                print(str);
                                launchUrl(Uri.parse(str!),
                                    mode: LaunchMode.inAppWebView);
                              },
                              style: {
                                "body": Style(
                                  fontSize: FontSize(fontSize.value),
                                  color: MyColor.color4F4C4C,
                                  fontFamily: MyFont.roboto,
                                  fontWeight: MyFontWeight.regular,
                                ),
                              },
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
