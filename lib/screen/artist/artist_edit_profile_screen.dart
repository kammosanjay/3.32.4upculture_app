import 'dart:developer';
import 'dart:io';
import 'package:chatview/chatview.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
import 'package:upculture/utils/my_style.dart';
import 'package:upculture/utils/my_widget.dart';
import '../../model/artist/response/artist_experience_response.dart' as experience;
import '../../model/artist/response/city_list_response.dart' as city;


class ArtistEditProfileScreen extends StatefulWidget {

  ArtistProfileController getXController;
  ArtistEditProfileScreen({Key? key, required this.getXController}) : super(key: key);

  @override
  State<ArtistEditProfileScreen> createState() => _ArtistEditProfileScreenState();
}

class _ArtistEditProfileScreenState extends State<ArtistEditProfileScreen> {

  late ArtistProfileController getXController;
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getXController = widget.getXController;
    getXController.formKey =  GlobalKey<FormState>();
    getXController.setEditScreenData();
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Form(
            key: getXController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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

                photoNameWidget(),

                Expanded(
                    child: ListView(
                      children: [


                        institutionName(), //require in api

                        // experienceDropdown(),

                        programsYouHaveDone(),

                        participatedEventName(),

                        // cityDropdown(),

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

                        email(),

                        mobileNumber(),

                        address(),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            MyString.smmLink,
                            style: TextStyle(
                                color: MyColor.appColor,
                                fontSize: 16,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.regular
                            ),
                          ),
                        ),

                        instagramLink(),

                        facebookLink(),

                        youtubeLink()
                      ],
                    )),

                MyWidget.getButtonWidget(label: MyString.updateProfile,
                    onPressed: (){
                      getXController.isEditProfileDataValid();
                    },
                    height: 40.0,
                    width: width)
              ],
            ),
          ),
        ),
      ),
    );
  }


  ///
  ///
  ///
  institutionName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: getXController.institutionNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              return
                value == null || value.isEmpty?
                MyString.enterInstitutionName
                    :null;
            },
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );
  }


  ///
  ///
  ///
  photoNameWidget() {
    return Row(
      children: [

        InkWell(
          onTap: (){
            showImageOptionDialog();
          },
          child: SizedBox(
            height: 60.0,
            width: 60.0,
            child: Stack(
              children: [
                Positioned(
                    top:0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: MyWidget.profilePicWidget(
                        profilePicUrl: getXController.profileImageUrl.value,
                        height: 60.0,
                        width: 60.0,
                        profileFile: getXController.compressFile),
                ),

                Positioned(
                    bottom: -2,
                    right: -2,
                    child: Image(
                      image: camerIc,
                      height: 25,
                      width: 25,
                    )
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                // MyGlobal.checkNullData(getXController.profileData.value.name),
                getXController.userName.value,
                style: TextStyle(
                    color: MyColor.appColor,
                    fontSize: 18,
                    fontFamily: MyFont.roboto,
                    fontWeight: MyFontWeight.regular
                ),
              ),

            ],
          ),
        ),

        Image(
          image: profileDashImg,
          height: 30,
          width: 30,
        )
      ],
    );
  }


  ///
  ///
  ///
  experienceDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.experience,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          DropdownSearch<experience.Data?>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  MyString.selectExperienceLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFont.roboto,
                    fontWeight: MyFontWeight.medium,
                    fontSize: 20,
                  ),
                ),
              ),
              searchFieldProps: TextFieldProps(
                cursorColor: MyColor.appColor,
                scrollPadding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: MyStyle.dropdownSearchStyle(
                    hint: MyString.searchExperienceHint),
              ),
            ),
            validator: (experience.Data? value){
              return
                value != null && value.id == 0?
                MyString.selectExperienceError
                    :null;
            },
            dropdownButtonProps:  const DropdownButtonProps(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: MyColor.appColor,),
              padding: EdgeInsets.zero,
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: MyStyle.inputFocusBorder(),
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
                contentPadding:  const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12
                ),
              ),
            ),
            items: getXController.experienceList.value,
            itemAsString: (experience.Data? u) => u!.experienceAsString(),
            selectedItem: getXController.selectedExperience.value.exprience == null? experience.Data(exprience: '', id: 0 ) :  getXController.selectedExperience.value,
            onChanged: (value) {
              setState(() {
                getXController.selectedExperience.value = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  
  
  ///
  ///
  programsYouHaveDone() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.programsYouHaveDone,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),

          TextFormField(
            controller: getXController.programDoneController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              return
                value == null || value.isEmpty?
                MyString.errorProgramsYouHaveDone
                    :null;
            },
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only n
            style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              counterText: '',
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );
  }


  ///
  ///
  ///
  participatedEventName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.nameOfEventsInWhichTheyParticipated,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          TextFormField(
            controller: getXController.participatedEventController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              return
                value == null || value.isEmpty?
                MyString.errorNameOfEventsInWhichTheyParticipated
                    :null;
            },
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );

  }

  ///
  ///
  /// selected dummy value set to city.Data(cityHindi: MyString.city, id: 0) to show hint
  // cityDropdown() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           MyString.city,
  //           style: TextStyle(
  //               color: MyColor.color4F4C4C,
  //               fontSize: 14,
  //               fontFamily: MyFont.roboto,
  //               fontWeight: MyFontWeight.regular
  //           ),
  //         ),          DropdownSearch<city.Data?>(
  //           popupProps: PopupProps.menu(
  //             showSearchBox: true,
  //             title: Padding(
  //               padding: const EdgeInsets.only(top: 10.0),
  //               child: Text(
  //                 MyString.selectCityLabel,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontFamily: MyFont.roboto,
  //                   fontWeight: MyFontWeight.medium,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //             searchFieldProps: TextFieldProps(
  //               cursorColor: MyColor.appColor,
  //               scrollPadding: const EdgeInsets.symmetric(horizontal: 15),
  //               decoration: MyStyle.dropdownSearchStyle(hint: 'यहां अपना शहर खोजें'),
  //             ),
  //           ),
  //           validator: (city.Data? value){
  //             return
  //               value != null && value.id == 0?
  //               MyString.selectCityNameError
  //                   :null;
  //           },
  //           dropdownButtonProps:  const DropdownButtonProps(
  //             icon: Icon(Icons.keyboard_arrow_down_rounded, color: MyColor.appColor,),
  //             padding: EdgeInsets.zero,
  //           ),
  //           dropdownDecoratorProps: DropDownDecoratorProps(
  //             dropdownSearchDecoration: InputDecoration(
  //               border: InputBorder.none,
  //               focusedBorder: MyStyle.inputFocusBorder(),
  //               enabledBorder: MyStyle.inputFocusBorder(),
  //               disabledBorder: MyStyle.inputFocusBorder(),
  //               errorBorder: MyStyle.inputErrorBorder(),
  //               focusedErrorBorder: MyStyle.inputErrorBorder(),
  //               contentPadding:  const EdgeInsets.symmetric(
  //                   vertical: 12,
  //                   horizontal: 12
  //               ),
  //             ),
  //           ),
  //           items: getXController.cityList,
  //           itemAsString: (city.Data? u) => u!.cityAsString(),
  //           selectedItem: getXController.selectedCity.value.cityHindi == null? city.Data(cityHindi: /*MyString.city*/ '', id: 0 ) :  getXController.selectedCity.value,
  //           onChanged: (value) {
  //             setState(() {
  //               getXController.selectedCity.value = value!;
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ///
  ///
  ///
  mobileNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.mobileNo,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: getXController.mobileController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              return
                value == null || value.isEmpty?
                MyString.enterMobileNo
                    :value.length != 10?
                MyString.validMobileNo
                    :null;
            },
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only n
            maxLength: 10,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              counterText: '',
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );
  }


  ///
  ///
  ///
  email() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.email,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: getXController.emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              return
                value == null || value.isEmpty?
                MyString.enterEmail
                    :!EmailValidator.validate(getXController.emailController.text.trim())?
                MyString.enterValidEmail
                    : null;
            },
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );

  }


  ///
  ///
  ///
  address() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.address,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          TextFormField(
            controller: getXController.addressController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              return
                value == null || value.isEmpty?
                MyString.enterAddress
                    :null;
            },
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );
  }


  ///
  ///
  ///
  instagramLink(){
    return
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MyString.instagram,
              style: TextStyle(
                  color: MyColor.color4F4C4C,
                  fontSize: 14,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.regular
              ),
            ),
            TextFormField(
              controller: getXController.instagramController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value){
                if(value.isNotEmpty){
                  setState(() {
                  });
                }
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                  color: MyColor.color1F140A,
                  fontSize: 14,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.regular),

              decoration: InputDecoration(
                contentPadding:  const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12
                ),
                border: InputBorder.none,
                enabledBorder: MyStyle.inputFocusBorder(),
                disabledBorder: MyStyle.inputFocusBorder(),
                focusedBorder: MyStyle.inputFocusBorder(),
                errorBorder: MyStyle.inputErrorBorder(),
                focusedErrorBorder: MyStyle.inputErrorBorder(),
              ),
            ),
          ],
        ),
      );
  }



  ///
  ///
  ///
  facebookLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.facebook,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          TextFormField(
            controller: getXController.facebookController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            /*validator: (String? value){
                          return
                            value == null || value.isEmpty?
                            MyString.instagramLink
                                :null;
                        },*/
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );
  }


  ///
  ///
  ///
  youtubeLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyString.youtube,
            style: TextStyle(
                color: MyColor.color4F4C4C,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular
            ),
          ),
          TextFormField(
            controller: getXController.youtubeController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            /*validator: (String? value){
                          return
                            value == null || value.isEmpty?
                            MyString.instagramLink
                                :null;
                        },*/
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {});
              }
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                color: MyColor.color1F140A,
                fontSize: 14,
                fontFamily: MyFont.roboto,
                fontWeight: MyFontWeight.regular),
            decoration: InputDecoration(
              contentPadding:  const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12
              ),
              border: InputBorder.none,
              enabledBorder: MyStyle.inputFocusBorder(),
              disabledBorder: MyStyle.inputFocusBorder(),
              focusedBorder: MyStyle.inputFocusBorder(),
              errorBorder: MyStyle.inputErrorBorder(),
              focusedErrorBorder: MyStyle.inputErrorBorder(),
            ),
          ),
        ],
      ),
    );
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
                            imageSelector(context, "gallery");
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


  ///*
  ///
  ///
  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":
      /// GALLERY IMAGE PICKER
        getXController.imageFile = (await ImagePicker()
            .pickImage(source: ImageSource.gallery, imageQuality: 90))!;
        cropImage();
        break;

      case "camera": // CAMERA CAPTURE CODE
        getXController.imageFile = (await ImagePicker()
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
      getXController.croppedFile = await ImageCropper().cropImage(
        sourcePath: getXController.imageFile!.path,
        // cropStyle: CropStyle.rectangle,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.original,
        // ],
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
              // boundary: CroppieBoundary(
              //   height: (MediaQuery.of(context).size.height*0.5).toInt(),
              //   width: (MediaQuery.of(context).size.width*0.6).toInt(),

              // )
          ),
        ],
      );


      Get.back(); //close progress dialog
      checkImageSize(getXController.croppedFile);

  }

  ///
  ///
  ///
  void checkImageSize(CroppedFile? croppedFile) async{
    String imageSize = await MyGlobal.getFileSize(croppedFile!.path, 1);
    log('ImageSize BeforeCompress:   $imageSize');

    if(imageSize.contains('byte') || imageSize.contains('KB')){
      setState(() {
        getXController.compressFile = File(getXController.croppedFile!.path);
      });

    }else if(imageSize.contains('MB')){
      var doubleImageSize = double.parse(imageSize.split('MB')[0]);
      int roundedImageSize = doubleImageSize.round();
      log('Aadhaar ImageSize MB- RoundedImageSize:   $imageSize');

      if(roundedImageSize <= 2 ){
        setState(() {
          getXController.compressFile = File(getXController.croppedFile!.path);
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
  ///
  void compressImage({required quality}) async {
    log('Aadhaar compressImage');
    DateTime now = DateTime.now();
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/${now}_temp.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      getXController.croppedFile!.path,
      targetPath,
      quality: quality,
    );

    if (result != null) {
      setState((){
        getXController.compressFile = File(result.path);
      });
      log('ImageSize AfterCompress: ${await MyGlobal.getFileSize(result.path, 1)}');

    }
  }


}
