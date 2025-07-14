import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

class MyWidget {
  ///
  ///
  /// app button widget
  static Widget getButtonWidget(
      {required label, required onPressed, required height, required width}) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(MyColor.appColor)),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.semiBold,
                  fontSize: 18),
            ),
          )),
    );
  }

  static Widget getButtonWidgetWithStyle(
      {required style,
      required label,
      required onPressed,
      required height,
      required width}) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(MyColor.appColor)),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Text(
              label,
              style: style,
            ),
          )),
    );
  }

  ///
  ///
  ///
  static Widget profilePicWidget(
      {required profileFile,
      required profilePicUrl,
      required height,
      required width,
      callFrom = ''}) {
    return Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(color: MyColor.appColor, width: 2)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: profileFile != null
                ? Image.file(
                    profileFile,
                    height: height,
                    width: width,
                  )
                : profilePicUrl != ''
                    ? Image.network(
                        profilePicUrl,
                        width: width,
                        height: height,
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image(
                              image: noProfilePic,
                              width: width,
                              height: height);
                        },
                      )
                    : Image(
                        image: noProfilePic,
                        width: width,
                        height: height,
                      )));
  }

  ///
  ///
  ///
  static Widget artistGalleryImage(
      {required galleryImage,
      required galleryImageUrl,
      required height,
      required width,
      callFrom = ''}) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: galleryImage != null
              ? Image.file(
                  galleryImage,
                  height: height,
                  width: width,
                )
              : galleryImageUrl != ''
                  ? Image.network(
                      galleryImageUrl,
                      fit: BoxFit.cover,
                      // width: double.infinity,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                  : Image(
                      image: noImage,
                      width: width,
                      height: height,
                    )),
    );
  }

  ///*
  ///
  ///
  static void showSnackBar(String value) {
    var snackBar = SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.white,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular,
                fontSize: 14),
          ),
        ),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
          },
          child: Text(
            'Dismiss',
            style: TextStyle(
              color: MyColor.appColor,
              fontSize: 12,
              fontFamily: MyFont.roboto,
              fontWeight: MyFontWeight.semiBold,
            ),
          ),
        )
      ],
    ));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  ///
  ///
  ///
  static Widget artistVideoThumbnail(
      {required youtubeThumbnail,
      required height,
      required width,
      callFrom = ''}) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: youtubeThumbnail != null && youtubeThumbnail != ''
              ? Image.network(
                  youtubeThumbnail,
                  fit: BoxFit.cover,
                  // width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              : Image(
                  image: noImage,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                )),
    );
  }

  ///
  ///
  ///
  static Widget showBigViewImage(String imageUrl) {
    return Card(
      // margin: const EdgeInsets.all(30),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return PhotoView(
                            tightMode: false,
                            imageProvider: NetworkImage(
                              imageUrl,
                            ),
                          );

                          /*return ProgressiveImage(blur:0,
                            fit: BoxFit.contain,
                            placeholder: imgPlaceholder,
                            thumbnail: NetworkImage(
                              imageUrl,
                            ),
                            image: NetworkImage(
                              imageUrl,
                            ),
                            width: constraints.maxWidth,
                            // fit: BoxFit.fill,
                            height: constraints.maxHeight,
                          );*/
                        },
                      )),
                  Positioned(
                    top: 10,
                    right: 20,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
