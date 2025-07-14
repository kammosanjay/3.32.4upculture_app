import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/external_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/my_global.dart';

class ExternalDetailScreen extends StatefulWidget {
  const ExternalDetailScreen({Key? key, required this.externalId})
      : super(key: key);
  final int externalId;
  @override
  State<ExternalDetailScreen> createState() => _ExternalDetailScreenState();
}

class _ExternalDetailScreenState extends State<ExternalDetailScreen> {
  ExternalController getXController = Get.put(ExternalController());
  late double height;
  late double width;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero,
        () => getXController.getExternalDetails(externalId: widget.externalId));
    super.initState();
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
        body: Obx(
          () => getXController.isLoading.value
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(children: [
                            MyGlobal.checkNullData(
                                        getXController.detail.value.photo)
                                    .isNotEmpty
                                ? Image.network(
                                    getXController.detail.value.photo!,
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: height * 0.2,
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
                                    width: width * 0.98,
                                    height: height * 0.4,
                                  ),
                          ]),
                          getXController.detail.value.description != null
                              ? Html(
                                  data: getXController.detail.value.description,
                                  onLinkTap: (str, data, element) {
                                    print(str);
                                    launchUrl(Uri.parse(str!),
                                        mode: LaunchMode.inAppWebView);
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          GestureDetector(
                            onTap: () {
                              launchUrl(
                                  Uri.parse(getXController.detail.value.url!),
                                  mode: LaunchMode.inAppWebView);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Text(
                                MyString.viewMore,
                                style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: width * 0.038,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
