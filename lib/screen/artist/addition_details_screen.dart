
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

class AdditionDetailsScreen extends StatefulWidget {
  int id;
  String type;

  AdditionDetailsScreen({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  @override
  State<AdditionDetailsScreen> createState() => _AdditionDetailsScreenState();
}

class _AdditionDetailsScreenState extends State<AdditionDetailsScreen> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;
  ArtistHomeController getXController = Get.put(ArtistHomeController());
  late int index;
  late double height;
  late double width;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });

    // TODO: implement initState
    super.initState();
  }

  getData() async {
    getXController.newAdditionDetails = null;
    setState(() {});
    await getXController.getNewAdditionDetails(
        widget.id.toString(), widget.type.toString());
    // setState(() {});
    // await getXController.getnewAdditionDetails!(widget.id);
    setState(() {});
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
            //
            // const Icon(
            //   Icons.search,
            //   color: Colors.white,
            // )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
        child: Column(
          children: [
            getXController.newAdditionDetails != null
                ? categoryGallery()
                : const SizedBox(),
            if (getXController.newAdditionDetails != null)
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height:
                          getXController.newAdditionDetails!.name!.isNotEmpty
                              ? 5
                              : 0,
                    ),
                    getXController.newAdditionDetails!.name!.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    MyGlobal.checkNullData(getXController
                                        .newAdditionDetails!.name),
                                    style: TextStyle(
                                        color: MyColor.color1F140A,
                                        fontFamily: MyFont.roboto,
                                        fontWeight: MyFontWeight.semiBold,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    MyGlobal.checkNullData(
                                getXController.newAdditionDetails!.description)
                            .isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Html(
                              data:
                                  '${getXController.newAdditionDetails!.description}',
                              onLinkTap: (str, data, element) {
                                print(str);
                                launchUrl(Uri.parse(str!),
                                    mode: LaunchMode.inAppWebView);
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
    );
  }

  ///
  ///
  ///
  categoryGallery() {
    return Column(
      children: [
        Container(
          height: height * 0.25,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: getXController.newAdditionDetails!.image != null &&
                    getXController.newAdditionDetails!.image != null
                ? Image.network(
                    getXController.newAdditionDetails!.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  )
                : Image(
                    image: noImage,
                    width: double.infinity,
                    height: height * 0.25,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ],
    );
  }
}
