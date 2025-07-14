import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shimmer/shimmer.dart';
// ignore: import_of_legacy_library_into_null_safe

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:upculture/local_database/key_constants.dart';
import 'package:upculture/screen/artist/chat.dart';
import 'package:upculture/screen/artist/test.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:flutter/material.dart'
    hide BoxDecoration, BoxShadow, CarouselController;
import 'package:upculture/resources/language.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/all_category_screen.dart';
import 'package:upculture/screen/artist/artist_end_drawer.dart';
import 'package:upculture/screen/artist/culture_details_screen.dart';
import 'package:upculture/screen/artist/culture_heritage_detail_screen.dart';

import 'package:upculture/screen/artist/search_screen.dart';
import 'package:upculture/screen/artist/sub_category_screen.dart';
import 'package:upculture/screen/calendar_test_screen.dart';
import 'package:upculture/screen/common/lngCodee.dart';

import 'package:upculture/utils/my_global.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/pdfx_view_screen.dart';
import 'misc_sub_screen.dart';

// ignore: must_be_immutable
class ArtistHomeScreen extends StatefulWidget {
  String callFrom;
  int? lang;

  ArtistHomeScreen({Key? key, required this.callFrom, this.lang})
    : super(key: key);

  @override
  State<ArtistHomeScreen> createState() => _ArtistHomeScreenState();
}

class _ArtistHomeScreenState extends State<ArtistHomeScreen> {
  late double height;
  late double width;
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  // var translatedName;

  ArtistHomeController getXController = Get.put(ArtistHomeController());
  TextEditingController _controller = TextEditingController();

  // var getXController=Get.find<ArtistHomeController>();

  @override
  void initState() {
    super.initState();
    MySharedPreference.getInstance();

    Future.delayed(const Duration(), () {
      getData();
    });

    print("${widget.callFrom + " xxxxxx  " + widget.lang.toString()}");
  }

  getData() async {
    DateTime now = DateTime.now();

    print(now);

    await getXController.getBannerListData(lang: widget.lang ?? 2);
    await getXController.artistProfile();

    setState(() {});
  }

  final List<String> imagePaths = [
    "assets/images/kumbh.jpg",
    "assets/images/image2.jpg",
    "assets/images/image3.jpg",
  ];

  final List<types.Message> _messages = [];
  final types.User _user = const types.User(id: 'user-1');

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  Future<void> _handleAttachmentPressed() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;

      final fileMessage = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        name: file.name,
        size: file.size,
        uri: file.path!,
        mimeType: lookupMimeType(file.path!) ?? 'application/octet-stream',
      );

      setState(() {
        _messages.insert(0, fileMessage);
      });
    }
  }

  String? lookupMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'mp4':
        return 'video/mp4';
      default:
        return null;
    }
  }
  //
  // double aniHeight = 20.0;
  // double aniWidth = 200;
  // Color aniColor = Colors.purple;
  // BorderRadius aniBorderRadius = BorderRadius.circular(10);

  //
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return WillPopScope(
      onWillPop: () async {
        bool exitConfirmed = await showExitConfirmationDialog(context);
        return exitConfirmed; // true = exit app, false = stay in app
      },
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 243, 234, 230),
        backgroundColor: Colors.white,

        // floatingActionButton:
        //  Visibility(
        //   visible: MySharedPreference.getInt(KeyConstants.keyUserId) != null,
        //   child:
        //     FloatingActionButton.extended(
        //   backgroundColor: Color.fromARGB(255, 235, 193, 173),
        //   shape: CircleBorder(),
        //   label: Container(
        //       child: Image.asset(
        //     "assets/images/chatbot.png",
        //     height: 50,
        //     // color: MyColor.appColor,
        //   )),
        //   onPressed: () {
        //     Get.to(ChatBotScreen(
        //       userId:
        //           MySharedPreference.getInt(KeyConstants.keyUserId).toString(),
        //     ));
        //   },
        //   // ),
        // ),
        // // backgroundColor: Color.fromRGBO(240, 239, 239, 1),
        endDrawer: ArtistEndDrawer(
          callFrom: widget.callFrom,
          profileData: getXController.profileData,
        ),

        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: MyColor.appColor,
          surfaceTintColor: Colors.transparent,
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
                      color: MyColor.indiaWhite,
                    ),
                    const SizedBox(width: 10),
                    Text(
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
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(const SearchScreen(), transition: Transition.zoom);
                },
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),
        ),
        body: Obx(
          () => Column(
            children: [
              getXController.bannerList.isNotEmpty
                  ? slider()
                  : const SizedBox(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // if (widget.lang != null) {
                    //   await getXController.getCategoriesData(langCode: 1);
                    // } else {
                    //   await getXController.getCategoriesData(langCode: 2);
                    // }

                    print("lang--->" + widget.lang.toString());
                  },
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      getXController.categoryList.isNotEmpty
                          ? category()
                          : const SizedBox(),
                      getXController.datewiseEventList.isNotEmpty
                          ? events()
                          : SizedBox(),
                      // : noEvent(),
                      getXController.heritageList.isNotEmpty
                          ? heritage()
                          : const SizedBox(),
                      getXController.cultureProgramList.isNotEmpty
                          ? culturalPrograms()
                          : const SizedBox(),
                      getXController.heritageList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: structure()),
                                  Expanded(child: radio()),
                                  Expanded(child: achievement()),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      getXController.heritageList.isNotEmpty
                          ? miscellaneous()
                          : const SizedBox(),
                      getXController.externalList.isNotEmpty
                          ? externalLinks()
                          : const SizedBox(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  ///
  ///
  slider() {
    return Stack(
      children: [
        Container(
          height: height * 0.22,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: CarouselSlider.builder(
            carouselController: buttonCarouselController,
            itemCount: getXController.bannerList.length,
            itemBuilder: (context, index, position) {
              return InkWell(
                onTap: () {
                  // Get.to(()  => BannerDetailScreen(bannerId: getXController.bannerList[index].id!,));
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ), // Add border radius
                  child:
                      getXController.bannerList[index].photo != null &&
                          getXController.bannerList[index].photo!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: getXController.bannerList[index].photo!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: height * 0.22,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image(
                            image: noImage,
                            width: double.infinity,
                            height: height * 0.22,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Image(
                          image: noImage,
                          width: double.infinity,
                          height: height * 0.22,
                          fit: BoxFit.fill,
                        ),
                ),
              );
            },
            options: CarouselOptions(
              enlargeFactor: 0.25,
              viewportFraction: .9,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(microseconds: 600),
              autoPlay: getXController.bannerList.length != 1 ? true : false,
              enableInfiniteScroll: getXController.bannerList.length != 1
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
        Positioned(
          bottom: 20,
          left: 50,
          right: 50,
          child: SizedBox(
            height: 10,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getXController.bannerList.map((url) {
                int index = getXController.bannerList.indexOf(url);
                return Container(
                  width: 10.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPos == index
                        ? MyColor.appColor
                        : Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  ///
  ///
  ///
  category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // margin: EdgeInsets.only(top: 20),
        // color: Colors.blue[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // getTitle(title:MyString.categories ),
            const SizedBox(height: 15.0),
            getTitle(title: 'categories'.tr),
            const SizedBox(height: 15.0),
            Container(
              // margin: EdgeInsets.all(5),
              // color: Colors.deepPurple[50],
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of columns
                    crossAxisSpacing: 5, // Spacing between columns
                    mainAxisSpacing: 0, // Spacing between rows
                    childAspectRatio: 0.8,
                    mainAxisExtent: 118,
                    // Aspect ratio for grid cells
                  ),
                  itemCount: getXController.categoryList.length > 8
                      ? 8
                      : getXController.categoryList.length,
                  itemBuilder: (context, index) {
                    final category = getXController.categoryList[index];

                    return InkWell(
                      onTap: () async {
                        if (category.category == 'allArtist'.tr) {
                          print('सभी श्रेणी');
                          print('all :${category.id}');
                          Get.to(
                            () => AllCategoryScreen(
                              callfrom: widget.callFrom,
                              categoryList: getXController.categoryList,
                            ),
                            transition: Transition.zoom,
                          );
                        } else {
                          print('subcategory');
                          print('sub :${category.id}');
                          print(category.category);
                          Get.to(
                            () => SubCategoryScreen(
                              categoryName: category.category!,
                              id: category.id!,
                              callFrom: widget.callFrom,
                            ),
                            transition: Transition.zoom,
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // height: 70,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              // border: Border.all(color: MyColor.appColor, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: MyColor.appColor,
                                  blurRadius: 10,
                                  inset: true,
                                  offset: Offset(-2, -2),
                                ),
                                // offset: offset),
                                BoxShadow(
                                  // color: Color.fromRGBO(239, 236, 236, 1),
                                  color: MyColor.appColor40,
                                  // blurRadius: 15,
                                  inset: true,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child:
                                  category.photo != null &&
                                      category.photo!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: category.photo!,
                                      height: 50.0,
                                      width: 50.0,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              height: 50.0,
                                              width: 50.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Image(
                                            image: noImage,
                                            height: 50.0,
                                            width: 50.0,
                                          ),
                                    )
                                  : index == 0
                                  ? Image(
                                      image: allCategoryIc,
                                      height: 50.0,
                                      width: 50.0,
                                    )
                                  : Image(
                                      image: noImage,
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Container(
                            width: 70,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              category.category!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 30, 28, 28),
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
  getTitle({required String title}) {
    return Center(
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: Duration(seconds: 3),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(3, 3)),
              // BoxShadow(
              //     // color: MyColor.appColor.withOpacity(0.5),
              //     color: Colors.grey.shade400,
              //     blurRadius: 2,
              //     // inset: true,
              //     offset: Offset(3, 3)),
              // BoxShadow(
              //     color: MyColor.appColor.withOpacity(0.1),
              //     // color: Colors.grey.shade400,
              //     blurRadius: 2,
              //     //  inset: true,
              //     //  spreadRadius: 10,
              //     offset: Offset(-2, -2))
            ],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontFamily: MyFont.roboto,
              fontWeight: MyFontWeight.semiBold,
            ),
          ),
        ),
      ),
    );
  }

  String getMyKey(String key) {
    // Access the current locale using Get.locale
    String localeKey = '${Get.locale?.languageCode}_${Get.locale?.countryCode}';

    // Extract the translation from LocalString
    return LocalString().keys[localeKey]?[key] ?? 'Translation not found';
  }

  ///
  ///
  ///
  events() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // getTitle(title: MyString.events),
          getTitle(title: 'events'.tr),
          const SizedBox(height: 15),
          Container(
            height: height * 0.15,
            // color: Colors.white,
            child: CarouselSlider.builder(
              itemCount: getXController.datewiseEventList.length,
              itemBuilder: (context, index, realIndex) {
                var list = getXController.datewiseEventList[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => CalendarTestScreen(lang: widget.lang),
                      transition: Transition.zoom,
                    );
                    print("calenderScreen");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 5,
                          offset: Offset(3, 4),
                        ),
                      ],
                    ),
                    height: 100,
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Image.network(
                        list.photo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          child: Image.network(
                            getXController.datewiseEventList[index].coverPhoto!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 100,
                scrollPhysics: BouncingScrollPhysics(),
                autoPlay: false,
                enableInfiniteScroll: false,
                viewportFraction: getXController.datewiseEventList.length == 1
                    ? 1.0
                    : 0.35,
                enlargeCenterPage: getXController.datewiseEventList.length != 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  noEvent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // margin: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            getTitle(title: 'events'.tr),
            // const SizedBox(
            //   height: 15,
            // ),
            Container(
              height: height * 0.15,
              // color: Colors.white,
              child: CarouselSlider.builder(
                itemCount: imagePaths.length,
                itemBuilder: (context, index, realIndex) {
                  return InkWell(
                    onTap: () => Get.to(
                      () => CalendarTestScreen(lang: widget.lang),
                      transition: Transition.zoom,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 5,
                              offset: Offset(10, 10),
                            ),
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              offset: Offset(-3, -4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          // border: Border.all(
                          //   color: MyColor.appColor,
                          //   width: 1,
                          // )
                        ),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 0.35,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  scrollPhysics: BouncingScrollPhysics(),
                  aspectRatio: 1,
                  autoPlay: false,
                  height: 100,
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
  heritage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // getTitle(title: MyString.cultureHeritage),
          getTitle(title: 'cultureHeritage'.tr),

          SizedBox(height: 15),
          Container(
            height: height * 0.18,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: getXController.heritageList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Get.to(
                      () => CultureHeritageDetailScreen(
                        heritageId: getXController.heritageList[index].id!,
                      ),
                      transition: Transition.zoom,
                    );
                    // Get.to(()  => ExternalDetailScreen(externalId: getXController.externalList[index].id!));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                blurRadius: 5,
                                // inset: true,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: MyColor.indiaWhite,
                                blurRadius: 1,
                                offset: Offset(-1, -1),
                              ),
                            ],
                            color: MyColor.indiaWhite,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            child:
                                MyGlobal.checkNullData(
                                  getXController.heritageList[index].photo,
                                ).isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: getXController
                                        .heritageList[index]
                                        .photo!,
                                    fit: BoxFit.cover,
                                    height: height * 0.12,
                                    width: width * 0.35,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: width * 0.33,
                                            height: height * 0.18,
                                            color: Colors.black,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => Image(
                                      image: noImage,
                                      width: width * 0.33,
                                      height: height * 0.18,
                                    ),
                                  )
                                : Image(
                                    image: noImage,
                                    width: width * 0.33,
                                    height: height * 0.18,
                                  ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: height * 0.04,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                // color: MyColor.appColor.withOpacity(0.5),
                                color: Colors.grey.shade400,
                                blurRadius: 2,
                                // inset: true,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: MyColor.appColor.withOpacity(0.1),
                                // color: Colors.grey.shade400,
                                blurRadius: 2,
                                //  inset: true,
                                //  spreadRadius: 10,
                                offset: Offset(-2, -2),
                              ),
                            ],
                            // color: MyColor.indiaWhite,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: MyColor.indiaWhite,
                          ),
                          child: Center(
                            child: Text(
                              MyGlobal.checkNullData(
                                getXController.heritageList[index].name,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 27, 27, 27),
                                // color: Colors.green,
                                fontSize: 12,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///

  structure() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // getTitle(title: getXController.structureName),
          // getTitle(title: 'structureofUP'.tr),
          // const SizedBox(
          //   height: 15,
          // ),
          Container(
            height: height * 0.12,
            // width: width*0.12,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              // color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
              color: MyColor.indiaWhite,
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey.shade400,
              //       blurRadius: 5,
              //       offset: Offset(1, 2)),
              //   BoxShadow(
              //       color: Colors.grey.shade300,
              //       blurRadius: 5,
              //       offset: Offset(-3, -4))
              // ],
            ),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => PdfxViewScreen(
                    fileName: getXController.structurePDF.split("/").last,
                    pdfUrl: getXController.structurePDF,
                  ),
                  transition: Transition.zoom,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    MyGlobal.checkNullData(
                      getXController.structureThumb,
                    ).isNotEmpty
                    ? Image.network(
                        getXController.structureThumb,
                        fit: BoxFit.cover,
                        width: width * 0.28,
                        height: height * 0.15,
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
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                      )
                    : Image(
                        image: noImage,
                        fit: BoxFit.cover,
                        width: width * 0.3,
                        height: height * 0.15,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  miscellaneous() {
    List<String> images = [
      "assets/images/abhilekhgar-eng.jpg",
      "assets/images/puratatva-vibhag-eng.jpg",
      "assets/images/sangrahalay-eng.jpg",
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // getTitle(title: MyString.miscellaneousProgram),
          getTitle(title: 'office'.tr),
          const SizedBox(height: 15),
          Container(
            height: height * 0.126,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              itemExtent: width * 0.4,
              itemCount: getXController.miscList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    // await getXController.getExternalDetails(externalId: getXController.externalList[index].id);
                    // externalDetailsPopUp();
                    Get.to(
                      () => MiscSubScreen(
                        id: getXController.miscList[index].id!,
                        categoryName: getXController.miscList[index].name!,
                      ),
                      transition: Transition.zoom,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
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
                            offset: Offset(-1, -2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child:
                            MyGlobal.checkNullData(
                              getXController.miscList[index].photo,
                            ).isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: getXController.miscList[index].photo!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: width * 0.38,
                                        height: height * 0.125,
                                        color: Colors.white,
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Image(
                                  image: noImage,
                                  width: width * 0.38,
                                  height: height * 0.125,
                                ),
                              )
                            : Image(
                                image: noImage,
                                width: width * 0.38,
                                height: height * 0.125,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  radio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // getTitle(title: getXController.radioName),
          // getTitle(title: 'radioJayGhosh'.tr),
          // const SizedBox(
          //   height: 15,
          // ),
          Container(
            height: height * 0.12,
            // width: 100,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => PdfxViewScreen(
                    fileName: getXController.radioPDF.split("/").last,
                    pdfUrl: getXController.radioPDF,
                  ),
                  transition: Transition.zoom,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    MyGlobal.checkNullData(getXController.radioThumb).isNotEmpty
                    ? Image.network(
                        getXController.radioThumb,
                        fit: BoxFit.cover,
                        width: width * 0.28,
                        height: height * 0.15,
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
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                      )
                    : Image(
                        image: noImage,
                        fit: BoxFit.cover,
                        width: width * 0.3,
                        height: height * 0.15,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  achievement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // getTitle(title: MyString.achievement),
          // getTitle(title: 'achievements'.tr),
          // const SizedBox(
          //   height: 15,
          // ),
          Container(
            height: height * 0.12,
            // width: 100,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () {
                Get.to(
                  () => PdfxViewScreen(
                    fileName: getXController.achievementPDF.split("/").last,
                    pdfUrl: getXController.achievementPDF,
                  ),
                  transition: Transition.zoom,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    MyGlobal.checkNullData(
                      getXController.achievementThumb,
                    ).isNotEmpty
                    ? Image.network(
                        getXController.achievementThumb,
                        fit: BoxFit.cover,
                        width: width * 0.28,
                        height: height * 0.15,
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
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                      )
                    : Image(
                        image: noImage,
                        fit: BoxFit.cover,
                        width: width * 0.3,
                        height: height * 0.15,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  externalLinks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // getTitle(title: MyString.externalLink),
          getTitle(title: 'externalLink'.tr),
          const SizedBox(height: 15),

          Container(
            height: height * 0.18,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: getXController.externalList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await getXController.getExternalDetails(
                      externalId: getXController.externalList[index].id,
                    );
                    print(getXController.externalList[index].id);
                    externalDetailsPopUp();
                    // Get.to(()  => ExternalDetailScreen(externalId: getXController.externalList[index].id!));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                blurRadius: 5,
                                // inset: true,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: MyColor.indiaWhite,
                                blurRadius: 1,
                                offset: Offset(-1, -1),
                              ),
                            ],
                            color: MyColor.indiaWhite,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            child:
                                MyGlobal.checkNullData(
                                  getXController.externalList[index].photo,
                                ).isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: getXController
                                        .externalList[index]
                                        .photo!,
                                    fit: BoxFit.cover,
                                    height: height * 0.12,
                                    width: width * 0.35,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: width * 0.33,
                                            height: height * 0.18,
                                            color: Colors.black,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => Image(
                                      image: noImage,
                                      width: width * 0.33,
                                      height: height * 0.18,
                                    ),
                                  )
                                : Image(
                                    image: noImage,
                                    width: width * 0.33,
                                    height: height * 0.18,
                                  ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: height * 0.04,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                // color: MyColor.appColor.withOpacity(0.5),
                                color: Colors.grey.shade400,
                                blurRadius: 2,
                                // inset: true,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: MyColor.appColor.withOpacity(0.1),
                                // color: Colors.grey.shade400,
                                blurRadius: 2,
                                //  inset: true,
                                //  spreadRadius: 10,
                                offset: Offset(-2, -2),
                              ),
                            ],
                            // color: MyColor.indiaWhite,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: MyColor.indiaWhite,
                          ),
                          child: Center(
                            child: Text(
                              MyGlobal.checkNullData(
                                getXController.externalList[index].name,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 27, 27, 27),
                                // color: Colors.green,
                                fontSize: 12,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  culturalPrograms() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // getTitle(title: MyString.cultureProgram),
          getTitle(title: 'culturalEvent'.tr),
          const SizedBox(height: 15),

          Container(
            height: height * 0.18,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: getXController.cultureProgramList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Get.to(
                      () => CultureDetailsScreen(
                        id: getXController.cultureProgramList[index].id!,
                      ),
                      transition: Transition.zoom,
                    );
                    // Get.to(()  => ExternalDetailScreen(externalId: getXController.externalList[index].id!));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                blurRadius: 5,
                                // inset: true,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: MyColor.indiaWhite,
                                blurRadius: 1,
                                offset: Offset(-1, -1),
                              ),
                            ],
                            color: MyColor.indiaWhite,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            child:
                                MyGlobal.checkNullData(
                                  getXController
                                      .cultureProgramList[index]
                                      .image,
                                ).isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: getXController
                                        .cultureProgramList[index]
                                        .image!,
                                    fit: BoxFit.cover,
                                    height: height * 0.12,
                                    width: width * 0.35,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: width * 0.33,
                                            height: height * 0.18,
                                            color: Colors.black,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => Image(
                                      image: noImage,
                                      width: width * 0.33,
                                      height: height * 0.18,
                                    ),
                                  )
                                : Image(
                                    image: noImage,
                                    width: width * 0.33,
                                    height: height * 0.18,
                                  ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: height * 0.04,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                // color: MyColor.appColor.withOpacity(0.5),
                                color: Colors.grey.shade400,
                                blurRadius: 2,
                                // inset: true,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: MyColor.appColor.withOpacity(0.1),
                                // color: Colors.grey.shade400,
                                blurRadius: 2,
                                //  inset: true,
                                //  spreadRadius: 10,
                                offset: Offset(-2, -2),
                              ),
                            ],
                            // color: MyColor.indiaWhite,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: MyColor.indiaWhite,
                          ),
                          child: Center(
                            child: Text(
                              MyGlobal.checkNullData(
                                getXController.cultureProgramList[index].name,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 27, 27, 27),
                                // color: Colors.green,
                                fontSize: 12,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  externalDetailsPopUp() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titlePadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: height * 0.05,
        ),
        contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        title: SingleChildScrollView(
          child: Stack(
            children: [
              MyGlobal.checkNullData(
                    getXController.detail.value.photo,
                  ).isNotEmpty
                  ? Image.network(
                      getXController.detail.value.photo!,
                      fit: BoxFit.cover,
                      width: Get.width,
                      height: height * 0.2,
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
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                    )
                  : Image(
                      image: noImage,
                      width: width * 0.3,
                      height: height * 0.2,
                    ),
              Positioned(
                right: 0,
                top: 0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minWidth: Get.width * 0.1,
                  splashColor: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).primaryColorLight,
                  child: Container(
                    height: Get.width * 0.06,
                    width: Get.width * 0.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(Icons.clear, size: Get.width * 0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
        content: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 0.3,
              child: ListView(
                children: [
                  Html(
                    data: getXController.detail.value.description,
                    onLinkTap: (str, data, element) {
                      print(str);
                      launchUrl(Uri.parse(str!), mode: LaunchMode.inAppWebView);
                    },
                  ),
                ],
              ),
            ),

            // Container(
            //     height: 400,
            //     child:
            //         Text(getXController.detail.value.description.toString())),
            GestureDetector(
              onTap: () {
                launchUrl(
                  Uri.parse(getXController.detail.value.url!),
                  mode: LaunchMode.inAppWebView,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          anchorPoint: Offset(-3, -4),
          builder: (BuildContext context) {
            return
            //  AlertDialog(
            //   // backgroundColor: MyColor.appColor,
            //   title: Row(
            //     children: [
            //       Image.asset(
            //         'assets/images/uplogo.png',
            //         height: 30,
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Align(
            //         alignment: Alignment.center,
            //         child: const Text(
            //           "संस्कृति विभाग,उ0प्र0",
            //           style: TextStyle(color: MyColor.appColor),
            //         ),
            //       ),
            //     ],
            //   ),
            //   content: Container(
            //     padding: EdgeInsets.all(5),
            //     height: 60,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(5),
            //         color: Colors.white),
            //     child: Center(
            //       child: const Text("Are you sure you want to quit the app?",
            //           style: TextStyle(color: Colors.black)),
            //     ),
            //   ),
            //   actions: [
            //     TextButton(
            //       onPressed: () =>
            //           Navigator.of(context).pop(false), // Stay in app
            //       child: Container(
            //         height: 30,
            //         width: 100,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: MyColor.appColor),
            //         child: Center(
            //             child: const Text("NO",
            //                 style: TextStyle(color: Colors.white))),
            //       ),
            //     ),
            //     TextButton(
            //       onPressed: () => Navigator.of(context).pop(true), // Exit app
            //       child: Container(
            //         height: 30,
            //         width: 100,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: MyColor.appColor),
            //         child: Center(
            //           child: const Text("YES",
            //               style: TextStyle(color: Colors.white)),
            //         ),
            //       ),
            //     )
            //   ],
            // );
            AlertDialog(
              title: Row(
                children: [
                  Image.asset('assets/images/uplogo.png', height: 30),
                  SizedBox(width: 10),
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "संस्कृति विभाग,उ0प्र0",
                      style: TextStyle(color: MyColor.appColor),
                    ),
                  ),
                ],
              ),
              content: Container(
                padding: EdgeInsets.all(5),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Center(
                  child: const Text(
                    "Are you sure you want to quit the app?",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              actionsAlignment:
                  MainAxisAlignment.center, // 👈 NEW: centers actions
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: MyColor.appColor,
                    ),
                    child: Center(
                      child: const Text(
                        "NO",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: MyColor.appColor,
                    ),
                    child: Center(
                      child: const Text(
                        "YES",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }
}
