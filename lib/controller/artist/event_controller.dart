import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:upculture/model/artist/other/event_date_model.dart';
import 'package:upculture/model/artist/request/all_event_list_request.dart';
import 'package:upculture/model/artist/request/date_wise_events_request.dart';
import 'package:upculture/model/artist/request/event_details_request.dart';
import 'package:upculture/model/artist/response/date_wise_events_response.dart'
    as dateEvent;
import 'package:upculture/model/artist/response/event_detail_response.dart'
    as detail;

import 'package:upculture/network/repository.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:upculture/utils/my_widget.dart';
import 'package:http/http.dart' as http;
import '../../model/artist/other/eventsModal.dart';

class EventController extends GetxController {
  var dateWiseEvents = <dateEvent.Data>[].obs;
  var eventDateList = <EventDateModel>[].obs;

  var eventsNotFound = ''.obs;
  var eventDetails = <detail.SubEvent>[].obs;
  var selectedDate = EventDateModel().obs;
  var globalNewEvents = <Events>[].obs;

  // late Widget showEventDetails;
  @override
  void onInit() {
  

    super.onInit();
  }

  ///
  ///
  ///
  void getDateWiseEvents(String date) async {
    dateWiseEvents.clear();
    eventsNotFound.value = '';
    DateWiseEventsRequest request = DateWiseEventsRequest(date: date);

    dateEvent.DateWiseEventsResponse? response =
        await Repository.hitDateWiseEventsApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            dateWiseEvents.value = response.data!;
          }
        } else {
          eventsNotFound.value = 'No events found for selected date';
        }
      } else {
        eventsNotFound.value = 'No events found for selected date';
      }
    } else {
      eventsNotFound.value = 'No events found for selected date';
    }
  }

  ///
  ///
  ///
  ///
  void getEventDetails({required eventId}) async {
    eventDetails.clear();
    EventDetailsRequest request = EventDetailsRequest(eventId: eventId);
    detail.EventDetailsResponse? response =
        await Repository.hitEventDetailsApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            eventDetails.value = response.data!;
            Get.dialog(showEventDetails());
          }
        } else {
          Get.snackbar('Error', response.message!);
        }
      } else {
        Get.snackbar('Error', response.message!);
      }
    }
  }

  ///
  ///
  ///
  Widget showEventDetails() {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedDate.value.dateTime != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${MyGlobal.checkNullData(selectedDate.value.dateTime!.day.toString())} ${DateFormat('MMM').format(selectedDate.value.dateTime!).toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.semiBold,
                                fontSize: 16,
                                color: MyColor.color1F140A),
                          ),
                          Text(
                            DateFormat('EEE')
                                .format(selectedDate.value.dateTime!)
                                .toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.regular,
                                fontSize: 12,
                                color: MyColor.color1F140A),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          getStartEndDate(
                              DateTime.parse(eventDetails[0].startDate!)),
                          Text(
                            ' - ',
                            style: TextStyle(
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.medium,
                                fontSize: 16,
                                color: MyColor.colorA8A8A8),
                          ),
                          getStartEndDate(
                              DateTime.parse(eventDetails[0].endDate!)),
                        ],
                      ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Image(
                    image: closeIc,
                    height: 25,
                    width: 25,
                  ),
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: eventDetails.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: MyColor.appColor20, width: 1.2)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].name!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium,
                                    fontSize: 16,
                                    color: MyColor.color1F140A),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].ayojakName!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium,
                                    fontSize: 16,
                                    color: MyColor.color1F140A),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].presentLog!,
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
                          height: 7,
                        ),
                        Text(
                          '${MyGlobal.get12HrTimeFormat(date: DateTime.parse(eventDetails[index].startDate!), time: eventDetails[index].startTime)} - ${MyGlobal.get12HrTimeFormat(date: DateTime.parse(eventDetails[index].endDate!), time: eventDetails[index].endTime)}',
                          style: TextStyle(
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.regular,
                              fontSize: 12,
                              color: MyColor.color4F4C4C),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].about!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.regular,
                                    fontSize: 14,
                                    color: MyColor.color4F4C4C),
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
                              const Icon(
                                Icons.location_on_outlined,
                                color: MyColor.appColor,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  eventDetails[index].address!,
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
                        const SizedBox(
                          height: 10,
                        ),
                        MyGlobal.checkNullData(eventDetails[index].photo)
                                .isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  Get.dialog(MyWidget.showBigViewImage(
                                      eventDetails[index].photo!));
                                },
                                child: MyWidget.artistGalleryImage(
                                    galleryImage: null,
                                    galleryImageUrl: eventDetails[index].photo,
                                    // galleryImageUrl: 'https://i.ytimg.com/vi/pXFLbD7hSSI/sddefault.jpg?v=64fa65fb',
                                    height: Get.width * 0.5,
                                    width: Get.width),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  getAllEventList({required type}) async {
    AllEventListRequest request = AllEventListRequest(event: type);

    dateEvent.DateWiseEventsResponse? response =
        await Repository.hitAllEventsApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            dateWiseEvents.value = response.data!;
          }
        } else {
          eventsNotFound.value = 'No events found';
        }
      } else {
        eventsNotFound.value = 'No events found';
      }
    } else {
      eventsNotFound.value = 'No events found';
    }
  }

  ///
  ///
  ///
  getStartEndDate(DateTime dateTime) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${dateTime.day} ${DateFormat('MMM').format(dateTime).toString()}',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: MyFont.roboto,
              fontWeight: MyFontWeight.semiBold,
              fontSize: 16,
              color: MyColor.color1F140A),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          DateFormat('EEE').format(dateTime).toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: MyFont.roboto,
              fontWeight: MyFontWeight.regular,
              fontSize: 16,
              color: MyColor.color1F140A),
        )
      ],
    );
  }

  fetchEventsOnSelectedDate(int limit) async {
    final String apiUrl = "https://fakestoreapi.com/products?limit=$limit";

    try {
      var result = await http.get(Uri.parse(apiUrl));
      print("eventList---->${result.body.toString()}");

      if (result.statusCode == 200) {
        var json = jsonDecode(result.body);
        // globalNewEvents.value = json.map<List<Events>>((e) => Events.fromJson(e));
        globalNewEvents.value =
          json.map<Events>((e) => Events.fromJson(e)).toList();
       

        return globalNewEvents.value;
      } else {
        print("Error: ${result.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception occurred: $e");
      return [];
    }
  }
}
