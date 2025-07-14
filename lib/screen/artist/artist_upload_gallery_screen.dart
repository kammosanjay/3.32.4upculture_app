import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/artist_profile_controller.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/artist_upload_image_screen.dart';
import 'package:upculture/screen/artist/youtube_player_screen.dart';
import 'package:upculture/utils/my_widget.dart';


class ArtistUploadGalleryScreen extends StatefulWidget {
  const ArtistUploadGalleryScreen({Key? key}) : super(key: key);

  @override
  State<ArtistUploadGalleryScreen> createState() => _ArtistUploadGalleryScreenState();
}

class _ArtistUploadGalleryScreenState extends State<ArtistUploadGalleryScreen> {
  ArtistProfileController getXController = Get.put(ArtistProfileController());

  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreference.getInstance();
    getXController.folderList.clear();
    getXController.youtubeVideoList.clear();

    Future.delayed(const Duration(), () {
      getXController.getFolderList();
    });

    Future.delayed(const Duration(), () {
      getXController.getVideoGalleryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyString.artistGallery,
                  style: TextStyle(color: Colors.black87, fontSize: 18, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  MyString.images,
                  style: TextStyle(color: MyColor.appColor, fontSize: 16, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                ),
                getXController.folderList.isNotEmpty ? imageGalleryWidget() : const SizedBox(),
                Text(
                  MyString.video,
                  style: TextStyle(color: MyColor.appColor, fontSize: 16, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                ),
                const SizedBox(
                  height: 10,
                ),
                // getXController.youtubeVideoList.isNotEmpty ? videoGalleryWidget() : const SizedBox()
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
  imageGalleryWidget() {
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
              index == (getXController.folderList.length - 1) ? createFolderWidget(index) : imageAndFolderWidget(index)
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  createFolderWidget(index) {
    return InkWell(
      onTap: () async {
        log('test-0');
        showCreateFolderField();
      },
      child: SizedBox(
        width: (width * 0.26),
        child: Column(
          children: [
            Container(
              width: (width * 0.26),
              height: (width * 0.26),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: MyColor.appColor, width: 1)
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image(
                  image: addFolderIc,
                  height: width * 0.26,
                  width: width * 0.26,
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
    );
  }

  ///
  ///
  ///
  showCreateFolderField() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        isScrollControlled: true,
        isDismissible: false,
        barrierColor: const Color(0x0e6000ff),
        context: Get.context!,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15, right: 15, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  MyString.createFolder,
                  style: TextStyle(color: MyColor.appColor, fontSize: 18, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.semiBold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: getXController.folderController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? MyString.errorFolderName : null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {});
                    }
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                  decoration: InputDecoration(
                    hintText: MyString.folderName,
                    hintStyle: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (getXController.folderController.text.isNotEmpty) {
                          // ArtistGalleryModel model = ArtistGalleryModel();
                          // model.id = 1;
                          // model.folderName = getXController.folderController.text.trim();
                          // model.image = upGovLogo;
                          // getXController.folderList.add(model);
                          Get.back();
                          getXController.createFolder();
                          // Get.to(() => ArtistUploadImageScreen(getXController: getXController));
                        }
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 30,
                      width: 1.5,
                      color: MyColor.color1F140A,
                    ),
                    InkWell(
                      onTap: () {
                        getXController.folderController.clear();
                        Get.back();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  ///
  ///
  /// if image is present then show first image
  imageAndFolderWidget(int index) {
    return InkWell(
      onTap: () async {
        Get.to(() => ArtistUploadImageScreen(
              getXController: getXController,
              folderId: getXController.folderList[index].id!,
            ));
      },
      child: SizedBox(
        width: (width * 0.26),
        // height: (width * 0.26),
        child: Column(
          children: [
            Container(
              width: (width * 0.26),
              height: (width * 0.26),
              // padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: getXController.folderList[index].photo != null && getXController.folderList[index].photo!.isNotEmpty
                    ? Image.network(
                        getXController.folderList[index].photo!,
                        // 'https://st2.depositphotos.com/1718692/7425/i/450/depositphotos_74257459-stock-photo-lake-near-the-mountain-in.jpg',
                        height: width * 0.26,
                        width: width * 0.26,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image(
                            image: noImage,
                            height: width * 0.26,
                            width: width * 0.26,
                          );
                        },
                      )
                    : Image(
                        image: noImage,
                        height: width * 0.26,
                        width: width * 0.26,
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
    );
  }

  ///
  ///
  ///
/*
  addVideoAndThumbnailWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: LayoutGrid(
          gridFit : GridFit.expand,

          // columnSizes: [1.fr, 1.fr, 1.fr],
          columnSizes: [(width * 0.26).px, (width * 0.26).px, (width * 0.26).px],
          // columnSizes: [auto],
          rowSizes: List<IntrinsicContentTrackSize>.generate(
              (getXController.folderGallery.length / 2).round(),
                  (int index) => auto),
          columnGap: 15,
          rowGap: 15,
          children: [
            for (var index = 0;
            index < getXController.folderGallery.length;
            index++)

              index == 0?
              addVideoWidget()
                  :  videoThumbailWidget(index)
          ],
        ),
      ),
    );
  }
*/

  ///
  ///
  ///
  addVideoWidget() {
    return InkWell(
      onTap: () async {
        log('test-0');
        Get.dialog(uploadVideoField());
      },
      child: SizedBox(
        width: (width * 0.3),
        // height: width * 0.31,
        child: Column(
          children: [
            Container(
              width: (width * 0.3),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: MyColor.appColor, width: 1)
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Column(
                  children: [
                    Image(
                      image: addFolderIc,
                      height: width * 0.21,
                      width: width * 0.3,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      MyString.add,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: MyColor.color4F4C4C, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  Widget uploadVideoField() {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 15, right: 15, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              MyString.addYoutubeLink,
              style: TextStyle(color: MyColor.appColor, fontSize: 18, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.semiBold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: getXController.videoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                return value == null || value.isEmpty ? MyString.errorYoutubeLink : null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {});
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
              decoration: InputDecoration(
                hintText: 'https://www.youtube.com/watch?v=9xwazD5SyVg',
                hintStyle: TextStyle(color: Colors.black12, fontSize: 12, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.regular),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (getXController.videoController.text.isNotEmpty) {
                      Get.back();
                      getXController.uploadYoutubeVideo();
                    }
                  },
                  child: Text(
                    'Create',
                    style: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 30,
                  width: 1.5,
                  color: MyColor.color1F140A,
                ),
                InkWell(
                  onTap: () {
                    getXController.folderController.clear();
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: MyColor.color1F140A, fontSize: 14, fontFamily: MyFont.roboto, fontWeight: MyFontWeight.medium),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  // videoGalleryWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10.0),
  //     child: SingleChildScrollView(
  //       child: LayoutGrid(
  //         gridFit: GridFit.expand,
  //         // columnSizes: [1.fr, 1.fr,],
  //         columnSizes: [(width * 0.26).px, (width * 0.26).px, (width * 0.26).px],
  //         // columnSizes: [auto],
  //         rowSizes: List<IntrinsicContentTrackSize>.generate((getXController.youtubeVideoList.length / 2).round(), (int index) => auto),
  //         columnGap: 15,
  //         rowGap: 15,
  //         children: [
  //           for (var index = 0; index < getXController.youtubeVideoList.length; index++)
  //             index == (getXController.youtubeVideoList.length - 1)
  //                 ? addVideoWidget()
  //                 : youtubeThumbnailWidget(index)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  ///
  ///
  ///
  // youtubeThumbnailWidget(int index) {
  //   return InkWell(
  //     onTap: () {
  //       if(getXController.youtubeVideoList[index].link!.contains("http")) {
  //         Get.to(() => YoutubePlayerScreen(youtubeUrl: getXController.youtubeVideoList[index].link!));
  //       } else {
  //         MyWidget.showSnackBar("Invalid Video");
  //       }
  //     },
  //     child: MyWidget.artistVideoThumbnail(
  //         youtubeThumbnail:
  //         getYoutubeThumbnail(getXController.youtubeVideoList[index].link!),
  //         height: width * 0.4,
  //         width: width * 0.3),
  //   );
  // }

  ///
  ///
  ///
  // String getYoutubeThumbnail(String videoUrl) {
    // log('YOUTUBE_VIDEO_ $videoUrl');
    // final Uri uri = Uri.parse(videoUrl);
    // var id = YoutubePlayer.convertUrlToId(videoUrl);
    // if(id == null){
    //   return "";
    // }
    // print('https://img.youtube.com/vi/$id/0.jpg');
    // return 'https://img.youtube.com/vi/$id/0.jpg';
  // }

  // ///
  // ///
  // ///
  // static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  //   if (!url.contains("http") && (url.length == 11)) return url;
  //   if (trimWhitespaces) url = url.trim();
  //
  //   for (var exp in [
  //     RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
  //     RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
  //     RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  //   ]) {
  //     Match? match = exp.firstMatch(url);
  //     if (match != null && match.groupCount >= 1) return match.group(1);
  //   }
  //
  //   return null;
  // }
}
