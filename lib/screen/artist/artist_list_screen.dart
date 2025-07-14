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
import 'package:upculture/screen/artist/artist_detail_screen.dart';
import 'package:upculture/screen/artist/search_screen.dart';

class ArtistListScreen extends StatefulWidget {

   ArtistListScreen({Key? key,}) : super(key: key);

  @override
  State<ArtistListScreen> createState() => _ArtistListScreenState();
}

class _ArtistListScreenState extends State<ArtistListScreen> {
  CategoryController getXController = Get.put(CategoryController());

  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(), () {
      getXController.getArtistList();
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
        appBar: AppBar(
          elevation: 0,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: getXController.artistList.isNotEmpty
                ? artistListWidget()
                : const SizedBox(),
          ),
        ),
      );
    });
  }

  ///
  ///
  ///
  artistListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List<IntrinsicContentTrackSize>.generate(
            (getXController.artistList.length / 2).round(),
            (int index) => auto),
        rowGap: 15,
        columnGap: 10,
        children: [
          for (var index = 0; index < getXController.artistList.length; index++)
            InkWell(
              onTap: () {
                getXController
                    .getArtistDetail(
                        artistId: getXController.artistList[index].id)
                    .then((value) => Get.to(() => ArtistDetailScreen(
                          getXController: getXController,
                        )));
              },
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: MyColor.appColor, width: 1)),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(height * 0.9)),
                        child: getXController.artistList[index].photo != null &&
                                getXController
                                    .artistList[index].photo!.isNotEmpty
                            ? Image.network(
                                getXController.artistList[index].photo!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              )
                            : Image(
                                image: noImage,
                                width: height * 0.18,
                                height: height * 0.18,
                              ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        getXController.artistList[index].name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: MyColor.color4F4C4C,
                            fontFamily: MyFont.roboto,
                            fontWeight: MyFontWeight.medium),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
