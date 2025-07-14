import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/screen/artist/external_detail_screen.dart';
import 'package:upculture/screen/artist/sub_category_screen.dart';

import '../../controller/artist/category_controller.dart';
import '../../controller/artist/search_controller.dart';
import 'category_detail_screen.dart';
import 'culture_details_screen.dart';
import 'culture_heritage_detail_screen.dart';
import 'culture_sub_category_product_list_screen.dart';
import 'culture_sub_category_screen.dart';
import 'event_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchController1 getXController = Get.put(SearchController1());
  FocusNode focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _previousSearches = []; // To store previous search terms
  String currentSearch = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.appColor,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 80,
          elevation: 0,
          title: Row(
            children: [
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                child:
                    // Show Previous Searches
                    TextField(
                      focusNode: focusNode,
                      controller: _searchController,
                      onChanged: (value) {
                        getXController.search.value = value;

                        if (value.isNotEmpty) {
                          getXController.searchData();
                        } else {
                          getXController.datas.value = [];
                          print("you doesnot entered value");
                        }
                      },
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search or ask something',
                        hintStyle: const TextStyle(color: Colors.black45),
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 0,
                          bottom: 0,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: GestureDetector(
                          child: Container(
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        // hintStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1, color: Colors.grey);
            },
            shrinkWrap: true,
            itemCount: getXController.datas.length,
            itemBuilder: (BuildContext context, int index) {
              var type = getXController.datas[index].type;
              return GestureDetector(
                onTap: () {
                  if (type == "category/sub_cagory") {
                    print("testing1");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => CategoryDetailScreen(
                        index: -1,
                        fromSearch: true,
                        id: getXController.datas[index].id ?? 0,
                        getXController: CategoryController(),
                      ),
                    );
                  } else if (type == "city") {
                    print("testing2");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => CultureSubCategoryScreen(
                        cultureCategoryName: getXController.datas[index].name!,
                        cultureCategoryId: getXController.datas[index].id!,
                        getXController: CategoryController(),
                      ),
                    );
                  } else if (type == "event/sub_event") {
                    print("testing3");
                    _previousSearches.add(getXController.datas[index].name!);

                    Get.to(
                      () => EventDetailScreen(
                        categoryName: "",
                        id: getXController.datas[index].id!,
                        forSearch: true,
                      ),
                    );
                  } else if (type == "external_link") {
                    print("testing4");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => ExternalDetailScreen(
                        externalId: getXController.datas[index].id!,
                      ),
                    );
                  } else if (type == "category") {
                    print("testing5");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => SubCategoryScreen(
                        categoryName: getXController.datas[index].name!,
                        id: getXController.datas[index].id!,
                      ),
                    );
                  } else if (type == "city/category") {
                    print("testing6");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => CultureSubCategoryProductListScreen(
                        cultureSubCategoryId: getXController.datas[index].id!,
                        getXController: CategoryController(),
                      ),
                    );
                  } else if (type == "city/category/subcategory") {
                    print("testing7");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => CultureSubCategoryProductListScreen(
                        cultureSubCategoryId: getXController.datas[index].id!,
                        forSearch: true,
                        sliderUrl: getXController.datas[index].slider_url ?? "",
                        getXController: CategoryController(),
                      ),
                    );
                  } else if (type == "culture_program") {
                    print("testing8");
                    _previousSearches.add(getXController.datas[index].name!);

                    Get.to(
                      () => CultureDetailsScreen(
                        id: getXController.datas[index].id!,
                      ),
                    );
                  } else if (type == "culture_heritage") {
                    print("testing9");
                    _previousSearches.add(getXController.datas[index].name!);
                    Get.to(
                      () => CultureHeritageDetailScreen(
                        heritageId: getXController.datas[index].id!,
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            getXController.datas[index].name!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColor.color4F4C4C,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
