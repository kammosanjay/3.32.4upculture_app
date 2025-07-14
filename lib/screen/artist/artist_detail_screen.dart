import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/other_artist_gallery_screen.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:upculture/utils/my_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistDetailScreen extends StatefulWidget {
  CategoryController getXController;
  int? id;

  ArtistDetailScreen({Key? key, required this.getXController, this.id})
      : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late CategoryController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Obx(() {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      MyString.artistDetails,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColor.color1F140A,
                        fontSize: 20,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              ),
              MyGlobal.checkNullData(getXController.artistDetail.value.name)
                      .isNotEmpty
                  ? Expanded(
                      child: ListView(
                      children: [
                        photoNameWidget(),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade700, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: MyColor.appColor)),
                          child: Column(
                            children: [
                              artistDataWidget(
                                  label: MyString.institutionName,
                                  value: getXController
                                      .artistDetail.value.nameInstitution),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString.experience,
                                  value: getXController
                                      .artistDetail.value.exprience),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString.programsYouHaveDone,
                                  value: getXController
                                      .artistDetail.value.totalProgram
                                      .toString()),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString
                                      .nameOfEventsInWhichTheyParticipated,
                                  value: getXController
                                      .artistDetail.value.programParticipate),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString.city,
                                  value:
                                      getXController.artistDetail.value.city),
                            ],
                          ),
                        ),

                        /*Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            MyString.contactDetails,
                            style: TextStyle(
                                color: MyColor.appColor,
                                fontSize: 16,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.regular
                            ),
                          ),
                        ),*/
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade700, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: MyColor.appColor)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  MyString.contactDetails,
                                  style: TextStyle(
                                      color: MyColor.appColor,
                                      fontSize: 17,
                                      fontFamily: MyFont.roboto,
                                      fontWeight: MyFontWeight.regular),
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString.email,
                                  value:
                                      getXController.artistDetail.value.email),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString.mobileNo,
                                  value:
                                      getXController.artistDetail.value.mobile),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              artistDataWidget(
                                  label: MyString.address,
                                  value: getXController
                                      .artistDetail.value.address),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade700, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: MyColor.appColor)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  MyString.smmLink,
                                  style: TextStyle(
                                      color: MyColor.appColor,
                                      fontSize: 17,
                                      fontFamily: MyFont.roboto,
                                      fontWeight: MyFontWeight.regular),
                                ),
                              ),
                              //facebook
                              InkWell(
                                onTap: () {
                                  if (MyGlobal.checkNullData(getXController
                                          .artistDetail.value.facebookLink)
                                      .isNotEmpty) {
                                    openMediaApp(getXController
                                        .artistDetail.value.facebookLink!);
                                  }
                                },
                                child: artistDataWidget(
                                    label: MyString.facebook,
                                    value: getXController
                                        .artistDetail.value.facebookLink,
                                    type: 'link'),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              //instagram
                              InkWell(
                                onTap: () {
                                  if (MyGlobal.checkNullData(getXController
                                          .artistDetail.value.instagramLink)
                                      .isNotEmpty) {
                                    openMediaApp(getXController
                                        .artistDetail.value.instagramLink!);
                                  }
                                },
                                child: artistDataWidget(
                                    label: MyString.instagram,
                                    value: getXController
                                        .artistDetail.value.instagramLink,
                                    type: 'link'),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                              //youtube
                              InkWell(
                                onTap: () {
                                  if (MyGlobal.checkNullData(getXController
                                          .artistDetail.value.youtubeLink)
                                      .isNotEmpty) {
                                    openMediaApp(getXController
                                        .artistDetail.value.youtubeLink!);
                                  }
                                },
                                child: artistDataWidget(
                                    label: MyString.youtube,
                                    value: getXController
                                        .artistDetail.value.youtubeLink,
                                    type: 'link'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
                  : const SizedBox()
            ],
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  photoNameWidget() {
    return Row(
      children: [
        MyWidget.profilePicWidget(
            profilePicUrl:
                MyGlobal.checkNullData(getXController.artistDetail.value.photo),
            height: 60.0,
            width: 60.0,
            profileFile: null),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MyGlobal.checkNullData(getXController.artistDetail.value.name),
                style: TextStyle(
                    color: MyColor.appColor,
                    fontSize: 18,
                    fontFamily: MyFont.roboto,
                    fontWeight: MyFontWeight.regular),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => OtherArtistGalleryScreen(
                  getXController: getXController,
                  artistId: getXController.artistDetail.value.id!,
                ));
          },
          child: Image(
            image: profileDashImg,
            height: 30,
            width: 30,
          ),
        )
      ],
    );
  }

  ///
  ///
  ///
  artistDataWidget({required label, required value, type}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          minVerticalPadding: 10,
          minLeadingWidth: 10,
          horizontalTitleGap: 7,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: MyColor.appColor,
            size: 16,
          ),
          title: Text(
            label,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
          ),
          subtitle: Text(
            MyGlobal.checkNullData(value).isNotEmpty ? value : '-',
            style: TextStyle(
                color: type != null ? MyColor.color0085FF : MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
          ),
        )
      ],
    );
  }

  Future<void> openMediaApp(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
