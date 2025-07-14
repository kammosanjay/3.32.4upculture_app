import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upculture/controller/artist/artist_profile_controller.dart';
import 'package:upculture/dialog/custom_progress_dialog.dart';
import 'package:upculture/dialog/error_dialog.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:upculture/utils/my_widget.dart';

class ArtistUploadImageScreen extends StatefulWidget {

  int folderId;
  ArtistProfileController getXController;
  ArtistUploadImageScreen({Key? key, required this.getXController, required this.folderId}) : super(key: key);

  @override
  State<ArtistUploadImageScreen> createState() => _ArtistUploadImageScreenState();
}

class _ArtistUploadImageScreenState extends State<ArtistUploadImageScreen> {

  late ArtistProfileController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
    getXController.galleryList.clear();
    getXController.compressGalleryImageFile = null;
    getXController.croppedGalleryImageFile = null;
    getXController.galleryImageFile = null;

    Future.delayed(const Duration(), (){
      getXController.getImageGalleryList(folderId: widget.folderId);
    });
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: MyColor.appColor,
    // ));
    return Obx((){
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
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
                        color: Colors.black87,
                        fontSize: 18,
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
  addImageWidget() {
    return InkWell(
      onTap: () async {
        log('test-0');
        showImageOptionDialog();
      },
      child: Container(
        width: (width * 0.26),
        height: width * 0.26,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child:
                Image(
                  image: addFolderIc,
                  width: 30,
                  height: 30,
                )
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              MyString.addImage,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
              ),
            )
          ],
        ),
      ),
    );

  }


  ///*
  ///
  ///
  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":
      /// GALLERY IMAGE PICKER
        getXController.galleryImageFile = (await ImagePicker()
            .pickImage(source: ImageSource.gallery, imageQuality: 90))!;
        cropImage();
        break;

      case "camera": // CAMERA CAPTURE CODE
        getXController.galleryImageFile = (await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 90))!;
        cropImage();
        break;
    }
  }


  ///
  ///
  ///
  void cropImage() async {
    Get.dialog(const ProgressDialogWidget());
    getXController.croppedGalleryImageFile = await ImageCropper().cropImage(
      sourcePath: getXController.galleryImageFile!.path,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: MyColor.appColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
            context: context,
            boundary: CroppieBoundary(
              height: (MediaQuery.of(context).size.height*0.5).toInt(),
              width: (MediaQuery.of(context).size.width*0.6).toInt(),

            )
        ),
      ],
    );


    Get.back(); //close progress dialog
    checkImageSize(getXController.croppedGalleryImageFile);

  }

  ///
  ///
  ///
  void checkImageSize(CroppedFile? croppedGalleryImageFile) async{
    String imageSize = await MyGlobal.getFileSize(croppedGalleryImageFile!.path, 1);
    log('ImageSize BeforeCompress:   $imageSize');

    if(imageSize.contains('byte') || imageSize.contains('KB')){
      setState(() {
        getXController.compressGalleryImageFile = File(getXController.croppedGalleryImageFile!.path);
        getXController.uploadGalleryImage(folderId: widget.folderId);
      });

    }else if(imageSize.contains('MB')){
      var doubleImageSize = double.parse(imageSize.split('MB')[0]);
      int roundedImageSize = doubleImageSize.round();
      log('Aadhaar ImageSize MB- RoundedImageSize:   $imageSize');

      if(roundedImageSize <= 2 ){
        setState(() {
          getXController.compressGalleryImageFile = File(getXController.croppedGalleryImageFile!.path);
          getXController.uploadGalleryImage(folderId: widget.folderId);
        });

      }else if(roundedImageSize <= 4){
        compressImage(quality: 50); //for 4MB image size will be 2MB

      }else if(roundedImageSize <= 5){
        compressImage(quality: 40);

      }else if(roundedImageSize <= 6){
        compressImage(quality: 35);

      }else if(roundedImageSize <= 7){
        compressImage(quality: 30 );

      }else if(roundedImageSize <= 8){
        compressImage(quality: 25  );

      }else if(roundedImageSize <= 9){
        compressImage(quality: 23);

      }else if(roundedImageSize <= 10){
        compressImage(quality: 20);

      }else if(roundedImageSize <= 11){
        compressImage(quality: 19);

      }else if(roundedImageSize <= 12){
        compressImage(quality: 17);

      }else{
        Get.dialog(ErrorDialog(msg: 'Image Size should be less than 12 MB'));
      }

    }else{
      Get.dialog(ErrorDialog(msg: 'Image Size should be less than 12 MB'));
    }
  }



  ///*
  ///
  /// croppedGalleryImageFile
  void compressImage({required quality}) async {
    log('Aadhaar compressImage');
    DateTime now = DateTime.now();
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/${now}_temp.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      getXController.croppedGalleryImageFile!.path,
      targetPath,
      quality: quality,
    );

    if (result != null) {
      setState((){
        getXController.compressGalleryImageFile = File(result.path);
        getXController.uploadGalleryImage(folderId: widget.folderId);
      });
      log('ImageSize AfterCompress: ${await MyGlobal.getFileSize(result.path, 1)}');

    }
  }

  ///
  ///
  ///
  void showImageOptionDialog() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        isDismissible: false,
        barrierColor: const Color(0xE6000000),
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      MyColor.appColor,
                      MyColor.appColor40,
                    ],
                    begin: FractionalOffset(1.0, 1.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 30,
                bottom: 30,
                top: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          onPressed: () {
                            multiImageSelector(context);
                            // imageSelector(context, "gallery");
                            Get.back();
                          },
                          backgroundColor: Colors.white70,
                          child: const Icon(
                            Icons.image,
                            color: MyColor.appColor,
                            size: 35.0,
                          )),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('Gallery',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          onPressed: () {
                            imageSelector(context, "camera");
                            Get.back();
                          },
                          backgroundColor: Colors.white70,
                          child: const Icon(
                            Icons.photo_camera,
                            color: MyColor.appColor,
                            size: 35.0,
                          )),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('Camera',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                          onPressed: () {
                            Get.back();
                          },
                          backgroundColor: Colors.white70,
                          child: const Icon(
                            Icons.cancel,
                            color: MyColor.appColor,
                            size: 35.0,
                          )),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('Cancel',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium)),
                    ],
                  )
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

              index == (getXController.galleryList.length-1)?
              addImageWidget()
                  :  imageWidget(index)
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  imageWidget(int index) {
    return InkWell(
      onTap: (){
        Get.dialog(MyWidget.showBigViewImage(getXController.galleryList[index].photo!));
      },
      child: MyWidget.artistGalleryImage(
          galleryImage: null,
          galleryImageUrl: MyGlobal.checkNullData(getXController.galleryList[index].photo),
          height: width * 0.26,
          width: width * 0.26),
    );
  }

  ///
  ///
  ///
  void multiImageSelector(BuildContext context) async{
    final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      getXController.multiGalleryImageFile.addAll(selectedImages);
      getXController.uploadMultipleGalleryImage(folderId: widget.folderId);
    }
  }

}
