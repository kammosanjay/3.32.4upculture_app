import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/category_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/utils/my_global.dart';

import 'search_screen.dart';

class CultureSubCategoryDetailScreen extends StatefulWidget {
  int cultureSubCategoryId;
  CategoryController getXController;

  CultureSubCategoryDetailScreen(
      {Key? key,
      required this.cultureSubCategoryId,
      required this.getXController})
      : super(key: key);

  @override
  State<CultureSubCategoryDetailScreen> createState() =>
      _CultureSubCategoryDetailScreenState();
}

class _CultureSubCategoryDetailScreenState
    extends State<CultureSubCategoryDetailScreen> {
  late CategoryController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
    /*Future.delayed(Duration(),(){
      getXController.getCultureSubCategoryDetail(cultureSubCategoryId: widget.cultureSubCategoryId);
    });*/
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
        body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child:
           Column(
            children: [
              /*ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            child:
            getXController.cultureSubCategoryDetail.value.photo != null &&  getXController.cultureSubCategoryDetail.value.photo!.isNotEmpty?
            ProgressiveImage(blur:0,
              placeholder: noImage,
              width: double.infinity,
              height: height * 0.2,
              thumbnail: loaderGif,
              // size: 1.29MB
              image: NetworkImage(
                getXController.cultureSubCategoryDetail.value.photo!,
              ),
            ) : Image(
              image: noImage,
              width: double.infinity,
              height: height * 0.2,
              fit: BoxFit.fill,
            ),
          ),




              Row(
                children: [
                  Expanded(
                    child: Text(
                      MyGlobal.checkNullData(getXController.cultureSubCategoryDetail.value.name),
                      style: TextStyle(
                          color: MyColor.color1F140A,
                          fontFamily: MyFont.roboto,
                          fontWeight: MyFontWeight.semiBold,
                          fontSize: 18
                      ),
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 10,),
              Expanded(
                child: Text(
                  MyGlobal.checkNullData(getXController.cultureSubCategoryDetail.value.description),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: MyColor.color4F4C4C,
                      fontFamily: MyFont.roboto,
                      fontWeight: MyFontWeight.regular,
                      fontSize: 14
                  ),
                ),)
*/
            ],
          ),
        
        ),
      );
    });
  }
}
