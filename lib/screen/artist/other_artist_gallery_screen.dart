import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/other_artist_image_screen.dart';
import 'package:upculture/screen/artist/youtube_player_screen.dart';
import 'package:upculture/utils/my_widget.dart';

class OtherArtistGalleryScreen extends StatefulWidget {
  CategoryController getXController;
  int artistId;
  OtherArtistGalleryScreen({Key? key, required this.getXController, required this.artistId}) : super(key: key);

  @override
  State<OtherArtistGalleryScreen> createState() => _OtherArtistGalleryScreenState();
}

class _OtherArtistGalleryScreenState extends State<OtherArtistGalleryScreen> {
  late CategoryController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;

    getXController.folderList.clear();
    getXController.youtubeVideoList.clear();

    Future.delayed(const Duration(), () {
      getXController.getFolderList(artistId: widget.artistId);
    });

    Future.delayed(const Duration(), () {
      getXController.getVideoList(artistId: widget.artistId);
    });
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
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyString.artistGallery,
                  style: TextStyle(color: MyColor.appColor, fontSize: 16, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  MyString.images,
                  style: TextStyle(color: MyColor.appColor, fontSize: 16, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                ),
                getXController.folderList.isNotEmpty ? folderWidget() : const SizedBox(),
                Text(
                  MyString.video,
                  style: TextStyle(color: MyColor.appColor, fontSize: 16, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                ),
                const SizedBox(
                  height: 10,
                ),
                getXController.youtubeVideoList.isNotEmpty ? videoWidget() : const SizedBox()
              ],
            ),
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  folderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: LayoutGrid(
          gridFit: GridFit.expand,

          // columnSizes: [1.fr, 1.fr, 1.fr],
          columnSizes: [(width * 0.26).px, (width * 0.26).px, (width * 0.26).px],
          // columnSizes: [auto],
          rowSizes: List<IntrinsicContentTrackSize>.generate((getXController.folderList.length / 2).round(), (int index) => auto),
          columnGap: 15,
          rowGap: 15,
          children: [
            for (var index = 0; index < getXController.folderList.length; index++)
              InkWell(
                onTap: () async {
                  Get.to(() => OtherArtistImageScreen(
                        getXController: getXController,
                        folderId: getXController.folderList[index].id!,
                        artistId: widget.artistId,
                      ));
                },
                child: SizedBox(
                  width: (width * 0.26),
                  child: Column(
                    children: [
                      Container(
                        width: (width * 0.26),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: MyColor.appColor, width: 1)),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: getXController.folderList[index].photo != null && getXController.folderList[index].photo!.isNotEmpty
                              ? Image.network(
                                  getXController.folderList[index].photo!,
                                  height: 36.0,
                                  width: 33.0,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Image(
                                      image: noImage,
                                      height: 36.0,
                                      width: 33.0,
                                    );
                                  },
                                )
                              : Image(
                                  image: noImage,
                                  height: 36.0,
                                  width: 33.0,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        getXController.folderList[index].name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: MyColor.color4F4C4C, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                      ),
                    ],
                  ),
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
  videoWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: LayoutGrid(
          gridFit: GridFit.expand,
          // columnSizes: [1.fr, 1.fr,],
          columnSizes: [(width * 0.4).px, (width * 0.4).px /*(width * 0.26).px*/],
          // columnSizes: [auto],
          rowSizes: List<IntrinsicContentTrackSize>.generate((getXController.youtubeVideoList.length / 2).round(), (int index) => auto),
          columnGap: 15,
          rowGap: 15,
          children: [
            for (var index = 0; index < getXController.youtubeVideoList.length; index++)
              InkWell(
                onTap: () {
                  if (getXController.youtubeVideoList[index].link!.contains("http")) {
                    Get.to(() => YoutubePlayerScreen(youtubeUrl: getXController.youtubeVideoList[index].link!));
                  } else {
                    MyWidget.showSnackBar("Invalid Video");
                  }
                },
                child: MyWidget.artistVideoThumbnail(
                    youtubeThumbnail: getYoutubeThumbnail(getXController.youtubeVideoList[index].link!), height: width * 0.25, width: width * 0.4),
              )
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  String getYoutubeThumbnail(String videoUrl) {
    log('YOUTUBE_VIDEO_ $videoUrl');
    final Uri uri = Uri.parse(videoUrl);
    var id = convertUrlToId(videoUrl);
    return 'https://img.youtube.com/vi/$id/0.jpg';
  }

  ///
  ///
  ///
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }
}
