import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:upculture/controller/artist/category_controller.dart';

import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

import '../../local_database/key_constants.dart';
import '../../local_database/my_shared_preference.dart';
import '../../network/api_constants.dart';
import 'package:http/http.dart' as http;

import 'artist_category_details_screen.dart';

class ArtistCategoryScreen extends StatefulWidget {
  int id;
  String categoryName;

  ArtistCategoryScreen({Key? key, required this.categoryName, required this.id})
    : super(key: key);

  @override
  State<ArtistCategoryScreen> createState() => _ArtistCategoryScreenState();
}

class _ArtistCategoryScreenState extends State<ArtistCategoryScreen> {
  CategoryController getXController = Get.put(CategoryController());
  late double height;
  late double width;
  var jsonData = [];
  String currentUserId = "";
  List<dynamic> data = []; // Stores all data
  List<dynamic> displayedData = []; // Stores data shown to the user
  int itemsPerPage = 30;
  int currentMaxIndex = 0;
  bool hasMoreData = true;
  bool isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(_scrollListener);
    getArtistCategory('');
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMoreData) {
      loadMoreData();
    }
  }

  Future<void> getArtistCategory(String search) async {
    if (isLoading) return;
    setState(() => isLoading = true);
    String url = "${ApiConstants.getAllArtistListApi}?vidha_search=$search";

    try {
      var jsonResponse = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "multipart/form-data"},
      );

      if (jsonResponse.statusCode == 200) {
        var jsondata = jsonDecode(jsonResponse.body);
        data = jsondata['data'];
        setState(() {
          displayedData = data.take(itemsPerPage).toList();
          print('loading...1');
          currentMaxIndex = displayedData.length;
          hasMoreData = data.length > displayedData.length;
        });

        loadMoreData();
      } else {
        print("Error fetching data1");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void loadMoreData() {
    if (!hasMoreData || isLoading) return;
    print('loading..2');

    setState(() => isLoading = true); // Start loading state

    Future.delayed(const Duration(seconds: 2), () {
      print('loading...3');

      setState(() {
        int nextMaxIndex = currentMaxIndex + itemsPerPage;

        if (nextMaxIndex <= data.length) {
          displayedData.addAll(data.sublist(currentMaxIndex, nextMaxIndex));
          currentMaxIndex = nextMaxIndex;
        } else {
          displayedData.addAll(data.sublist(currentMaxIndex));
          hasMoreData = false;
        }

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
        elevation: 0,
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: MyColor.appColor, width: 1),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  border: InputBorder.none,
                  hintText: "artistSearch".tr,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: MyFont.roboto,
                    fontWeight: MyFontWeight.regular,
                    fontSize: 16,
                  ),
                ),
                onChanged: (value) {
                  getArtistCategory(value);
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: currentUserId == ""
                  ? artistCategoryWithoutLogin()
                  : artistCategory(),
            ),
          ],
        ),
      ),
    );
  }

  Widget artistCategory() {
    if (isLoading && displayedData.isEmpty) {
      // Show loader in the middle of the screen when initially loading
      return const Center(child: CircularProgressIndicator());
    }
    int currentUserId = MySharedPreference.getInt(KeyConstants.keyUserId);
    print("currentUserId:$currentUserId");
    List<dynamic> filteredData = displayedData.where((user) {
      return user['user_id'] != currentUserId;
    }).toList();

    return GridView.builder(
      controller: _scrollController, // Attach scroll controller
      itemCount: hasMoreData ? filteredData.length + 1 : filteredData.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 15,
        childAspectRatio: 3,
        mainAxisExtent: 160,
      ),
      itemBuilder: (context, index) {
        if (index == filteredData.length) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () {
            print(filteredData[index]['user_id']);
            Get.to(
              () => ArtistCategoryDetailsScreen(
                id: filteredData[index]['user_id'],
              ),
              transition: Transition.zoom,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 1),
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 5,
                    offset: Offset(2, 3),
                  ),
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: Offset(-2, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: CachedNetworkImage(
                      imageUrl: filteredData[index]['photo'].toString(),
                      imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: imageProvider,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 80),
                        ),
                      ),
                      placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: noImage,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filteredData[index]['name'].toString(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: MyColor.color4F4C4C.withOpacity(0.6),
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.medium,
                    ),
                  ),
                  Text(
                    filteredData[index]['vidha_name'].toString(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: MyColor.color4F4C4C.withOpacity(0.6),
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.medium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      " ${filteredData[index]['districts_name']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColor.appColor,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  artistCategoryWithoutLogin() {
    if (isLoading && displayedData.isEmpty) {
      // Show loader in the middle of the screen when initially loading
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      itemCount: displayedData.length + (hasMoreData ? 1 : 0),
      controller: _scrollController,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 15,
        childAspectRatio: 3,
        mainAxisExtent: 160,
      ),
      itemBuilder: (context, index) {
        if (index == displayedData.length) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () {
            Get.to(
              () => ArtistCategoryDetailsScreen(
                id: displayedData[index]['user_id'],
              ),
              transition: Transition.zoom,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 1),
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                // color: Colors.white,
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 245, 207, 169),
                    Colors.white,
                    Color.fromARGB(255, 203, 237, 204),
                  ],
                  tileMode: TileMode.mirror,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 5,
                    offset: Offset(2, 3),
                  ),
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: Offset(-2, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: CachedNetworkImage(
                      imageUrl: displayedData[index]['photo'].toString(),
                      imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: imageProvider,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 80),
                        ),
                      ),
                      placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: noImage,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    displayedData[index]['name'].toString(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: MyColor.color4F4C4C.withOpacity(0.6),
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.medium,
                    ),
                  ),
                  Text(
                    displayedData[index]['vidha_name'].toString(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: MyColor.color4F4C4C.withOpacity(0.6),
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.medium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      " ${displayedData[index]['districts_name']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColor.appColor,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
