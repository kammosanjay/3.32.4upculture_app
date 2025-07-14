import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/model/artist/request/eventdetailRequestModal.dart';
import 'package:upculture/model/artist/response/latest_event_response.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LatestChangeEvent extends StatefulWidget {
  int? id;

  LatestChangeEvent({super.key, this.id});

  @override
  State<LatestChangeEvent> createState() => _LatestChangeEventState();
}

class _LatestChangeEventState extends State<LatestChangeEvent> {
  ArtistHomeController eventCont = ArtistHomeController();

  @override
  void initState() {
    eventCont.getDetailEvent(LatestEventModalRequest(programId: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            InkWell(
                onTap: () {
                  Get.to(const SearchScreen());
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            Image.asset(
              'assets/images/Vector.png',
              height: 12,
              width: 16,
            )
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Obx(() {
          // Check if the list is empty
          if (eventCont.latestChangeEvent.isEmpty) {
            return const Center(
              child: Text("No Data Available"),
            );
          }

          // Show the first element when the list has data
          return newChangesEvent();
        }),
      ),
    );
  }

  Widget newChangesEvent() {
    var event = eventCont.latestChangeEvent[0];

    return ListView(
      children: [
        CachedNetworkImage(
          imageUrl: event.photo.toString(),
          errorWidget: (context, url, error) => ClipRRect(
              child: Image.asset(
            'assets/images/no_img.png',
            scale: 1,
            height: MediaQuery.of(context).size.height * 0.2,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          )),
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
        Visibility(visible: event.ayojakName != null && event.ayojakName!.trim().isNotEmpty,replacement: SizedBox(),
          child: Container(
            margin: EdgeInsets.only(bottom: 11, left: 20, right: 20, top: 20),
            child: Text(
              event.eventName.toString(),
              maxLines: 1,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ),

        // Organizer Info
        Container(
          padding: const EdgeInsets.all(12.0),
          margin: EdgeInsets.only(
            bottom: 15,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            "आयोजक: ${event.ayojakName.toString()}",
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
          padding: const EdgeInsets.only(
            top: 21.0,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/calenderImage.png',
                      height: 15, width: 15),
                  SizedBox(width: 10.0),
                  Text(
                    "आयोजन की आरंभ तिथि | ${event.startDate.toString()}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Visibility(visible: event.eventTime != null && event.eventTime!.trim().isNotEmpty,replacement: SizedBox(),
                child: Row(
                  children: [
                    Image.asset('assets/images/timingImage.png',
                        height: 15, width: 15),
                    SizedBox(width: 10.0),
                    Text(
                      "${event.eventTime.toString()} | ${event.eventDay}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
                Visibility(visible: event.address != null && event.address!.trim().isNotEmpty,replacement: SizedBox() ,
                  child: InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(event.addressMapLink.toString()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/CalenderLocationIcon.png',
                              height: 15, width: 15),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 8,
                            child: Text(
                              "${event.address.toString()}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/images/LocImg.png'),
                            height: 20,
                          )
                        ],
                      )),
                ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
        Visibility(visible: event.address != null && event.address!.trim().isNotEmpty,replacement: SizedBox(),
          child: Divider(
              indent: 20,
              endIndent: 20,
              height: 0,
              thickness: 1,
              color: Colors.grey),
        ),
        // Event Details

        // Description Section
        Visibility(visible: event.about != null && event.about!.trim().isNotEmpty,replacement: SizedBox(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
            child: SingleChildScrollView(child: Html(data: event.about)),
          ),
        ),
      ],
    );
  }
}
