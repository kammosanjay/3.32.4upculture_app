import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:upculture/controller/artist/artist_profile_controller.dart';

import 'package:upculture/controller/artist/category_controller.dart';

import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

import 'package:upculture/screen/artist/artist_home_screen.dart';
import 'package:upculture/screen/common/lngCodee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dialog/custom_progress_dialog.dart';
import '../../network/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../resources/my_assets.dart';

// ignore: must_be_immutable
class ArtistCategoryDetailsScreen extends StatefulWidget {
  dynamic id;

  ArtistCategoryDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ArtistCategoryDetailsScreen> createState() =>
      _ArtistCategoryDetailsScreenState();
}

class _ArtistCategoryDetailsScreenState
    extends State<ArtistCategoryDetailsScreen> {
  CategoryController getXController = Get.put(CategoryController());

  ArtistProfileController artistProfileController =
      Get.put(ArtistProfileController());
  late double height;
  late double width;
  var jsonData;
  var sharedData;

  @override
  void initState() {
    super.initState();
    print("test1");

    print("ewewewe");
    getArtistDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: MyColor.appColor));

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [MyColor.appColor, Color.fromARGB(255, 242, 163, 46)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [MyColor.appColor, Color.fromARGB(255, 242, 163, 46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: MyColor.indiaWhite,
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      share();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.share,
                        size: 20,
                        color: MyColor.indiaWhite,
                      ),
                    ),
                  ),
                ],
              ),
              body: jsonData != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            // height: height * 0.15,
                            width: width,
                           
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:
                                                  AlignmentDirectional.topEnd,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.dialog(Center(
                                                    child: Container(
                                                      height: 400,
                                                      width: 300,
                                                      child: Column(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: jsonData[
                                                                    'photo']
                                                                .toString(),
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5.0),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child: Image(
                                                                  image:
                                                                      imageProvider,
                                                                  height: 300,
                                                                  width: 300,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 50,
                                                                child: Icon(
                                                                  Icons.person,
                                                                  size: 100,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: Image(
                                                                image: noImage,
                                                                height: 100,
                                                                width: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            // height: 55,
                                                            // width: 55,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: jsonData['photo']
                                                      .toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image(
                                                        image: imageProvider,
                                                        height: 50,
                                                        width: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: CircleAvatar(
                                                      radius: 50,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: noImage,
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  // height: 55,
                                                  // width: 55,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.4,
                                              // color: Colors.green,
                                              child: Text(
                                                jsonData['name'].toString(),
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.4,
                                              // color: Colors.green,
                                              child: Text(
                                                jsonData['art_of_area']
                                                    .toString(),
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: MyFont.poppins,
                                                  fontWeight: MyFontWeight
                                                      .poppins_medium,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // color: Colors.black,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              link("youtube");
                                            },
                                            child: SvgPicture.asset(
                                              "assets/splash/youtube.svg",
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              link("instagram");
                                            },
                                            child: SizedBox(
                                              width: 10,
                                            ),
                                          ),
                                          GestureDetector(  
                                            onTap: (){
                                              link("instagram");
                                            },
                                            child: SvgPicture.asset(
                                              "assets/splash/insta.svg",
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                            "assets/splash/facebook.svg",
                                            height: 25,
                                            width: 25,
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(26),
                                        topLeft: Radius.circular(26))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        elevation: 5,
                                        child: Container(
                                          width: width,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/splash/email.svg",
                                                height: 25,
                                                width: 25,
                                                color: MyColor.appColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  link("email");
                                                },
                                                child: Container(
                                                  width: width * 0.7,
                                                  child: Text(
                                                    jsonData['email_id'],
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.blue,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          MyFont.poppins,
                                                      fontWeight: MyFontWeight
                                                          .poppins_medium,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Card(
                                        elevation: 5,
                                        child: Container(
                                          height: 50,
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/splash/location.svg",
                                                height: 25,
                                                width: 25,
                                                color: MyColor.appColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Text(
                                                  jsonData['districts_name'],
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: MyFont.poppins,
                                                    fontWeight: MyFontWeight
                                                        .poppins_medium,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Card(
                                        elevation: 5,
                                        child: Container(
                                          width: width,
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/splash/certi.svg",
                                                height: 25,
                                                width: 25,
                                                // color: MyColor.appColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Text(
                                                  jsonData['experience'],
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: MyFont.poppins,
                                                    fontWeight: MyFontWeight
                                                        .poppins_medium,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Card(
                                        elevation: 5,
                                        child: Container(
                                          width: width,
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/splash/expert.svg",
                                                height: 25,
                                                width: 25,
                                                color: MyColor.appColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Text(
                                                  jsonData['vidha_name'],
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: MyFont.poppins,
                                                    fontWeight: MyFontWeight
                                                        .poppins_medium,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Card(
                                        elevation: 5,
                                        child: Container(
                                          width: width,
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/splash/link.svg",
                                                height: 20,
                                                width: 20,
                                                color: MyColor.appColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: width * 0.7,
                                                child: Text(
                                                  jsonData['audition_link'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontFamily: MyFont.poppins,
                                                    fontWeight: MyFontWeight
                                                        .poppins_medium,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Card(
                                        elevation: 5,
                                        child: Container(
                                          width: width,
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SvgPicture.asset(
                                                "assets/splash/money.svg",
                                                height: 25,
                                                width: 25,
                                                color: MyColor.appColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                child: Text(
                                                  (jsonData['cost'] == null ||
                                                          jsonData['cost'] ==
                                                              "null" ||
                                                          jsonData["cost"] ==
                                                              "")
                                                      ? "0 Rs/-"
                                                      : jsonData['cost'] +
                                                          " Rs/-",
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: MyFont.poppins,
                                                    fontWeight: MyFontWeight
                                                        .poppins_medium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        height: 100,
                                        // color: Colors.black,
                                        width: width,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount:
                                              jsonData["presentation_images"]
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              height: height * 0.1,
                                              width: width * 0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: jsonData[
                                                            "presentation_images"]
                                                        [index]['photo']
                                                    .toString(),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image(
                                                    image: imageProvider,
                                                    height: height * 0.1,
                                                    width: width * 0.3,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image(
                                                    image: noImage,
                                                    height: height * 0.1,
                                                    width: width * 0.3,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image(
                                                    image: noImage,
                                                    height: height * 0.1,
                                                    width: width * 0.3,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              link("email");
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Image.asset(
                                                    "assets/images/user-email.png",
                                                    height: 43,
                                                    width: 43,
                                                  )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              link("whatsapp");
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Image.asset(
                                                    "assets/images/whatsapp.png",
                                                    height: 50,
                                                    width: 50,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                fixedSize:
                                                    MaterialStatePropertyAll(
                                                        Size(width,
                                                            height * 0.056))),
                                            onPressed: () {
                                              if (ArtistHomeScreen(
                                                      callFrom: 'Artist') ==
                                                  'Artist') {
                                                Get.offAll(ArtistHomeScreen(
                                                  callFrom: 'artist',
                                                  lang: MyLangCode.langcode,
                                                ));
                                              } else {
                                                Get.offAll(ArtistHomeScreen(
                                                  callFrom: 'User',
                                                  lang: MyLangCode.langcode,
                                                ));
                                              }
                                            },
                                            child: Text(
                                              "home".tr,
                                              style: TextStyle(
                                                color: MyColor.indiaWhite,
                                                fontSize: 16,
                                                fontFamily: MyFont.poppins,
                                                fontWeight:
                                                    MyFontWeight.poppins_medium,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                  : const ProgressDialogWidget(),
            ),
          ),
        ),
      ),
    );
  }

  void getArtistDetails(dynamic userId) async {
    String url = "${ApiConstants.artistDetailApi}/?user_id=$userId";
    final response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "multipart/form-data"});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['code'] == 200) {
        print(jsonResponse['data']);
        setState(() {
          jsonData = jsonResponse['data'];
        });
      }
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  void link(String type) async {
    switch (type) {
      case "instagram":
        String instagramLink = jsonData['instagram_link'].toString();
        String url = "https://www.instagram.com/$instagramLink";

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url),
              mode: LaunchMode.externalApplication);
        } else {
          print("Could not open Instagram");
        }
        break;
      case "youtube":
        String youtubeLink = jsonData['youtube_link'].toString();
        String url = "https://www.youtube.com/watch?v=$youtubeLink";

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url),
              mode: LaunchMode.externalApplication);
        } else {
          print("Could not open YouTube");
        }
        break;
      case "email":
        String email = jsonData['email_id'].toString();
        String subject = "Hello"; // Optional
        String body = "I want to discuss something."; // Optional
        String url =
            "mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          print("Could not open Email");
        }

        break;

      case "whatsapp":
        String phoneNumber = jsonData['mobile_number'].toString();
        String message = "Hello";

        String url =
            "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          print("Could not open WhatsApp");
        }
    }
  }

  void share() {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      "https://upculture.in/artist/${jsonData['user_id']}",
      subject: "UpCulture",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
