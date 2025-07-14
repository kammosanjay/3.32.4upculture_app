import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/artist_end_drawer.dart';
import 'package:upculture/screen/artist/category_detail_screen.dart';
import 'package:upculture/screen/artist/culture_sub_category_screen.dart';

import 'package:upculture/screen/artist/search_screen.dart';
import 'package:upculture/screen/common/lngCodee.dart';

// ignore: must_be_immutable
class SubCategoryScreen extends StatefulWidget {
  int id;
  String? categoryName;
  String? callFrom;

  SubCategoryScreen({
    Key? key,
    this.categoryName,
    required this.id,
    this.callFrom,
  }) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  CategoryController getXController = Get.put(CategoryController());
  ArtistHomeController artistHomeController = Get.put(ArtistHomeController());
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(), () {
      if (widget.categoryName == "district".tr) {
        print('testing 1');
        getXController.getCultureCategoriesData(cultureId: widget.id);
      }
      // else if (widget.categoryName == "District") {
      //   print('testing 2');
      //   getXController.getCultureCategoriesData(cultureId: widget.id);
      // }
      else {
        print('testing 3');
        getXController.getSubCategoriesData(categoryId: widget.id);
      }
    });
  }

  String selectedLanguage = 'hi';

  final List<Map<String, String>> languages = [
    {'value': 'hi', 'label': 'हिंदी'},
    {'value': 'en', 'label': 'English'},
  ];

  @override
  Widget build(BuildContext context) {
    print("ksjljlskjslkf====>" + widget.callFrom.toString());
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
              Get.back();
            },
          ),
          // actions: [
          //   Container(
          //     height: 50,
          //     width: 100,
          //     child: language(),
          //   )
          // ],
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: widget.categoryName == "district".tr
              ? cultureCategoryWidget()
              // : widget.categoryName == "District"
              //     ? cultureCategoryWidget()
              : subCategoryWidget(),
        ),
      );
    });
  }

  ///
  ///
  ///
  subCategory() {
    print("testing on District 1");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: LayoutGrid(
          columnSizes: [1.fr, 1.fr, 1.fr],
          rowSizes: List<IntrinsicContentTrackSize>.generate(
            (getXController.subCategoryList.length / 2).round(),
            (int index) => auto,
          ),
          rowGap: 10,
          columnGap: 10,
          children: [
            for (
              var index = 0;
              index < getXController.subCategoryList.length;
              index++
            )
              InkWell(
                onTap: () {
                  //by selecting category redirect to CustomerVendorsScreen
                  // Get.to(() => CustomerVendorsScreen(serviceOrCategoryName: _getXController.categoriesData[index]!.categoryName!,
                  //     categoryId: _getXController.categoriesData[index]!.id.toString(),
                  //     customerAddressModel: widget.customerAddressModel!));
                  print('test4');
                  Get.to(
                    () => CategoryDetailScreen(
                      getXController: getXController,
                      index: index,
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),

                      // border: Border.all(color: MyColor.appColor, width: 1)
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: MyColor.indiaWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 5,
                                offset: Offset(3, 4),
                              ),
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: Offset(-3, -4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            child:
                                getXController.subCategoryList[index].photo !=
                                        null &&
                                    getXController
                                        .subCategoryList[index]
                                        .photo!
                                        .isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: getXController
                                        .subCategoryList[index]
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
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          getXController.subCategoryList[index].name!,
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
      ),
    );
  }

  ///
  ///
  ///
  subCategoryWidget() {
    print("testing on District 2");
    return Column(
      children: [
        getXController.subCategoryList.isNotEmpty
            ? Expanded(child: subCategory())
            : const SizedBox(),
      ],
    );
  }

  ///
  ///
  /// city step 2 e.g Lucknow, Kanpur, Mathura
  cultureCategoryWidget() {
    print("testing on District 3");
    return Column(
      children: [
        getXController.cultureCategoryList.isNotEmpty
            ? Expanded(child: cultureCategory())
            : const SizedBox(),
      ],
    );
  }

  ///
  ///
  ///
  cultureCategory() {
    print("testing on District 4");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: LayoutGrid(
          columnSizes: [1.fr, 1.fr, 1.fr],
          rowSizes: List<IntrinsicContentTrackSize>.generate(
            (getXController.cultureCategoryList.length / 2).round(),
            (int index) => auto,
          ),
          rowGap: 10,
          columnGap: 10,
          children: [
            for (
              var index = 0;
              index < getXController.cultureCategoryList.length;
              index++
            )
              InkWell(
                onTap: () {
                  Get.to(
                    () => CultureSubCategoryScreen(
                      cultureCategoryName:
                          getXController.cultureCategoryList[index].name!,
                      cultureCategoryId:
                          getXController.cultureCategoryList[index].id!,
                      getXController: getXController,
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),

                      // border: Border.all(color: MyColor.appColor, width: 1)
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: MyColor.indiaWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 5,
                                offset: Offset(3, 4),
                              ),
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: Offset(-3, -4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            child:
                                getXController
                                            .cultureCategoryList[index]
                                            .photo !=
                                        null &&
                                    getXController
                                        .cultureCategoryList[index]
                                        .photo!
                                        .isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: getXController
                                        .cultureCategoryList[index]
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
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          getXController.cultureCategoryList[index].name!,
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
      ),
    );
  }

  Widget language() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: DropdownButton<String>(
            value: selectedLanguage,
            style: const TextStyle(color: Colors.white), //
            dropdownColor: MyColor.appColor.withOpacity(0.5),
            icon: Icon(Icons.arrow_downward, color: Colors.white, size: 20),
            items: languages.map((lang) {
              return DropdownMenuItem<String>(
                value: lang['value'],
                child: Text(
                  lang['label']!,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              if (newValue != null) {
                setState(() {
                  selectedLanguage = newValue;
                  MyLangCode.langcode = (newValue == 'en') ? 2 : 1;
                });

                artistHomeController.getCategoriesData(
                  langCode: MyLangCode.langcode,
                );
                getXController.subCategoryList;

                Locale newLocale = (newValue == 'en')
                    ? const Locale('en', 'US')
                    : const Locale('hi', 'IN');

                await MySharedPreference().saveLocale(newLocale);
                Get.updateLocale(newLocale);

                print('Selected Language: $newValue');
              }
            },
          ),
        ),
      ],
    );
  }
}
