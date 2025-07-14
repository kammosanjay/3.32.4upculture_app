import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/model/artist/response/category_list_response.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

import 'package:upculture/screen/artist/sub_category_screen.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:upculture/screen/common/lngCodee.dart';
import 'artist/artist_category_screen.dart';

import 'artist/misc_sub_screen.dart';
import 'artist/search_screen.dart';

// ignore: must_be_immutable
class AllCategoryScreen extends StatefulWidget {
  List<Data> categoryList;
  String? callfrom;
  AllCategoryScreen({Key? key, required this.categoryList, this.callfrom})
      : super(key: key);

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  late List<Data> categoryList;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryList = widget.categoryList;
  }

  String selectedLanguage = 'hi';

  final List<Map<String, String>> languages = [
    {'value': 'hi', 'label': 'हिंदी'},
    {'value': 'en', 'label': 'English'},
  ];
  ArtistHomeController artistHomeController = Get.find<ArtistHomeController>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Obx(() {
      print("=======?" + widget.callfrom.toString());
      return Scaffold(
        backgroundColor: Colors.white,
        // endDrawer: ArtistEndDrawer(
        //     callFrom: widget.callfrom,
        //     profileData: artistHomeController.profileData),
        appBar: AppBar(
          actions: [
            Container(
              height: 50,
              width: 100,
              child: language(),
            )
          ],
          elevation: 0,
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
                  )),
              // SizedBox(
              //   width: 20,
              // ),
            ],
          ),
        ),
        body: ListView(
          children: [
            categoryList.isNotEmpty ? categoryListWidget() : const SizedBox(),
   
          ],
        ),
      );
    });
  }

  ///
  ///
  ///
  categoryListWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        child: LayoutGrid(
          gridFit: GridFit.expand,

          columnSizes: [
            1.fr,
            1.fr,
            1.fr,
          ],
          // columnSizes: [
          // (width * 0.26).px,
          // (width * 0.26).px,
          // (width * 0.26).px
          // ],
          rowSizes: List<IntrinsicContentTrackSize>.generate(
              (categoryList.length), (int index) => auto),
          columnGap: 10,
          rowGap: 10,
          children: [
            // user -1 into category.length to remove Artist category
            for (var index = 1; index < categoryList.length-1; index++)
              InkWell(
                onTap: () async {
                  if (categoryList[index].id.toString() == "18") {
                    print('SubCategoryId :${categoryList[index].id!}');
                    print('test1');
                    Get.to(() => MiscSubScreen(categoryName: "", id: 2));
                  } else if (categoryList[index].id.toString() == "31") {
                    print('test2');
                    print('SubCategoryId :${categoryList[index].id!}');
                    Get.to(() => ArtistCategoryScreen(
                        categoryName: categoryList[index].category!,
                        id: categoryList[index].id!));
                  } else if (categoryList[index].id.toString() == "82") {
                    print('test3');
                    print('SubCategoryId :${categoryList[index].id!}');
                    Get.to(() => ArtistCategoryScreen(
                        categoryName: categoryList[index].category!,
                        id: categoryList[index].id!));
                  } else {
                    print('SubCategoryId :${categoryList[index].id!}');
                    print('test4');
                    Get.to(() => SubCategoryScreen(
                          categoryName: categoryList[index].category!,
                          id: categoryList[index].id!,
                          callFrom: widget.callfrom,
                        ));
                  }
                },
                child: SizedBox(
                  width: (width * 0.3),
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          width: width * 0.6,
                          height: height * 0.09,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 5,
                                  //  inset: true,
                                  offset: Offset(2, 3)),
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 1,
                                  inset: true,
                                  offset: Offset(-2, -3))
                            ],
                            // border:
                            //     Border.all(color: MyColor.appColor, width: 1)
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: categoryList[index].photo != null &&
                                    categoryList[index].photo!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: categoryList[index].photo!,
                                    height: 36.0,
                                    width: 33.0,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 36.0,
                                        width: 33.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image(
                                      image: noImage,
                                      height: 36.0,
                                      width: 33.0,
                                    ),
                                  )
                                : Image(
                                    image: noImage,
                                    height: 36.0,
                                    width: 33.0,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        child: Text(
                          categoryList[index].category!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: MyColor.color4F4C4C,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: selectedLanguage,
                style: const TextStyle(color: Colors.white), //
                dropdownColor: MyColor.appColor.withOpacity(0.5),
                // icon: Icon(
                //   Icons.arrow_downward,
                //   color: Colors.white,
                //   size: 20,
                // ),
                icon: SizedBox.shrink(),
                alignment: Alignment.center,
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
                        langCode: MyLangCode.langcode);

                    Locale newLocale = (newValue == 'en')
                        ? const Locale('en', 'US')
                        : const Locale('hi', 'IN');

                    await MySharedPreference().saveLocale(newLocale);
                    Get.updateLocale(newLocale);

                    print('Selected Language: $newValue');
                  }
                }),
          ),
        )
      ],
    );
  }
}
