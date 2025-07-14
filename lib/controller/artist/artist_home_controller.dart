import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:upculture/controller/artist/category_controller.dart';

import 'package:upculture/model/artist/request/artist_category_request.dart';

import 'package:upculture/model/artist/request/eventdetailRequestModal.dart';
import 'package:upculture/model/artist/response/about_us_response.dart';
import 'package:upculture/model/artist/response/artist_category_response.dart';
import 'package:upculture/model/artist/response/category_list_response.dart'
    as category;
import 'package:upculture/model/artist/response/culture_details_response.dart';
import 'package:upculture/model/artist/response/culture_list_response.dart';

import 'package:upculture/model/artist/response/lang_change_modal.dart'
    as language;
import 'package:upculture/model/artist/response/lang_change_modal.dart';
import 'package:upculture/model/artist/response/latest_event_response.dart';
import 'package:upculture/model/artist/response/miscDetailsResponse.dart';
import 'package:upculture/network/api_client.dart';
import 'package:upculture/network/api_constants.dart';
import 'package:upculture/network/repository.dart';
import 'package:upculture/model/artist/response/banner_list_response.dart'
    as banner;
import 'package:upculture/model/artist/response/event_list_response.dart'
    as event;
import 'package:upculture/model/artist/response/dateWiseEventModal.dart'
    as datewisemodal;

import 'package:upculture/model/artist/response/heritage_list_response.dart'
    as heritage;
import 'package:upculture/model/artist/response/external_links_response.dart'
    as externalData;
import 'package:upculture/screen/common/lngCodee.dart';

import '../../local_database/key_constants.dart';
import '../../local_database/my_shared_preference.dart';
import '../../model/artist/other/event_date_model.dart';
import '../../model/artist/request/artist_profile_request.dart';
import '../../model/artist/request/event_details_request.dart';
import '../../model/artist/request/external_detail_request.dart';
import 'package:upculture/model/artist/response/about_us_response.dart'
    as about;
import '../../model/artist/response/about_slider_response.dart';
import '../../model/artist/response/about_slider_response.dart' as aboutSlider;
import '../../model/artist/response/artist_profile_response.dart' as profile;
import '../../model/artist/response/culture_prog_response.dart';
import '../../model/artist/response/event_detail_response.dart';

import '../../model/artist/response/external_detail_response.dart'
    as externalDetails;
import '../../model/artist/response/get_event_response.dart';
import '../../model/artist/response/misc_response.dart';
import '../../model/artist/response/new_addition_details_repsonse.dart';
import '../../model/artist/response/new_addition_response.dart';
import '../../model/artist/response/structure_response.dart';
import '../../resources/my_assets.dart';
import '../../resources/my_color.dart';
import '../../resources/my_font.dart';
import '../../resources/my_font_weight.dart';
import '../../utils/my_global.dart';
import '../../utils/my_widget.dart';

class ArtistHomeController extends GetxController {
  var categoryList = <category.Data>[].obs;
  List<language.Data> languageList = <language.Data>[].obs;
  var bannerList = <banner.Data>[].obs;
  var eventList = <event.Data>[].obs;

  var datewiseEventList = <datewisemodal.Data>[].obs;
  var latestChangeEvent = <LatestChangeEventModal>[].obs;
  var forSearch = false.obs;
  var islatestEvent = false.obs;
  var demoSearch = <String>["dehli", 'mumbai'].obs;
  var heritageList = <heritage.Data>[].obs;
  var externalList = <externalData.Data>[].obs;
  var detail = externalDetails.Data().obs;
  var aboutSliderData = <aboutSlider.Data>[].obs;
  var cultureProgramSliderData = <aboutSlider.Data>[].obs;
  var miscSliderData = <aboutSlider.Data>[].obs;
  var cultureProgramList = <CultureData>[].obs;
  var miscList = <Misc>[].obs;
  var newAdditionList = <NewAddition>[].obs;
  var miscSubList = <Misc>[].obs;
  var selectedDate = EventDateModel().obs;
  Rx<DateTime> newDate = DateTime.now().obs;

  String structurePDF = "";
  String radioPDF = "";
  String achievementPDF = "";

  String structureName = "";
  String radioName = "";
  String achievementName = "";

  String structureThumb = "";
  String radioThumb = "";
  String achievementThumb = "";

  var errorMessage = "".obs;

  profile.Data? profileData;

  about.Data? aboutUsData;

  CultureDetails? cultureDetailsData;

  List<MiscData> miscDetailsData = [];

  AdditionDetails? newAdditionDetails;

  List<EventData> getEventList = [];

  List<SubEvent> eventDetails = [];
  RxList eventForDetails = [].obs;
  bool isDistrictFetched = false;

  // Observable for selected day

  ///
  ///

  Future<List<language.Data>>? changeLang() async {
    final result = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.changeLang);
    if (result != null) {
      var json = ChangelangModalResponse.fromJson(result);
      for (var lang in json.data!) {
        languageList.add(lang);
      }
    }
    return [];
  }

  getBannerListData({int? lang}) async {
    bannerList.clear();
    banner.BannerListResponse? response = await Repository.hitBannerListApi();
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            bannerList.value = response.data!;
          }
        }
      }
    }
    getCategoriesData(langCode: lang);
  }

  getCategoriesData({int? langCode}) async {
    categoryList.clear();
    category.CategoryListResponse? Cresponse =
        await Repository.hitCategoryListApi(language: langCode);
    getEventListData(lang: langCode);
    getStructurePDF(lang: langCode);
    getHeritageListData(lang: langCode);

    if (Cresponse != null) {
      if (Cresponse.code == 200) {
        if (Cresponse.type == 'success') {
          if (Cresponse.data != null && Cresponse.data!.isNotEmpty) {
            categoryList.value = Cresponse.data!;

            //add for artist category and district

            CultureListResponse? response =
                await Repository.hitCultureListApi(language: langCode);

            if (response != null &&
                response.code == 200 &&
                response.type == 'success') {
              if (response.data != null && response.data!.isNotEmpty) {
                int districtId = response.data![0].id ?? 0;

                // **Check if district already exists before adding**
                bool districtExists =
                    categoryList.any((element) => element.id == districtId);

                if (!districtExists) {
                  category.Data categoryData1 = category.Data();
                  categoryData1.id = districtId;
                  categoryData1.category = response.data![0].name ?? '';
                  categoryData1.photo = response.data![0].photo ?? '';
                  categoryData1.status = response.data![0].status ?? '';
                  categoryData1.createdAt = response.data![0].createdAt ?? '';
                  categoryData1.updatedAt = response.data![0].updatedAt ?? '';
                  categoryData1.langId = (response.data![0].lang ?? '') as int?;

                  if (categoryList.length >= 1) {
                    categoryList.insert(1, categoryData1);
                  } else {
                    categoryList.add(categoryData1);
                  }
                }
              }
            }
            if (categoryList.length > 8 &&
                !categoryList.any((element) => element.id == 0)) {
              category.Data categoryData0 = category.Data();
              categoryData0.id = 0;
              categoryData0.category = 'allArtist'.tr;
              categoryData0.photo = '';
              categoryData0.status = '';
              categoryData0.createdAt = '';
              categoryData0.updatedAt = '';

              categoryList.insert(0, categoryData0);
            }
          }
        }
      }
    }
    // getDistrict(lang: langCode);
  }
// Add this flag globally or inside the class

  ///
  ///
  ///
  getAboutUsData() async {
    AboutUsResponse? response = await Repository.hitAboutUsApi();

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            aboutUsData = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getCultureDetailsData(int id) async {
    var data = {"culture_program_id": id};
    CultureProgramDetailsResponse? response =
        await Repository.getCultureDetailsApi(jsonEncode(data));

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            cultureDetailsData = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getCultureProgSliderData(int id) async {
    var data = {"culture_program_id": id};
    AboutUsSliderResponse? response =
        await Repository.hitCultureProgSliderApi(jsonEncode(data));

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            cultureProgramSliderData.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getMiscDetailsData(int id) async {
    var data = {"sub_id": id};
    miscSubDetailResponse? response =
        await Repository.getMiscDetailsApi(jsonEncode(data));

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            miscDetailsData = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getAboutUsSliderData() async {
    aboutSliderData.clear();
    AboutUsSliderResponse? response = await Repository.hitAboutUsSliderApi();

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            aboutSliderData.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getMiscSliderData(int id) async {
    var data = {"sub_id": id};
    AboutUsSliderResponse? response =
        await Repository.hitMiscSliderApi(jsonEncode(data));

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            miscSliderData.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getStructurePDF({int? lang}) async {
    var data = {"structure": 1};
    structureResponse? response =
        await Repository.hitStructureApi(jsonEncode(data));
    if (response != null) {
      if (response.type == 'success') {
        structurePDF = response.data!.path.toString();
        structureName = response.data!.heading.toString();
        structureThumb = response.data!.photo.toString();
      }
    }
    getMiscellaneous(lang: lang);
    getRadioPDF();
  }

  ///
  ///
  ///
  void getRadioPDF() async {
    var data = {"structure": 2};
    structureResponse? response =
        await Repository.hitStructureApi(jsonEncode(data));
    if (response != null) {
      if (response.type == 'success') {
        radioPDF = response.data!.path.toString();
        radioName = response.data!.heading.toString();
        radioThumb = response.data!.photo.toString();
      }
    }
    getAchievementPDF();
  }

  ///
  ///
  ///
  getNewAddition() async {
    newAdditionList.clear();
    NewAdditionResponse? response = await Repository.hitNewAdditionApi();
    if (response != null) {
      if (response.type == 'success') {
        newAdditionList.value = response.data!;
      }
    }
  }

  ///
  ///
  ///
  getNewAdditionDetails(String id, String type) async {
    NewAdditionDetailsResponse? response =
        await Repository.hitNewAdditionDetailApi(id, type);
    if (response != null) {
      if (response.type == 'success') {
        newAdditionDetails = response.data!;
      }
    }
  }

  ///
  ///
  ///
  void getMiscellaneous({int? lang}) async {
    miscList.clear();
    MiscResponse? response = await Repository.hitMiscellaneousApi(lang: lang);
    if (response != null) {
      if (response.type == 'success') {
        miscList.value = response.data!;
      }
    }
  }

  ///
  ///
  ///
  getMisceSubCat(int id) async {
    var data = {"m_id": id};
    MiscResponse? response = await Repository.hitMiscSubApi(jsonEncode(data));
    if (response != null) {
      if (response.type == 'success') {
        miscSubList.value = response.data!;
      }
    }
  }

  ///
  ///
  ///
  getEventSubCat(int id) async {
    GetEventResponse? response = await Repository.hitEventSubApi(id);
    if (response != null) {
      if (response.type == 'success') {
        getEventList = response.data!;
      }
    }
  }

  ///
  ///
  ///
  void getEventDetails({required eventId}) async {
    eventDetails.clear();
    EventDetailsRequest request = EventDetailsRequest(eventId: eventId);
    EventDetailsResponse? response =
        await Repository.hitEventDetailsApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            eventDetails = response.data!;
            Get.dialog(showEventDetails());
          }
        } else {
          Get.snackbar('Error', response.message!);
        }
      } else {
        Get.snackbar('Error', response.message!);
      }
    }
  }

  void getForEventDetails({required eventId}) async {
    eventDetails.clear();
    EventDetailsRequest request = EventDetailsRequest(eventId: eventId);
    EventDetailsResponse? response =
        await Repository.hitEventDetailsApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            eventForDetails.value = response.data!;
          }
        } else {
          Get.snackbar('Error', response.message!);
        }
      } else {
        Get.snackbar('Error', response.message!);
      }
    }
  }

  ///
  ///
  ///
  Widget showEventDetails() {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedDate.value.dateTime != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${MyGlobal.checkNullData(selectedDate.value.dateTime!.day.toString())} ${DateFormat('MMM').format(selectedDate.value.dateTime!).toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.semiBold,
                                fontSize: 16,
                                color: MyColor.color1F140A),
                          ),
                          Text(
                            DateFormat('EEE')
                                .format(selectedDate.value.dateTime!)
                                .toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.regular,
                                fontSize: 12,
                                color: MyColor.color1F140A),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          getStartEndDate(
                              DateTime.parse(eventDetails[0].startDate!)),
                          Text(
                            ' - ',
                            style: TextStyle(
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.medium,
                                fontSize: 16,
                                color: MyColor.colorA8A8A8),
                          ),
                          getStartEndDate(
                              DateTime.parse(eventDetails[0].endDate!)),
                        ],
                      ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Image(
                    image: closeIc,
                    height: 25,
                    width: 25,
                  ),
                )
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: eventDetails.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: MyColor.appColor20, width: 1.2)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].name!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium,
                                    fontSize: 16,
                                    color: MyColor.color1F140A),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].ayojakName!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium,
                                    fontSize: 16,
                                    color: MyColor.color1F140A),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].presentLog!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.medium,
                                    fontSize: 16,
                                    color: MyColor.color1F140A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          '${MyGlobal.get12HrTimeFormat(date: DateTime.parse(eventDetails[index].startDate!), time: eventDetails[index].startTime)} - ${MyGlobal.get12HrTimeFormat(date: DateTime.parse(eventDetails[index].endDate!), time: eventDetails[index].endTime)}',
                          style: TextStyle(
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.regular,
                              fontSize: 12,
                              color: MyColor.color4F4C4C),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                eventDetails[index].about!,
                                style: TextStyle(
                                    fontFamily: MyFont.roboto,
                                    fontWeight: MyFontWeight.regular,
                                    fontSize: 14,
                                    color: MyColor.color4F4C4C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: MyColor.appColor20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: MyColor.appColor,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  eventDetails[index].address!,
                                  style: TextStyle(
                                      fontFamily: MyFont.roboto,
                                      fontWeight: MyFontWeight.regular,
                                      fontSize: 14,
                                      color: MyColor.color4F4C4C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyGlobal.checkNullData(eventDetails[index].photo)
                                .isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  Get.dialog(MyWidget.showBigViewImage(
                                      eventDetails[index].photo!));
                                },
                                child: MyWidget.artistGalleryImage(
                                    galleryImage: null,
                                    galleryImageUrl: eventDetails[index].photo,
                                    // galleryImageUrl: 'https://i.ytimg.com/vi/pXFLbD7hSSI/sddefault.jpg?v=64fa65fb',
                                    height: Get.width * 0.5,
                                    width: Get.width),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  getStartEndDate(DateTime dateTime) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${dateTime.day} ${DateFormat('MMM').format(dateTime).toString()}',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: MyFont.roboto,
              fontWeight: MyFontWeight.semiBold,
              fontSize: 16,
              color: MyColor.color1F140A),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          DateFormat('EEE').format(dateTime).toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: MyFont.roboto,
              fontWeight: MyFontWeight.regular,
              fontSize: 16,
              color: MyColor.color1F140A),
        )
      ],
    );
  }

  ///
  ///
  ///
  void getAchievementPDF() async {
    var data = {"structure": 3};
    structureResponse? response =
        await Repository.hitStructureApi(jsonEncode(data));
    if (response != null) {
      if (response.type == 'success') {
        achievementPDF = response.data!.path.toString();
        achievementName = response.data!.heading.toString();
        achievementThumb = response.data!.photo.toString();
      }
    }
  }

  ///
  ///
  ///

  artistProfile() async {
    // Create the request object
    ArtistProfileRequest request = ArtistProfileRequest(
      uId: MySharedPreference.getInt(KeyConstants.keyUserId),
    );

    // Debugging: Check the user ID
    print("User ID: ${MySharedPreference.getInt(KeyConstants.keyUserId)}");

    // Make the API call
    profile.ArtistProfileResponse? response =
        await Repository.hitArtistProfileApi(request);

    // Process the response
    if (response != null) {
      if (response.code == 200) {
        print("Response code is 200");

        if (response.data != null) {
          // Store the response data in profileData
          profileData = response.data!;

          print("Profile Data Stored: $profileData");
        } else {
          print("Response data is null");
        }
      } else {
        print("Unexpected response code: ${response.code}");
      }
    } else {
      print("Response is null");
    }
  }

  ///
  ///
  ///

  ///
  ///
  ///

  getEventListData({DateTime? dateTime, int? lang}) async {
    datewiseEventList.clear();
    errorMessage.value = ''; // Reset error message
    try {
      {
        datewisemodal.DateWiseEvent? response =
            await Repository.hitEventListApi(dateTime: dateTime, lang: lang);
        if (response != null) {
          if (response.code == 200 && response.type == 'success') {
            if (response.data != null && response.data!.isNotEmpty) {
              datewiseEventList.value = response.data!;

              // print("Selecte: ${datewiseEventList.length}");
            } else {
              datewiseEventList.clear();
              datewiseEventList.value = response.data!;
              errorMessage.value = "No events found for the selected date.";
            }
          } else {
            errorMessage.value = response.message ?? "Failed to fetch events.";
          }
        } else {
          errorMessage.value = "Error: No response from API.";
        }
      }
    } catch (e) {
      errorMessage.value = "Exception: ${e.toString()}";
    }
  }

  ///
  ///
  getDetailEvent(LatestEventModalRequest request) async {
    print("Request Program ID: ${request.programId}");
    errorMessage.value = "";
    islatestEvent.value = false;

    try {
      // Call API
      final result = await http.post(
        Uri.parse(ApiConstants.latestEventDetail),
        body: {"programme_id": request.programId.toString()},
      );

      if (result.statusCode == 200) {
        var jsonData = jsonDecode(result.body);

        if (jsonData['data'] != null) {
          // Check if 'data' is a list or a single object
          if (jsonData['data'] is List) {
            // Clear the previous list before adding new data
            latestChangeEvent.clear();

            // Add each item from the 'data' array to the list
            for (var item in jsonData['data']) {
              latestChangeEvent.add(LatestChangeEventModal.fromJson(item));
            }
            print("Successfully added data: ${latestChangeEvent.length}");
          } else if (jsonData['data'] is Map) {
            // If 'data' is a single object, add it directly
            latestChangeEvent.clear();
            latestChangeEvent
                .add(LatestChangeEventModal.fromJson(jsonData['data']));
            print("Single data object added.");
          } else {
            print("Unexpected data type for 'data'.");
          }
        } else {
          print("No data found in the response.");
        }
      } else {
        print("API Error: ${result.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  ///
  ///
  ///
  getHeritageListData({int? lang}) async {
    heritageList.clear();
    heritage.HeritageListResponse? response =
        await Repository.hitHeritageListApi(language: lang);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            heritageList.value = response.data!;
          }
        }
      }
    }
    getCulturalPrgramListData(language: lang);
  }

  ///
  ///
  ///
  void getExternalListData({int? lang}) async {
    externalList.clear();
    externalData.ExternalLinksResponse? response =
        await Repository.hitExternalListApi(lang: lang);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            externalList.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  void getCulturalPrgramListData({int? language}) async {
    cultureProgramList.clear();
    CultureProgramResponse? response =
        await Repository.hitCultureProgListApi(language: language);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            cultureProgramList.value = response.data!;
          }
        }
      }
    }
    getExternalListData(lang: language);
  }

  ///
  ///
  ///
  Future<void> getExternalDetails({required externalId}) async {
    ExternalDetailRequest request =
        ExternalDetailRequest(externalId: externalId);
    externalDetails.ExternalDetailResponse? response =
        await Repository.hitExternalDetailsApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            detail.value = response.data!;
          }
        } else {
          Get.snackbar('Error', response.message!);
        }
      } else {
        Get.snackbar('Error', response.message!);
      }
    }
  }

  ///
  ///
  ///
  void clearAllData() {
    categoryList.clear();
    bannerList.clear();
    eventList.clear();
    heritageList.clear();
    externalList.clear();
  }

  ///
  ///
  ///
  getDistrict({int? lang}) async {
    CultureListResponse? response =
        await Repository.hitCultureListApi(language: lang);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            category.Data categoryData1 = category.Data();
            categoryData1.id = response.data![0].id ?? 0;
            categoryData1.category = response.data![0].name ?? '';
            categoryData1.photo = response.data![0].photo ?? '';
            categoryData1.status = response.data![0].status ?? '';
            categoryData1.createdAt = response.data![0].createdAt ?? '';
            categoryData1.updatedAt = response.data![0].updatedAt ?? '';
            categoryData1.langId = (response.data![0].lang ?? '') as int?;

            if (categoryList.length >= 1) {
              categoryList.insert(1, categoryData1);
            } else {
              categoryList.add(categoryData1);
            }
          }
        }
      }
    }
    if (categoryList.length > 8) {
      category.Data categoryData0 = category.Data();
      categoryData0.id = 0;
      categoryData0.category = 'allArtist'.tr;
      categoryData0.photo = '';
      categoryData0.status = '';
      categoryData0.createdAt = '';
      categoryData0.updatedAt = '';
      categoryList.insert(0, categoryData0);
    }
    // getArtistCategory();
  }

  ///
  ///
  ///
  getArtistCategory() async {
    ArtistCategoryRequest request = ArtistCategoryRequest(category: 'कलाकार');
    ArtistCategoryResponse? response =
        await Repository.hitArtistCategoryApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          print("Category====>");
          print(response.data![0].category);
          if (response.data != null && response.data!.isNotEmpty) {
            category.Data categoryData1 = category.Data();
            categoryData1.id = response.data![0].id;
            categoryData1.category = response.data![0].category;
            categoryData1.photo = response.data![0].photo;
            categoryData1.status = '';
            categoryData1.createdAt = response.data![0].createdAt;
            categoryData1.updatedAt = response.data![0].updatedAt;
            categoryList.insert(2, categoryData1);
          }
        }
      }
    }
    // if (categoryList.length > 8) {
    //   category.Data categoryData0 = category.Data();
    //   categoryData0.id = 0;
    //   categoryData0.category = 'सभी श्रेणी';
    //   categoryData0.photo = '';
    //   categoryData0.status = '';
    //   categoryData0.createdAt = '';
    //   categoryData0.updatedAt = '';
    //   categoryList.insert(0, categoryData0);
    // }
  }
}
