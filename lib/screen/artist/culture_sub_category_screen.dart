import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/culture_sub_category_detail_screen.dart';
import 'package:upculture/screen/artist/culture_sub_category_product_list_screen.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CultureSubCategoryScreen extends StatefulWidget {
  int cultureCategoryId;
  String? cultureCategoryName;
  CategoryController getXController;

  CultureSubCategoryScreen({
    Key? key,
    this.cultureCategoryName,
    required this.cultureCategoryId,
    required this.getXController,
  }) : super(key: key);

  @override
  State<CultureSubCategoryScreen> createState() => _CultureSubCategoryScreen();
}

class _CultureSubCategoryScreen extends State<CultureSubCategoryScreen> {
  late CategoryController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;

    Future.delayed(const Duration(), () {
      getXController.getCultureSubCategoriesData(
        cultureCategoryId: widget.cultureCategoryId,
      );
    });
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
          leadingWidth: 30,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: getXController.cultureSubCategoryList.isNotEmpty
                ? cultureSubCategoryWidget()
                : const SizedBox(),
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  cultureSubCategoryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          LayoutGrid(
            columnSizes: [1.fr, 1.fr],
            rowSizes: List<IntrinsicContentTrackSize>.generate(
              (getXController.cultureSubCategoryList.length / 2).round(),
              (int index) => auto,
            ),
            rowGap: 10,
            columnGap: 10,
            children: [
              for (
                var index = 0;
                index < getXController.cultureSubCategoryList.length;
                index++
              )
                InkWell(
                  onTap: () {
                    /*Get.to(() => CultureSubCategoryDetailScreen(
                        cultureSubCategoryId: getXController.cultureSubCategoryList[index].id!,
                        getXController: getXController));*/

                    Get.to(
                      () => CultureSubCategoryProductListScreen(
                        cultureSubCategoryId:
                            getXController.cultureSubCategoryList[index].id!,
                        getXController: getXController,
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        // border: Border.all(color: MyColor.appColor, width: 1)
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child:
                                getXController
                                            .cultureSubCategoryList[index]
                                            .photo !=
                                        null &&
                                    getXController
                                        .cultureSubCategoryList[index]
                                        .photo!
                                        .isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: getXController
                                        .cultureSubCategoryList[index]
                                        .photo!,
                                    fit: BoxFit.cover,
                                    height: Get.height * 0.15,
                                    width: double.infinity,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            height: Get.height * 0.15,
                                            width: double.infinity,
                                            color: Colors.white,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => Image(
                                      image: noImage,
                                      height: Get.height * 0.15,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image(
                                    image: noImage,
                                    height: Get.height * 0.15,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            getXController.cultureSubCategoryList[index].name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColor.color4F4C4C,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          GestureDetector(
            onTap: () {
              launchUrl(
                Uri.parse(getXController.cityUrl.value.toString()),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                MyString.viewMore,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: width * 0.038,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
