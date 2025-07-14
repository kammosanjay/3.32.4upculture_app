import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';

import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

import 'package:upculture/screen/common/calenderEventdetailspage.dart';
import 'package:upculture/screen/common/lngCodee.dart';

import 'artist/search_screen.dart';

// ignore: must_be_immutable
class CalendarTestScreen extends StatefulWidget {
  int? lang;

  CalendarTestScreen({Key? key, this.lang}) : super(key: key);

  @override
  State<CalendarTestScreen> createState() => _CalendarTestScreenState();
}

class _CalendarTestScreenState extends State<CalendarTestScreen> {
  // EventController getXController = Get.put(EventController());
  var eventController = Get.put(ArtistHomeController());

  DateTime nowDate = DateTime.now();
  ScrollController scrollController = ScrollController();
  var previousSelectedIndex = 0.obs;
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    _pageController = PageController();
    print("pageCAlled>>>>>>initiate");
    eventController.datewiseEventList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.appColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 30,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            eventController.getEventListData(lang: widget.lang);
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
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
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(const SearchScreen());
              },
              child: const Icon(Icons.search, color: Colors.white),
            ),
            SizedBox(width: 15),
            // Image.asset(
            //   'assets/images/Vector.png',
            //   height: 12,
            //   width: 16,
            // )
          ],
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          calenderWidget(lang: widget.lang),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  // MyString.events,
                  'events'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: MyFont.roboto,
                    fontWeight: MyFontWeight.semiBold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          dateWiseEventList(),
        ],
      ),
    );
    // });
  }

  // Example of using PageController
  late final PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    print("pageCAlled>>>>>>disposed");
    eventController.newDate.value = DateTime.now();
    // Dispose of the PageController
    super.dispose();
  }

  Widget calenderWidget({int? lang}) {
    return Obx(
      () => TableCalendar(
        currentDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          leftChevronIcon: Icon(
            Icons.arrow_back_ios_new,
            color: MyColor.appColor,
            size: MediaQuery.of(context).size.width * 0.04, // Scaled icon size
          ),
          rightChevronIcon: Icon(
            Icons.arrow_forward_ios,
            color: MyColor.appColor,
            size: MediaQuery.of(context).size.width * 0.04, // Scaled icon size
          ),
          titleTextStyle: TextStyle(
            color: MyColor.appColor,
            fontWeight: FontWeight.bold,
            fontSize:
                MediaQuery.of(context).size.width * 0.045, // Scaled font size
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            return date.weekday == 7
                ? 'Su'
                : date.weekday == 1
                ? 'Mo'
                : date.weekday == 2
                ? 'Tu'
                : date.weekday == 3
                ? 'We'
                : date.weekday == 4
                ? 'Th'
                : date.weekday == 5
                ? 'Fr'
                : 'Sa';
          },
          weekdayStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize:
                MediaQuery.of(context).size.width * 0.035, // Scaled font size
          ),
          weekendStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize:
                MediaQuery.of(context).size.width * 0.035, // Scaled font size
          ),
        ),
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: eventController.newDate.value,
        selectedDayPredicate: (day) =>
            isSameDay(eventController.newDate.value, day),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(
            color: MyColor.appColor,
            fontSize:
                MediaQuery.of(context).size.width * 0.04, // Scaled font size
            fontWeight: FontWeight.bold,
          ),
          weekendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:
                MediaQuery.of(context).size.width * 0.04, // Scaled font size
            color: MyColor.appColor,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blueGrey,
            shape: BoxShape.circle,
          ),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          eventController.newDate.value = selectedDay;
          if (MyLangCode.langcode == 1) {
            eventController.getEventListData(dateTime: selectedDay, lang: 1);
          } else {
            eventController.getEventListData(dateTime: selectedDay, lang: 2);
          }

          print("SELECTED DATE: $selectedDay");
        },
      ),
    );
  }

  dateWiseEventList() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Obx(
      () => eventController.datewiseEventList.length == 0
          ? Container(
              height: height * 0.34,
              width: width,
              child: Center(child: Text(eventController.errorMessage.value)),
            )
          : Container(
              height: height * 0.4,
              width: width,
              // color: Colors.amber,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: eventController.datewiseEventList.length,
                itemBuilder: (context, index) {
                  final event = eventController.datewiseEventList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // color: Colors.purpleAccent,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            CalenderEventDetailPage(
                              event: eventController.datewiseEventList[index],
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: CachedNetworkImage(
                                imageUrl: event.photo.toString(),
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                    child: Container(
                                      height: 147,
                                      width: 127,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    baseColor: MyColor.appColor.withOpacity(
                                      0.3,
                                    ),
                                    period: Duration(seconds: 2),
                                    direction: ShimmerDirection.ltr,
                                    highlightColor: Colors.white,
                                  );
                                },
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      child: Container(
                                        height: 147,
                                        width: 127,
                                        child: Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image(
                                    image: Image.network(
                                      event.coverPhoto!,
                                    ).image,
                                    height: 147,
                                    width: 127,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),

                            // Date Box
                            Expanded(
                              flex: 0,
                              child: Container(
                                width: 127,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${event.startDate!}  ",
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            // Title
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                width: 127,
                                child: Text(
                                  event.eventName!,
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.orange.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(height: 4),
                            // Description
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: SizedBox(
                                  // height: 100,
                                  width: 127,
                                  child: Html(
                                    data: event.about,
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize
                                            .medium, // Customize font size
                                        textAlign: TextAlign
                                            .justify, // Example alignment
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
