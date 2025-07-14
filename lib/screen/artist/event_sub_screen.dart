import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';

import '../../utils/my_global.dart';

class EventSubScreen extends StatefulWidget {
  int id;
  String categoryName;
  bool forSearch;

  EventSubScreen(
      {Key? key,
      required this.categoryName,
      required this.id,
      this.forSearch = false})
      : super(key: key);

  @override
  State<EventSubScreen> createState() => _EventSubScreenState();
}

class _EventSubScreenState extends State<EventSubScreen> {
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
    await getXController.getEventSubCat(widget.id);
    setState(() {});
    if (widget.forSearch) {
      getXController.getEventDetails(eventId: widget.id);
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
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                if (widget.categoryName.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        widget.categoryName,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  ),
                getXController.getEventList.isNotEmpty
                    ? subCategory()
                    : const SizedBox()
              ],
            )),
      ),
    );
  }

  ///
  ///
  ///
  subCategory() {
    return Container(
      color: MyColor.appLightColor,
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: DottedLine(
                lineLength: double.infinity,
                lineThickness: 0.5,
                dashLength: 6.0,
                dashGapLength: 6.0,
                dashColor: MyColor.appColor,
              ),
            );
          },
          itemCount: getXController.getEventList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: InkWell(
                onTap: () {
                  getXController.getEventDetails(
                      eventId: getXController.getEventList[index].id);
                },
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                      child: Text((index + 1).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium)),
                    ),
                    Flexible(
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                left:
                                    BorderSide(color: Colors.black, width: 2))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /* Text(
                                getXController.getEventList[index].eventName!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),*/
                              // Text(
                              //   getXController.getEventList[index].ayojakName!,
                              //   style: TextStyle(color: Colors.black, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                              // ),
                              // Text(
                              //   getXController.getEventList[index].,
                              //   style: TextStyle(color: Colors.black, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                              // ),
                              Text(
                                getXController.getEventList[index].eventDate!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),
                              // Text(
                              //   getXController.getEventList[index].eventEndTime!,
                              //   style: TextStyle(color: Colors.black, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                              // ),
                              Row(
                                children: [
                                  Text(
                                    // getXController.getEventList[index].startTime!,
                                    MyGlobal.get12HrTimeFormat(
                                        date: DateTime.now(),
                                        time: getXController.getEventList[index]
                                            .eventStartTime),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: MyFont.roboto,
                                        fontWeight: MyFontWeight.medium),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    ' - ${MyGlobal.get12HrTimeFormat(date: DateTime.now(), time: getXController.getEventList[index].eventEndTime)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: MyFont.roboto,
                                        fontWeight: MyFontWeight.medium),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
