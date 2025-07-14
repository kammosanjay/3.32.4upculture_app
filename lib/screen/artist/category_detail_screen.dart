import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/artist_end_drawer.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CategoryDetailScreen extends StatefulWidget {
  int index;
  CategoryController getXController;
  bool fromSearch;

  int id;

  CategoryDetailScreen({
    Key? key,
    required this.getXController,
    required this.index,
    this.fromSearch = false,
    this.id = -1,
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  CarouselController buttonCarouselController = CarouselController();
  ArtistHomeController artistHomeController = Get.put(ArtistHomeController());

  int currentPos = 0;
  late CategoryController getXController;
  late int index;
  late double height;
  late double width;
  final RxDouble fontSize = 14.0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = Get.put(CategoryController());
    Future.delayed(const Duration(), () {
      getData();
    });
  }

  getData() async {
    getXController = widget.getXController;
    index = widget.index;
    getXController.subCategoryGalleryList.clear();
    // setState(() {});
    await getXController.getSubCategoryGallery(
      subCategoryId: widget.fromSearch
          ? widget.id
          : getXController.subCategoryList[index].id,
    );
    // setState(() {});
    await getXController.getSubCategoryDetail(
      subCategoryId: widget.fromSearch
          ? widget.id
          : getXController.subCategoryList[index].id,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.appColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 30,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              clearAllDetail();
              Get.back();
            },
          ),
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
              InkWell(
                onTap: () {
                  Get.to(const SearchScreen());
                },
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: Column(
            children: [
              getXController.subCategoryGalleryList.isNotEmpty
                  ? categoryGallery()
                  : const SizedBox(),
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
                  ),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      MyGlobal.checkNullData(
                            getXController.subCategoryData.value.description,
                          ).isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Html(
                                data:
                                    '${getXController.subCategoryData.value.description}',
                                onLinkTap: (str, data, element) {
                                  // print(str);
                                  launchUrl(
                                    Uri.parse(str!),
                                    mode: LaunchMode.inAppWebView,
                                  );
                                },
                                style: {
                                  'body': Style(
                                    fontSize: FontSize(fontSize.value),
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    color: Colors.black,
                                  ),
                                },
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
          // margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: buttonCarouselController,
                  itemCount: getXController.subCategoryGalleryList.length,
                  itemBuilder: (context, index, position) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child:
                          getXController.subCategoryGalleryList[index].photo !=
                                  null &&
                              getXController
                                  .subCategoryGalleryList[index]
                                  .photo!
                                  .isNotEmpty
                          ? Image.network(
                              getXController
                                  .subCategoryGalleryList[index]
                                  .photo!,
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
                    autoPlay: getXController.subCategoryGalleryList.length != 1
                        ? true
                        : false,
                    enableInfiniteScroll:
                        getXController.subCategoryGalleryList.length != 1
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
            children: getXController.subCategoryGalleryList.map((url) {
              int index = getXController.subCategoryGalleryList.indexOf(url);
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

  ///
  ///
  ///
  void clearAllDetail() {
    getXController.subCategoryGalleryList.clear();
    getXController.subCategoryData.value.id = null;
    getXController.subCategoryData.value.cId = null;
    getXController.subCategoryData.value.name = null;
    getXController.subCategoryData.value.photo = null;
    getXController.subCategoryData.value.status = null;
    getXController.subCategoryData.value.createdAt = null;
    getXController.subCategoryData.value.updatedAt = null;
    getXController.subCategoryData.value.address = null;
    getXController.subCategoryData.value.description = null;
  }
}
