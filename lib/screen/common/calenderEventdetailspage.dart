import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/model/artist/request/eventdetailRequestModal.dart';
import 'package:upculture/model/artist/response/latest_event_response.dart'
    as latest;
import 'package:upculture/model/artist/response/latest_event_response.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/screen/artist/artist_home_screen.dart';
import 'package:upculture/screen/calendar_test_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/artist/response/dateWiseEventModal.dart';
import '../../resources/my_assets.dart';
import '../../resources/my_font.dart';
import '../../resources/my_font_weight.dart';
import '../../resources/my_string.dart';

import '../artist/search_screen.dart';

class CalenderEventDetailPage extends StatefulWidget {
  Data? event;
  int? lang;

  CalenderEventDetailPage({super.key, this.event, this.lang});

  @override
  State<CalenderEventDetailPage> createState() =>
      _CalenderEventDetailPageState();
}

class _CalenderEventDetailPageState extends State<CalenderEventDetailPage> {
  bool? isLatetEvent = false;

  @override
  void initState() {
    super.initState();
  }

  var eventControllerDetail = Get.put(ArtistHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.appColor,
        surfaceTintColor: Colors.transparent,
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
            const SizedBox(width: 15),
            Image.asset('assets/images/Vector.png', height: 12, width: 16),
          ],
        ),
      ),
      body: Column(children: [detailEventInfo()]),
    );
  }

  Widget detailEventInfo() {
    return Expanded(
      child: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: widget.event!.photo.toString(),
            errorWidget: (context, url, error) => ClipRRect(
              child: Image.asset(
                'assets/images/no_img.png',
                scale: 1,
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            imageBuilder: (context, imageProvider) => ClipRRect(
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            placeholder: (context, url) =>
                ClipRRect(child: Icon(Icons.image_search)),
          ),

          // Title Section
          Visibility(
            visible:
                widget.event!.ayojakName != null &&
                widget.event!.ayojakName!.trim().isNotEmpty,
            replacement: SizedBox(),
            child: Container(
              margin: EdgeInsets.only(bottom: 11, left: 20, right: 20, top: 20),
              child: Text(
                widget.event!.eventName.toString(),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // Organizer Info
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    "आयोजक: ${widget.event!.ayojakName.toString()}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(0, 40)),
                    ),
                    onPressed: () async {
                      const url =
                          'https://in.bookmyshow.com/'; // BookMyShow link
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        print("Could not launch $url");
                      }
                    },
                    child: Text("Book", style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: Colors.grey,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 21.0, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/calenderImage.png',
                          height: 15,
                          width: 15,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "${'startDateofEvent'.tr} | ${widget.event!.startDate.toString()}",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Share.share(widget.event!.addressMapLink.toString());
                      },
                      child: Image.asset(
                        "assets/images/share.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Visibility(
                  visible:
                      widget.event!.eventTime != null &&
                      widget.event!.eventTime!.trim().isNotEmpty,
                  replacement: SizedBox(),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/timingImage.png',
                        height: 15,
                        width: 15,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "${widget.event!.eventTime.toString()} | ${widget.event!.eventDay}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Visibility(
                  visible:
                      widget.event!.address != null &&
                      widget.event!.address!.trim().isNotEmpty,
                  replacement: SizedBox(),
                  child: InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse(widget.event!.addressMapLink.toString()),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/CalenderLocationIcon.png',
                          height: 15,
                          width: 15,
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 8,
                          child: Text(
                            "${widget.event!.address.toString()}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Image(
                          image: AssetImage('assets/images/LocImg.png'),
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          Visibility(
            visible:
                widget.event!.address != null &&
                widget.event!.address!.trim().isNotEmpty,
            replacement: SizedBox(),
            child: Divider(
              indent: 20,
              endIndent: 20,
              height: 0,
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          // Event Details

          // Description Section
          Visibility(
            visible:
                widget.event!.about != null &&
                widget.event!.about!.trim().isNotEmpty,
            replacement: SizedBox(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
              child: SingleChildScrollView(
                child: Html(data: widget.event!.about),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newChangesEvent() {
    LatestChangeEventModal dfgdfg = LatestChangeEventModal();
    return Expanded(
      child: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: dfgdfg.photo.toString(),
            errorWidget: (context, url, error) => ClipRRect(
              child: Image.asset(
                'assets/images/no_img.png',
                scale: 1,
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            imageBuilder: (context, imageProvider) => ClipRRect(
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            placeholder: (context, url) =>
                ClipRRect(child: Icon(Icons.image_search)),
          ),

          // Title Section
          Container(
            margin: EdgeInsets.only(bottom: 11, left: 20, right: 20, top: 20),
            child: Text(
              dfgdfg.eventName.toString(),
              maxLines: 1,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Organizer Info
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "आयोजक: ${dfgdfg.ayojakName.toString()}",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: Colors.grey,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 21.0, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/calenderImage.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "आयोजन की आरंभ तिथि | ${dfgdfg.startDate.toString()}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/timingImage.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "${dfgdfg.eventTime.toString()} | ${dfgdfg.eventDay}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/sandTimeImg.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "${dfgdfg.totalTime.toString()}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/CalenderAgeIcon.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "${dfgdfg.ageLimit.toString()}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/CalenderLangIcon.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "${dfgdfg.language.toString()}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/CalenderLocationIcon.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      flex: 8,
                      child: Text(
                        "${dfgdfg.address.toString()}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    IconButton(
                      onPressed: () => launchUrl(
                        Uri.parse(dfgdfg.addressMapLink.toString()),
                      ),
                      icon: Icon(Icons.map_rounded),
                      tooltip: "Get Location",
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            height: 0,
            thickness: 1,
            color: Colors.grey,
          ),
          // Event Details

          // Description Section
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Html(data: dfgdfg.about),
              //  Text(
              //   "${widget.event!.about.toString()}",
              //   style: TextStyle(
              //     fontSize: 14.0,
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
