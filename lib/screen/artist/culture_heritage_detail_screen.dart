
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:translator/translator.dart';
import 'package:upculture/controller/artist/culture_heritage_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:url_launcher/url_launcher.dart';

class CultureHeritageDetailScreen extends StatefulWidget {
  int heritageId;

  CultureHeritageDetailScreen({Key? key, required this.heritageId})
      : super(key: key);

  @override
  State<CultureHeritageDetailScreen> createState() =>
      _CultureHeritageDetailScreenState();
}

class _CultureHeritageDetailScreenState
    extends State<CultureHeritageDetailScreen> {
  CultureHeritageController getXController =
      Get.put(CultureHeritageController());
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  late double height;
  late double width;
  String? translatedName;
  final RxDouble fontSize = 14.0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(), () {
      getXController.getGalleryDetail(heritageId: widget.heritageId);
    });
    print(widget.heritageId);
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
              getXController.heritageGallery.isNotEmpty
                  ? heritageGallery()
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
                    )),
              ),
              Obx(
                () => Expanded(
                    child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              MyGlobal.checkNullData(
                                  getXController.heritageDetail.value.name),
                              style: TextStyle(
                                  color: MyColor.color1F140A,
                                  fontFamily: MyFont.roboto,
                                  fontWeight: MyFontWeight.semiBold,
                                  fontSize: fontSize.value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyGlobal.checkNullData(
                                getXController.heritageDetail.value.description)
                            .isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Html(
                              data:
                                  '${getXController.heritageDetail.value.description}',
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
                )),
              )
            ],
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  heritageGallery() {
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
                  itemCount: getXController.heritageGallery.length,
                  itemBuilder: (context, index, position) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: getXController.heritageGallery[index].photo !=
                                  null &&
                              getXController
                                  .heritageGallery[index].photo!.isNotEmpty
                          ? Image.network(
                              getXController.heritageGallery[index].photo!,
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
                              height: height * 0.2,
                              fit: BoxFit.fill,
                            ),
                    );
                  },
                  options: CarouselOptions(
                      enlargeFactor: 0.2,
                      viewportFraction: 0.85,
                      enlargeCenterPage: true,
                      autoPlay: getXController.heritageGallery.length != 1
                          ? true
                          : false,
                      enableInfiniteScroll:
                          getXController.heritageGallery.length != 1
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
          height: 20,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getXController.heritageGallery.map((url) {
              int index = getXController.heritageGallery.indexOf(url);
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
    );
  }
}
