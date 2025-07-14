import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/search_screen.dart';

class SubEventListScreen extends StatefulWidget {
  String type; //today, upcoming, archive, all
  SubEventListScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<SubEventListScreen> createState() => _SubEventListScreenState();
}

class _SubEventListScreenState extends State<SubEventListScreen> {
  late double height;
  late double width;

  List<Map<DateTime, dynamic>> events = [];
  DateFormat dateFormat = DateFormat('yyyy-MM-dd'); //2023-11-23
  DateTime nowDate = DateTime.now();

  //NOTE:
  // 1. today only displays the current date calendar
  // 2. upcoming current date + 1 day to display calendar 3 month
  // 3. archive January 2023 se current date -1 (edited)

  @override
  void initState() {
    // TODO: implement initState
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [tableCalendar(), dateWiseEventList()],
        ),
      ),
    );
  }

  ///
  ///
  ///
  tableCalendar() {
    return TableCalendar(
      headerVisible: false,
      rowHeight: 45,
      daysOfWeekHeight: 30,

      ///
      /// use to show event i.e holidayName
/*
      onDaySelected: (selectedDay, focusedDay) {
        if (dateFormat.format(selectedDay).toString() == '2023-04-14') {
          setState(() {
            isEventListShow.value = true;
          });
        } else {
          setState(() {
            isEventListShow.value = false;
          });
        }
      },
*/
      weekendDays: const [],
      calendarStyle: CalendarStyle(
        isTodayHighlighted: widget.type == 'today' ? true : false,
        todayTextStyle: TextStyle(
            color: widget.type == 'today' ? Colors.white : Colors.black,
            fontFamily: MyFont.roboto,
            fontWeight: widget.type == 'today'
                ? MyFontWeight.semiBold
                : MyFontWeight.regular,
            fontSize: 12),
        todayDecoration: widget.type == 'today'
            ? BoxDecoration(
                color: MyColor.appColor,
                borderRadius: BorderRadius.circular(50))
            : const BoxDecoration(),
        selectedDecoration: BoxDecoration(
          color: MyColor.appColor,
          borderRadius: BorderRadius.circular(50),
        ),
        selectedTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: MyFont.roboto,
            fontWeight: MyFontWeight.semiBold,
            fontSize: 12),
        tablePadding: const EdgeInsets.all(10),
        defaultTextStyle: const TextStyle(
            color: Colors.black, fontFamily: MyFont.roboto, fontSize: 12),
        cellPadding: const EdgeInsets.all(0),
        cellMargin: const EdgeInsets.all(5),
      ),
      calendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {CalendarFormat.week: 'Week'},

      firstDay: getFirstDayOfCalendar(),
      lastDay: getLastDayOfCalendar(),
      focusedDay: getFocusedDayOfCalendar(),
      selectedDayPredicate: getSelectedDay,

      //use to add events for specific no. of daysi
      eventLoader: getEvents,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (BuildContext context, date, events) {
          if (events.isEmpty) {
            return const SizedBox();
          } else {
            log('EVENTS-DATA $events');
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: events[index].toString().contains("2023-04-14")
                              ? MyColor.appColor // Red
                              : Colors.transparent),
                    ),
                  );
                });
          }
        },

        dowBuilder: (context, day) {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontFamily: MyFont.roboto, fontSize: 13),
            ),
          );
        },

        //use to show absent days in Red color
        holidayBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              day.day.toString(),
              style: const TextStyle(
                  color: Colors.red, fontFamily: MyFont.roboto, fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  ///
  ///
  ///
  dateWiseEventList() {
    return Container(
      color: MyColor.appColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 0.15,
            margin: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '14 Apr',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.semiBold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                Text(
                  'Fri',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.regular,
                      fontSize: 12,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const DottedLine(
                      lineLength: double.infinity,
                      lineThickness: 0.5,
                      dashLength: 6.0,
                      dashGapLength: 6.0,
                      dashColor: Color(0xFFFFEBCD),
                    );
                  },
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                left:
                                    BorderSide(color: Colors.white, width: 2))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'आयोजन का नाम- भारत रत्न बाबा साहेब डॉ. भीमराव अम्बेडकर विश्वविद्यालय जयंती',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'आयोजन की आरंभ तिथि- 14 अप्रैल 2023',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'आयोजन की समाप्ति तिथि- 14 अप्रैल 2023',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'आयोजन का स्थान- डॉ. भीमराव अम्बेडकर विश्वविद्यालय, लखनऊ एवं अम्बेडकर पार्क, गोमतीनगर, लखनऊ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'उपस्थित लोगों की संख्या का अनुमान- 1.25 लाख लगभग  ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  ///
  ///
  ///
  List<Map<DateTime, dynamic>> getEvents(DateTime dateTime) {
    List<Map<DateTime, dynamic>> events = [];

    if (dateFormat.format(dateTime).toString() == '2023-04-14') {
      events = [
        {dateTime: '2023-04-14'}
      ];
    }

    return events;
  }

  ///
  ///
  ///
  bool getSelectedDay(DateTime selectedDay) {
    if (dateFormat.format(selectedDay).toString() == '2023-04-14') {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///
  ///
  getFirstDayOfCalendar() {
    if (widget.type == 'today') {
      return DateTime.utc(nowDate.year, nowDate.month, nowDate.day);
    } else if (widget.type == 'upcoming') {
      final tomorrow = nowDate.add(const Duration(days: 1));
      return DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day);
    }
  }

  ///
  ///
  ///
  getLastDayOfCalendar() {
    if (widget.type == 'today') {
      return DateTime.utc(nowDate.year, nowDate.month, nowDate.day);
    } else if (widget.type == 'upcoming') {
      final tomorrow = nowDate.add(const Duration(days: 1));
      final dateOf3MonthLater = Jiffy.parse(tomorrow.toString())
          .add(months: 3)
          .dateTime; // Ahead of a specific date given to Jifffy()
      return DateTime.utc(dateOf3MonthLater.year, dateOf3MonthLater.month,
          dateOf3MonthLater.day);
    }
  }

  ///
  ///
  ///
  getFocusedDayOfCalendar() {
    if (widget.type == 'today') {
      return DateTime.utc(nowDate.year, nowDate.month, nowDate.day);
    } else if (widget.type == 'upcoming') {
      final tomorrow = nowDate.add(const Duration(days: 1));
      return DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day);
    }
  }
}
