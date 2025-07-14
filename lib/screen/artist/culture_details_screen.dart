
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/artist/artist_home_controller.dart';

class CultureDetailsScreen extends StatefulWidget {
  int id;

  CultureDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CultureDetailsScreen> createState() => _CultureDetailsScreenState();
}

class _CultureDetailsScreenState extends State<CultureDetailsScreen> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  ArtistHomeController getXController = Get.put(ArtistHomeController());
  late int index;
  late double height;
  late double width;

  final RxDouble fontSize = 14.0.obs;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });

    // TODO: implement initState
    super.initState();
  }

  // getData() async {
  //   getXController.cultureDetailsData = null;
  //   getXController.cultureProgramSliderData.clear();
  //   setState(() {});
  //   await getXController.getCultureProgSliderData(widget.id);
  //   setState(() {});
  //   await getXController.getCultureDetailsData(widget.id);
  //   setState(() {});
  // }
  getData() async {
    setState(() {
      getXController.cultureDetailsData = null;
      getXController.cultureProgramSliderData.clear();
    });

    await getXController.getCultureProgSliderData(widget.id);
    await getXController.getCultureDetailsData(widget.id);

    setState(() {}); // Single setState after all data is fetched
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      appBar: AppBar(
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
            //
            // const Icon(
            //   Icons.search,
            //   color: Colors.white,
            // )
          ],
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: Column(
            children: [
              getXController.cultureProgramSliderData.isNotEmpty
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
                    )),
              ),
              if (getXController.cultureDetailsData != null)
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                MyGlobal.checkNullData(
                                    getXController.cultureDetailsData!.name),
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
                      // Text(
                      //   MyGlobal.checkNullData(getXController.aboutUsData!.description),
                      //   textAlign: TextAlign.start,
                      //   style: TextStyle(
                      //       color: MyColor.color4F4C4C,
                      //       fontFamily: MyFont.roboto,
                      //       fontWeight: MyFontWeight.regular,
                      //       fontSize: 14
                      //   ),
                      // )

                      MyGlobal.checkNullData(
                                  getXController.cultureDetailsData!.content)
                              .isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Html(
                                data:
                                    '${getXController.cultureDetailsData!.content}',
                                onLinkTap: (str, data, element) {
                                  print(str);
                                  launchUrl(Uri.parse(str!),
                                      mode: LaunchMode.inAppWebView);
                                },
                                style: {
                                  'body': Style(
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
                )
            ],
          ),
        ),
      ),
    );
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
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: buttonCarouselController,
                  itemCount: getXController.cultureProgramSliderData.length,
                  itemBuilder: (context, index, position) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: getXController
                                      .cultureProgramSliderData[index].photo !=
                                  null &&
                              getXController.cultureProgramSliderData[index]
                                  .photo!.isNotEmpty
                          ? Image.network(
                              getXController
                                  .cultureProgramSliderData[index].photo!,
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
                      autoPlay:
                          getXController.cultureProgramSliderData.length != 1
                              ? true
                              : false,
                      enableInfiniteScroll:
                          getXController.cultureProgramSliderData.length != 1
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
            children: getXController.cultureProgramSliderData.map((url) {
              int index = getXController.cultureProgramSliderData.indexOf(url);
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
