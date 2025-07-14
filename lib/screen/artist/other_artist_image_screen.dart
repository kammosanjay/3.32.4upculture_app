import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:upculture/utils/my_widget.dart';

class OtherArtistImageScreen extends StatefulWidget {
  int folderId;
  int artistId;
  CategoryController getXController;

  OtherArtistImageScreen({Key? key, required this.getXController, required this.folderId, required this.artistId}) : super(key: key);

  @override
  State<OtherArtistImageScreen> createState() => _OtherArtistImageScreenState();
}

class _OtherArtistImageScreenState extends State<OtherArtistImageScreen> {

  late CategoryController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
    getXController.galleryList.clear();
    Future.delayed(const Duration(), (){
      getXController.getImageList(folderId: widget.folderId, artistId: widget.artistId);
    });
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Obx((){
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40, bottom: 20),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    MyString.artistGallery,
                    style: TextStyle(
                        color: MyColor.appColor,
                        fontSize: 16,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.regular
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    MyString.images,
                    style: TextStyle(
                        color: MyColor.appColor,
                        fontSize: 16,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.regular
                    ),
                  ),
                ],
              ),

              getXController.galleryList.isNotEmpty?
              Expanded(child: imageListWidget()):const SizedBox(),


            ],
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  imageListWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SingleChildScrollView(
        child: LayoutGrid(
          gridFit : GridFit.expand,

          // columnSizes: [1.fr, 1.fr, 1.fr],
          columnSizes: [(width * 0.26).px, (width * 0.26).px, (width * 0.26).px],
          // columnSizes: [auto],
          rowSizes: List<IntrinsicContentTrackSize>.generate(
              (getXController.galleryList.length / 2).round(),
                  (int index) => auto),
          columnGap: 15,
          rowGap: 15,
          children: [
            for (var index = 0;
            index < getXController.galleryList.length;
            index++)

              InkWell(
                onTap: (){
                  Get.dialog(MyWidget.showBigViewImage(getXController.galleryList[index].photo!));
                },
                child: MyWidget.artistGalleryImage(
                    galleryImage: null,
                    galleryImageUrl: MyGlobal.checkNullData(getXController.galleryList[index].photo),
                    height: width * 0.26,
                    width: width * 0.26),
              )
          ],
        ),
      ),
    );
  }

}
