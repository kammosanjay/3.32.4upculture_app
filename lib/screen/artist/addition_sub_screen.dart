import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/controller/artist/category_controller.dart';

import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/artist_category_details_screen.dart';

import 'package:upculture/screen/artist/category_detail_screen.dart';
import 'package:upculture/screen/artist/culture_details_screen.dart';
import 'package:upculture/screen/artist/culture_heritage_detail_screen.dart';
import 'package:upculture/screen/artist/culture_sub_category_product_list_screen.dart';
import 'package:upculture/screen/artist/culture_sub_category_screen.dart';

import 'package:upculture/screen/artist/external_detail_screen.dart';

import 'package:upculture/screen/common/latestChangeEvent.dart';

import 'sub_category_screen.dart';

class AdditionSubScreen extends StatefulWidget {
  const AdditionSubScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AdditionSubScreen> createState() => _AdditionSubScreenState();
}

class _AdditionSubScreenState extends State<AdditionSubScreen> {
  ArtistHomeController getXController = Get.put(ArtistHomeController());
  CategoryController categoryController = Get.put(CategoryController());
  late double height;
  late double width;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });

    super.initState();
  }

  getData() async {
    getXController.newAdditionList.clear();
    await getXController.getNewAddition();
    setState(() {});
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
          elevation: 0,
          leadingWidth: 30,
          title: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
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
                    child:  Text(
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
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: ListView(
              children: [
                getXController.newAdditionList.isNotEmpty
                    ? subCategory()
                    : Center(
                        child: SizedBox(
                          child: Center(child: Text("No Changes Available")),
                        ),
                      )
              ],
            )),
      );
    });
  }

  ///
  ///
  ///
  subCategory() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          height: Get.height,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              // Two columns
              crossAxisSpacing:10,
              // Spacing between columns
              mainAxisSpacing:10,
              mainAxisExtent: 100,
              // Spacing between rows
              childAspectRatio: 1, // Adjust ratio as needed
            ),
            itemCount: getXController.newAdditionList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Navigate based on the type
                  final type = getXController.newAdditionList[index].type;
                  final id = getXController.newAdditionList[index].id!;
                  final name = getXController.newAdditionList[index].type!;

                  if (type == 'city/category') {
                    print('testing1');
                    Get.to(
                      () => CultureSubCategoryProductListScreen(
                          cultureSubCategoryId: id,
                          getXController: categoryController),
                    );
                  } else if (type == 'category') {
                    print('testing2');
                    Get.to(() => SubCategoryScreen(id: id));
                  } else if (type == 'category/sub_category') {
                    print('testing3');
                    Get.to(() => CategoryDetailScreen(
                        index: -1,
                        fromSearch: true,
                        id: id ?? 0,
                        getXController: CategoryController()));
                  } else if (type == 'city') {
                    print('testing4');
                    Get.to(() => CultureSubCategoryScreen(
                          cultureCategoryId: id,
                          getXController: categoryController,
                        ));
                  } else if (type == 'culture_program') {
                    print('testing5');
                    Get.to(() => CultureDetailsScreen(id: id));
                  } else if (type == 'culture_program') {
                    print('testing6');
                    Get.to(() => CultureDetailsScreen(id: id));
                  } else if (type == 'culture_heritage') {
                    print('testing7');
                    Get.to(() => CultureHeritageDetailScreen(heritageId: id));
                  } else if (type == 'external_link') {
                    print('testing8');
                    Get.to(() => ExternalDetailScreen(
                          externalId: id,
                        ));
                  } else if (type == 'event_programme') {
                    print('testing9');
                    Get.to(() => LatestChangeEvent(
                          id: id,
                        ));
                  } else {
                    print('testing10');

                    Get.to(() => ArtistCategoryDetailsScreen(
                          id: id,
                        ));
                  }
                },
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(2),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      // color: MyColor.appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 5,
                            offset: Offset(3, 4)),
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            offset: Offset(-3, -4))
                      ],
                      // boxShadow: const [
                      //   BoxShadow(color: MyColor.appColor, blurRadius: 2),
                      // ],
                      // border: Border.all(color: MyColor.appColor, width: 1)
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          child: getXController.newAdditionList[index].photo !=
                                      null &&
                                  getXController
                                      .newAdditionList[index].photo!.isNotEmpty
                              ? Image.network(
                                  getXController.newAdditionList[index].photo!,
                                  fit: BoxFit.fill,
                                  width: width * 0.3,
                                  height: height * 0.08,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
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
                                  width: width * 0.3,
                                  height: height * 0.08,
                                ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          getXController.newAdditionList[index].name!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: MyColor.color4F4C4C,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
