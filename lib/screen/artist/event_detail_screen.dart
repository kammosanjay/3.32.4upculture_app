import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';

import '../../utils/my_global.dart';
import '../../utils/my_widget.dart';

class EventDetailScreen extends StatefulWidget {
  int id;
  String? categoryName;
  bool forSearch;

  EventDetailScreen(
      {Key? key,
       this.categoryName,
      required this.id,
      this.forSearch = false})
      : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailscreenState();
}

class _EventDetailscreenState extends State<EventDetailScreen> {
  ArtistHomeController getXController = Get.put(ArtistHomeController());
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
    getXController.getEventList.clear();

    setState(() {});
    if (widget.forSearch) {
      getXController.getForEventDetails(eventId: widget.id);
    }
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                getXController.eventForDetails.value.isNotEmpty
                    ? subCategory()
                    : const SizedBox()
              ],
            ))),
      ),
    );
  }

  ///
  ///
  ///
  subCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: MyColor.appColor20, width: 1.2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        getXController.eventForDetails.value[0].name!,
                        style: TextStyle(
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.medium,
                            fontSize: 16,
                            color: MyColor.color1F140A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: MyColor.appColor20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          getXController.eventForDetails.value[0].ayojakName!,
                          style: TextStyle(
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.regular,
                              fontSize: 14,
                              color: MyColor.color4F4C4C),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        getXController.eventForDetails.value[0].presentLog!,
                        style: TextStyle(
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.medium,
                            fontSize: 16,
                            color: MyColor.color1F140A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        color: MyColor.indiaOrange,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          "${DateFormat('hh:mm a').format(
                                  DateFormat("hh:mm:ss").parse(
                                      getXController.eventForDetails.value[0]
                                          .startTime!))}-${DateFormat('hh:mm a').format(
                                  DateFormat("hh:mm:ss").parse(
                                      getXController
                                          .eventForDetails.value[0].endTime!))}",
                          style: TextStyle(
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.regular,
                              fontSize: 14,
                              color: MyColor.color4F4C4C),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: MyColor.indiaOrange,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          getXController.eventForDetails.value[0].startDate!,
                          style: TextStyle(
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.regular,
                              fontSize: 14,
                              color: MyColor.color4F4C4C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            getXController.eventForDetails.value[0].about!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.medium,
                fontSize: 14,
                color: MyColor.color4F4C4C),
          ),
          const SizedBox(
            height: 10,
          ),
          MyGlobal.checkNullData(getXController.eventForDetails.value[0].photo)
                  .isNotEmpty
              ? InkWell(
                  onTap: () {
                    Get.dialog(MyWidget.showBigViewImage(
                        getXController.eventForDetails.value[0].photo!));
                  },
                  child: MyWidget.artistGalleryImage(
                      galleryImage: null,
                      galleryImageUrl: getXController.eventForDetails[0].photo,
                      // galleryImageUrl: 'https://i.ytimg.com/vi/pXFLbD7hSSI/sddefault.jpg?v=64fa65fb',
                      height: Get.width * 0.5,
                      width: Get.width),
                )
              : const SizedBox()
        ],
      )),
    );
  }
}
