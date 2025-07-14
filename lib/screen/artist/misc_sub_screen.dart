import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

import 'misc_details_screen.dart';

class MiscSubScreen extends StatefulWidget {
  int id;
  String categoryName;

  MiscSubScreen({Key? key, required this.categoryName, required this.id})
      : super(key: key);

  @override
  State<MiscSubScreen> createState() => _MiscSubScreenState();
}

class _MiscSubScreenState extends State<MiscSubScreen> {
  ArtistHomeController getXController = Get.put(ArtistHomeController());
  late double height;
  late double width;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });

    super.initState();
  }

  getData() async {
    getXController.miscSubList.clear();
    await getXController.getMisceSubCat(widget.id);
    setState(() {});
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
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                children: [
                  if (widget.categoryName.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          widget.categoryName,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  getXController.miscSubList.isNotEmpty
                      ? subCategory()
                      : const SizedBox()
                ],
              )),
        ),
      );
    });
  }

  ///
  ///
  ///
  subCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List<IntrinsicContentTrackSize>.generate(
            (getXController.miscSubList.length / 2).round(),
            (int index) => auto),
        rowGap: 12,
        columnGap: 10,
        children: [
          for (var index = 0;
              index < getXController.miscSubList.length;
              index++)
            InkWell(
              onTap: () {
                Get.to(() => MiscDetailsScreen(
                    id: getXController.miscSubList[index].id!));
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 3)
                      ]),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: getXController.miscSubList[index].photo !=
                                    null &&
                                getXController
                                    .miscSubList[index].photo!.isNotEmpty
                            ? Image.network(
                                getXController.miscSubList[index].photo!,
                                fit: BoxFit.cover,
                                height: Get.height * 0.15,
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
                                width: width * 0.5,
                                height: height * 0.15,
                              ),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        getXController.miscSubList[index].name!,
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
