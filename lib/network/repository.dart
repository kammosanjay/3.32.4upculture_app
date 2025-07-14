import 'dart:convert';

import 'dart:io' as file;

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:upculture/model/artist/request/artist_category_request.dart';
import 'package:upculture/model/artist/request/artist_detail_request.dart';
import 'package:upculture/model/artist/request/artist_edit_profile_request.dart';
import 'package:upculture/model/artist/request/artist_gallery_list_request.dart';
import 'package:upculture/model/artist/request/artist_login_request.dart';
import 'package:upculture/model/artist/request/artist_profile_request.dart';
import 'package:upculture/model/artist/request/artist_registration_request.dart';
import 'package:upculture/model/artist/request/artist_registration_request_new.dart';
import 'package:upculture/model/artist/request/artist_verify_login_otp_request.dart';
import 'package:upculture/model/artist/request/artist_video_list_request.dart';
import 'package:upculture/model/artist/request/banner_detail_request.dart';
import 'package:upculture/model/artist/request/create_folder_request.dart';
import 'package:upculture/model/artist/request/culture_category_list_request.dart';
import 'package:upculture/model/artist/request/culture_sub_category_list_request.dart';
import 'package:upculture/model/artist/request/culture_sub_category_product_list_request.dart';
import 'package:upculture/model/artist/request/culture_sub_category_slider_request.dart';
import 'package:upculture/model/artist/request/date_wise_events_request.dart';
import 'package:upculture/model/artist/request/event_details_request.dart';
import 'package:upculture/model/artist/request/eventdetailRequestModal.dart';
import 'package:upculture/model/artist/request/external_detail_request.dart';
import 'package:upculture/model/artist/request/folder_list_request.dart';
import 'package:upculture/model/artist/request/heritage_detail_request.dart';
import 'package:upculture/model/artist/request/heritage_gallery_request.dart';
import 'package:upculture/model/artist/request/sub_category_detail_request.dart';
import 'package:upculture/model/artist/request/sub_category_gallery_request.dart';
import 'package:upculture/model/artist/request/sub_category_list_request.dart';
import 'package:upculture/model/artist/request/all_event_list_request.dart';
import 'package:upculture/model/artist/request/upload_artist_gallery_request.dart';
import 'package:upculture/model/artist/request/upload_artist_video_request.dart';
import 'package:upculture/model/artist/response/artist_category_response.dart';
import 'package:upculture/model/artist/response/artist_detail_response.dart';
import 'package:upculture/model/artist/response/artist_edit_profile_response.dart';
import 'package:upculture/model/artist/response/artist_experience_response.dart';
import 'package:upculture/model/artist/response/artist_gallery_list_response.dart';
import 'package:upculture/model/artist/response/artist_list_response.dart';
import 'package:upculture/model/artist/response/artist_login_response.dart';
import 'package:upculture/model/artist/response/artist_profile_response.dart';
import 'package:upculture/model/artist/response/artist_registration_response.dart';
import 'package:upculture/model/artist/response/artist_verify_login_otp_response.dart';
import 'package:upculture/model/artist/response/artist_video_list_response.dart';
import 'package:upculture/model/artist/response/banner_detail_response.dart';
import 'package:upculture/model/artist/response/banner_gallery_response.dart';
import 'package:upculture/model/artist/response/banner_list_response.dart';
import 'package:upculture/model/artist/response/category_list_response.dart';
import 'package:upculture/model/artist/response/city_list_response.dart';
import 'package:upculture/model/artist/response/create_folder_response.dart';
import 'package:upculture/model/artist/response/culture_category_list_response.dart';
import 'package:upculture/model/artist/response/culture_list_response.dart';
import 'package:upculture/model/artist/response/culture_sub_category_list_response.dart';
import 'package:upculture/model/artist/response/culture_sub_category_product_list_response.dart';
import 'package:upculture/model/artist/response/culture_sub_category_slider_response.dart';
import 'package:upculture/model/artist/response/dateWiseEventModal.dart';
import 'package:upculture/model/artist/response/date_wise_events_response.dart';
import 'package:upculture/model/artist/response/event_detail_response.dart';
import 'package:upculture/model/artist/response/event_list_response.dart';
import 'package:upculture/model/artist/response/external_detail_response.dart';
import 'package:upculture/model/artist/response/external_links_response.dart';
import 'package:upculture/model/artist/response/folder_list_response.dart';
import 'package:upculture/model/artist/response/gender_list_response.dart';
import 'package:upculture/model/artist/response/heritage_detail_response.dart';
import 'package:upculture/model/artist/response/heritage_gallery_response.dart';
import 'package:upculture/model/artist/response/heritage_list_response.dart';
import 'package:upculture/model/artist/response/lang_change_modal.dart';
import 'package:upculture/model/artist/response/latest_event_response.dart';
import 'package:upculture/model/artist/response/new_addition_response.dart';
import 'package:upculture/model/artist/response/sub_category_detail_response.dart';
import 'package:upculture/model/artist/response/sub_category_gallery_response.dart';
import 'package:upculture/model/artist/response/sub_category_list_response.dart';
import 'package:upculture/model/artist/response/types_of_artist_response.dart';
import 'package:upculture/model/artist/response/upload_artist_gallery_response.dart';
import 'package:upculture/model/artist/response/upload_artist_video_response.dart';
import 'package:upculture/network/api_client.dart';
import 'package:upculture/network/api_constants.dart';

import '../model/artist/other/eventsModal.dart';
import '../model/artist/request/artist_verify_register_otp_request.dart';

import '../model/artist/response/about_slider_response.dart';
import '../model/artist/response/about_us_response.dart';
import '../model/artist/response/artist_registration_response_new.dart';
import '../model/artist/response/culture_details_response.dart';
import '../model/artist/response/culture_prog_response.dart';
import '../model/artist/response/get_event_response.dart';
import '../model/artist/response/language_list_response.dart';
import '../model/artist/response/miscDetailsResponse.dart';
import '../model/artist/response/misc_response.dart';
import '../model/artist/response/new_addition_details_repsonse.dart';
import '../model/artist/response/structure_response.dart';
import '../model/artist/response/search_data_response.dart';

class Repository {
  ///
  ///
  ///
  static Future<ArtistRegistrationResponse?> hitArtistRegistrationApi(
      ArtistRegistrationRequest request) async {
    ArtistRegistrationResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistRegistrationApi,
        requestModel: request.toJson());

    if (result != null) {
      response = ArtistRegistrationResponse.fromJson(result);
    }
    return response;
  }

  //////////////////////////artist registration new.//////////////////////////

  static Future<ArtistRegistrationResponseNew?> hitArtistRegistrationApiNew(
      ArtistRegistrationRequestNew request) async {
    ArtistRegistrationResponseNew? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistRegistrationApi,
        requestModel: request.toJson());

    if (result != null) {
      response = ArtistRegistrationResponseNew.fromJson(result);
    }
    return response;
  }

  static Future<LanguageListResponse?> hitLanguageListApi() async {
    LanguageListResponse? response;
    final result =
        await ApiClient().getRequestFormData(url: ApiConstants.getLanguageApi);

    if (result != null) {
      response = LanguageListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<GenderListResponse?> hitGenderListApi() async {
    GenderListResponse? response;
    final result =
        await ApiClient().getRequestFormData(url: ApiConstants.genderListApi);

    if (result != null) {
      response = GenderListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<MiscResponse?> hitMiscellaneousApi({int? lang}) async {
    MiscResponse? response;
    final result = await ApiClient()
        .getRequestFormData(url: ApiConstants.MiscellaneousListApi+"?language_id=$lang");

    if (result != null) {
      response = MiscResponse.fromJson(result);
    }

    return response;
  }

  ///
  ///
  ///
  static Future<NewAdditionResponse?> hitNewAdditionApi() async {
    NewAdditionResponse? response;
    final result = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.NewAdditionApi);

    if (result != null) {
      response = NewAdditionResponse.fromJson(result);
    }

    return response;
  }

  ///
  ///
  ///
  static Future<NewAdditionDetailsResponse?> hitNewAdditionDetailApi(
      String id, String type) async {
    NewAdditionDetailsResponse? response;
    final result = await ApiClient().getRequestFormDataWithLoader(
        url: "${ApiConstants.NewAdditionDetailsApi}?recent_id=$id&type=$type");

    if (result != null) {
      response = NewAdditionDetailsResponse.fromJson(result);
    }

    return response;
  }

  ///
  ///
  ///
  static Future<structureResponse?> hitStructureApi(request) async {
    structureResponse? response;
    final result = await ApiClient().postRequestNoLoaderFormData(
        url: ApiConstants.structureOfUpApi, requestModel: jsonDecode(request));

    if (result != null) {
      response = structureResponse.fromJson(result);
    }

    return response;
  }

  ///
  ///
  ///
  static Future<MiscResponse?> hitMiscSubApi(request) async {
    MiscResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.MiscellaneousSubListApi,
        requestModel: jsonDecode(request));

    if (result != null) {
      response = MiscResponse.fromJson(result);
    }

    return response;
  }

  ///
  ///
  ///
  static Future<GetEventResponse?> hitEventSubApi(request) async {
    GetEventResponse? response;
    final result = await ApiClient().getEventRequestWithData(
        url: ApiConstants.NewAdditionGetEventApi, requestModel: request);

    if (result != null) {
      response = GetEventResponse.fromJson(result);
    }

    return response;
  }

  ///
  ///
  ///
  static Future<CityListResponse?> hitCityListApi(
      {required isLoaderShow}) async {
    if (isLoaderShow) {
      CityListResponse? response;
      final result = await ApiClient()
          .getRequestFormDataWithLoader(url: ApiConstants.cityListApi);

      if (result != null) {
        response = CityListResponse.fromJson(result);
      }
      return response;
    } else {
      CityListResponse? response;
      final result =
          await ApiClient().getRequestFormData(url: ApiConstants.cityListApi);

      if (result != null) {
        response = CityListResponse.fromJson(result);
      }
      return response;
    }
  }

  ///
  ///
  ///
  static Future<ArtistExperienceResponse?> hitExperienceListApi(
      {required isLoaderShow}) async {
    if (isLoaderShow) {
      ArtistExperienceResponse? response;
      final result = await ApiClient()
          .getRequestFormDataWithLoader(url: ApiConstants.experienceListApi);

      if (result != null) {
        response = ArtistExperienceResponse.fromJson(result);
      }
      return response;
    } else {
      ArtistExperienceResponse? response;
      final result = await ApiClient()
          .getRequestFormData(url: ApiConstants.experienceListApi);

      if (result != null) {
        response = ArtistExperienceResponse.fromJson(result);
      }
      return response;
    }
  }

  ///
  ///
  ///
  static Future<TypesOfArtistResponse?> hitTypesOfArtistApi() async {
    TypesOfArtistResponse? response;
    final result =
        await ApiClient().getRequestFormData(url: ApiConstants.artistTypesApi);

    if (result != null) {
      response = TypesOfArtistResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistLoginResponse?> hitArtistLoginApi(
      ArtistLoginRequest request) async {
    ArtistLoginResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistLoginApi, requestModel: request.toJson());

    if (result != null) {
      response = ArtistLoginResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistVerifyLoginOtpResponse?> hitVerifyLoginOtpApi(
      ArtistVerifyLoginOtpRequest request) async {
    ArtistVerifyLoginOtpResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistVerifyLoginOtpApi,
        requestModel: request.toJson());
    if (result != null) {
      response = ArtistVerifyLoginOtpResponse.fromJson(result);
    }
    return response;
  }

  static Future<ArtistVerifyLoginOtpResponse?> hitVerifyRegisterOtpApi(
      ArtistVerifyRegisterOtpRequest request) async {
    ArtistVerifyLoginOtpResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistVerifyLoginOtpApi,
        requestModel: request.toJson());
    if (result != null) {
      response = ArtistVerifyLoginOtpResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///

  static Future<ArtistProfileResponse?> hitArtistProfileApi(
      ArtistProfileRequest request) async {
    ArtistProfileResponse? response;

    print("Request Data: ${request.toJson()}");
    print("Hitting API: ${ApiConstants.artistProfileDetailApi}");

    // Send Request
    final result = await ApiClient().postRequestFormData(
      url: ApiConstants.artistProfileDetailApi,
      requestModel: request.toJson(),
    );

    // Check Response
    if (result != null) {
      try {
        print("Raw API Response: $result");
        response = ArtistProfileResponse.fromJson(result);
        print("Parsed Response: $response");
      } catch (e) {
        print("Error Parsing Response: $e");
      }
    } else {
      print("API Response is null");
    }

    return response;
  }

  ///
  ///
  /// step 1
  static Future<CultureListResponse?> hitCultureListApi({int? language}) async {
    CultureListResponse? response;
    final result = await ApiClient().getRequestFormDataWithLoader(
        url: "${ApiConstants.cultureListApi}?language_id=$language");

    if (result != null) {
      response = CultureListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///step 2 Culture_Category_List
  static Future<CultureCategoryListResponse?> hitCultureCategoryListApi(
      CultureCategoryListRequest request) async {
    print(request.cultureId);
    CultureCategoryListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureCategoryListApi,
        requestModel: request.toJson());
    print('tessssssing');
    print(result);

    if (result != null) {
      response = CultureCategoryListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///step 3 Culture_Sub_Category_List
  static Future<CultureSubCategoryListResponse?> hitCultureSubCategoryListApi(
      CultureSubCategoryListRequest request) async {
    CultureSubCategoryListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureSubCategoryListApi,
        requestModel: request.toJson());

    if (result != null) {
      response = CultureSubCategoryListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///step 4.1 culture-sub-category-slider
  static Future<CultureSubCategorySliderResponse?>
      hitCultureSubCategorySliderApi(
          CultureSubCategorySliderRequest request) async {
    CultureSubCategorySliderResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureSubCategorySliderApi,
        requestModel: request.toJson());

    if (result != null) {
      response = CultureSubCategorySliderResponse.fromJson(result);
    }
    return response;
  }

  static Future<CultureSubCategorySliderResponse?>
      hitCultureProductItemSliderApi(
          CultureSubCategorySliderRequest request) async {
    CultureSubCategorySliderResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureSubCategorySliderApi,
        requestModel: request.toJson());

    if (result != null) {
      response = CultureSubCategorySliderResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///step 4.2 culture-sub-category-product-list
  static Future<CultureSubCategoryProductListResponse?>
      hitCultureSubCategoryProductListApi(
          CultureSubCategoryProductListRequest request) async {
    CultureSubCategoryProductListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureSubCategoryProductListApi,
        requestModel: request.toJson());

    if (result != null) {
      response = CultureSubCategoryProductListResponse.fromJson(result);
    }
    return response;
  }

  static Future<CultureSubCategoryProductListResponse?>
      hitCultureSubCategoryProductItemDetailsApi(
          CultureSubCategoryProductItemListRequest request) async {
    CultureSubCategoryProductListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureSubCategoryProductItemDetailApi,
        requestModel: request.toJson());

    if (result != null) {
      var datas = CultureSubCategoryProductItemDataResponse.fromJson(result);
      response = CultureSubCategoryProductListResponse(
          data: datas.data,
          status: datas.status,
          message: datas.message,
          type: datas.type,
          code: datas.code);
    }
    return response;
  }

  ///
  ///
  ///step 4 Culture_Sub_Category_Detail
/*
  static Future<CultureSubCategoryDetailResponse?> hitCultureSubCategoryDetailApi(CultureSubCategoryDetailRequest request) async{
    CultureSubCategoryDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureSubCategoryDetailApi,
        requestModel: request.toJson()
    );

    if(result != null){
      response = CultureSubCategoryDetailResponse.fromJson(result);
    }
    return response;
  }
*/

  ///
  ///
  ///
  static Future<CategoryListResponse?> hitCategoryListApi(
      {int? language}) async {
    CategoryListResponse? response;
    final result = await ApiClient().getRequestFormDataWithLoader(
        url: "${ApiConstants.categoryListApi}?language_id=$language");

    if (result != null) {
      response = CategoryListResponse.fromJson(result);
    }
    return response;
    
  }

  ///
  ///
  ///
  static Future<AboutUsResponse?> hitAboutUsApi() async {
    AboutUsResponse? response;
    final result = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.aboutUsApi);

    if (result != null) {
      response = AboutUsResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<CultureProgramDetailsResponse?> getCultureDetailsApi(
      request) async {
    CultureProgramDetailsResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureProgramDetailsApi,
        requestModel: jsonDecode(request));

    if (result != null) {
      response = CultureProgramDetailsResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<miscSubDetailResponse?> getMiscDetailsApi(request) async {
    miscSubDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.MiscellaneousDetailsApi,
        requestModel: jsonDecode(request));

    if (result != null) {
      response = miscSubDetailResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<AboutUsSliderResponse?> hitAboutUsSliderApi() async {
    AboutUsSliderResponse? response;
    final result = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.aboutUsSliderApi);

    if (result != null) {
      response = AboutUsSliderResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<AboutUsSliderResponse?> hitCultureProgSliderApi(request) async {
    AboutUsSliderResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.cultureProgramGalleryListApi,
        requestModel: jsonDecode(request));

    if (result != null) {
      response = AboutUsSliderResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<AboutUsSliderResponse?> hitMiscSliderApi(request) async {
    AboutUsSliderResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.MiscellaneousSliderApi,
        requestModel: jsonDecode(request));

    if (result != null) {
      response = AboutUsSliderResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<SubCategoryListResponse?> hitSubCategoryListApi(
      SubCategoryListRequest request) async {
    SubCategoryListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.subCategoryListApi, requestModel: request.toJson());

    if (result != null) {
      response = SubCategoryListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<SubCategoryGalleryResponse?> hitSubCategoryGalleryApi(
      SubCategoryGalleryRequest request) async {
    SubCategoryGalleryResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.subCategoryGalleryApi,
        requestModel: request.toJson());

    if (result != null) {
      response = SubCategoryGalleryResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  /// LatestEventChangesBy User/Artist
  ///
  static Future<LatestChangeEventModal?> hitDetailEventinfo(
      LatestEventModalRequest request) async {
    LatestChangeEventModal? response;
    // final result = await ApiClient().postRequestFormData(
    //     url: ApiConstants.latestEventDetail,
    //     requestModel: request.toJson());
    final result = await http.post(Uri.parse(ApiConstants.latestEventDetail),
        body: request.toJson());

    if (result != null) {
      var jsonData = jsonDecode(result.body);
      print("testingforresult====>$jsonData");
      response = LatestChangeEventModal.fromJson(jsonData);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<SubCategoryDetailResponse?> hitSubCategoryDetailApi(
      SubCategoryDetailRequest request) async {
    SubCategoryDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.subCategoryDetailApi, requestModel: request.toJson());

    if (result != null) {
      response = SubCategoryDetailResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<BannerListResponse?> hitBannerListApi() async {
    BannerListResponse? response;
    final result = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.bannerListApi);

    if (result != null) {
      response = BannerListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<BannerDetailResponse?> hitBannerDetailApi(
      BannerDetailRequest request) async {
    BannerDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.bannerDetailApi, requestModel: request.toJson());

    if (result != null) {
      response = BannerDetailResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<BannerGalleryResponse?> hitBannerGalleryApi(
      BannerDetailRequest request) async {
    BannerGalleryResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.bannerGalleryApi, requestModel: request.toJson());

    if (result != null) {
      response = BannerGalleryResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<DateWiseEvent?> hitEventListApi(
      {DateTime? dateTime, int? lang}) async {
    // EventListResponse? response;
    DateWiseEvent? response;

    String formattedDate =
        dateTime != null ? DateFormat('yyyy-MM-dd').format(dateTime) : "";

    final result = await ApiClient().getRequestFormDataWithLoader(
        url: ApiConstants.dateWiseeventListApi +
            "?language_id=$lang&search_date=$formattedDate");
    print("eventlist date and lang code");
    print(ApiConstants.dateWiseeventListApi +
        "?language_id=$lang&search_date=$formattedDate");

    if (result != null) {
      // response = EventListResponse.fromJson(result);
      response = DateWiseEvent.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<HeritageListResponse?> hitHeritageListApi(
      {int? language}) async {
    HeritageListResponse? response;
    final result = await ApiClient().getRequestFormDataWithLoader(
        url: ApiConstants.heritageListApi + "?language_id=$language");

    if (result != null) {
      response = HeritageListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ExternalLinksResponse?> hitExternalListApi({int? lang}) async {
    ExternalLinksResponse? response;
    final result = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.externalListApi+"?language_id=$lang");

    if (result != null) {
      response = ExternalLinksResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<CultureProgramResponse?> hitCultureProgListApi(
      {int? language}) async {
    CultureProgramResponse? response;
    final result = await ApiClient().getRequestFormDataWithLoader(
        url: ApiConstants.cultureProgramListApi + "?language_id=$language");

    if (result != null) {
      response = CultureProgramResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<HeritageDetailResponse?> hitHeritageDetailApi(
      HeritageDetailRequest request) async {
    HeritageDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.heritageDetailApi, requestModel: request.toJson());

    if (result != null) {
      response = HeritageDetailResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<HeritageGalleryResponse?> hitHeritageGalleryApi(
      HeritageGalleryRequest request) async {
    HeritageGalleryResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.heritageGalleryApi, requestModel: request.toJson());

    if (result != null) {
      response = HeritageGalleryResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistEditProfileResponse?> hitArtistEditProfileApi(
      ArtistEditProfileRequest request, file.File? compressFile) async {
    ArtistEditProfileResponse? response;
    final result = await ApiClient().requestFormDataEditProfile(
        url: ApiConstants.artistEditProfileApi,
        requestModel: request,
        compressFile: compressFile);

    if (result != null) {
      response = ArtistEditProfileResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistCategoryResponse?> hitArtistCategoryApi(
      ArtistCategoryRequest request) async {
    ArtistCategoryResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistCategory, requestModel: request.toJson());

    if (result != null) {
      response = ArtistCategoryResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistListResponse?> hitArtistListApi() async {
    ArtistListResponse? response;
    final result = await ApiClient().getRequestFormDataWithLoader(
      url: ApiConstants.artistListApi,
    );

    if (result != null) {
      response = ArtistListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistDetailResponse?> hitArtistDetailApi(
      ArtistDetailRequest request) async {
    ArtistDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.artistDetailApi, requestModel: request.toJson());

    if (result != null) {
      response = ArtistDetailResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<UploadArtistGalleryResponse?> hitUploadArtistGalleryApi(
      UploadArtistGalleryRequest request) async {
    UploadArtistGalleryResponse? response;
    final result = await ApiClient().requestUploadGallery(
      url: ApiConstants.uploadArtistGalleryApi,
      requestModel: request,
    );

    if (result != null) {
      response = UploadArtistGalleryResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<UploadArtistVideoResponse?> hitUploadYoutubeVideoApi(
      UploadArtistVideoRequest request) async {
    UploadArtistVideoResponse? response;
    final result = await ApiClient().postRequestFormData(
      url: ApiConstants.uploadArtistVideoApi,
      requestModel: request.toJson(),
    );

    if (result != null) {
      response = UploadArtistVideoResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<CreateFolderResponse?> hitCreateFolderApi(
      CreateFolderRequest request) async {
    CreateFolderResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.createFolderApi, requestModel: request.toJson());

    if (result != null) {
      response = CreateFolderResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<FolderListResponse?> hitFolderListApi(
      FolderListRequest request) async {
    FolderListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.folderListApi, requestModel: request.toJson());

    if (result != null) {
      response = FolderListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistGalleryListResponse?> hitArtistGalleryListApi(
      ArtistGalleryListRequest request) async {
    ArtistGalleryListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.galleryListApi, requestModel: request.toJson());

    if (result != null) {
      response = ArtistGalleryListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ArtistVideoListResponse?> hitArtistVideoListApi(
      ArtistVideoListRequest request) async {
    ArtistVideoListResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.videoListApi, requestModel: request.toJson());

    if (result != null) {
      response = ArtistVideoListResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<UploadArtistGalleryResponse?> hitUploadMultipleGalleryApi(
    UploadArtistGalleryRequest request,
    List<XFile> multipleGallery,
  ) async {
    UploadArtistGalleryResponse? response;
    final result = await ApiClient().requestUploadMultipleGallery(
      url: ApiConstants.uploadArtistGalleryApi,
      requestModel: request,
      multipleGallery: multipleGallery,
    );

    if (result != null) {
      response = UploadArtistGalleryResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<DateWiseEventsResponse?> hitDateWiseEventsApi(
      DateWiseEventsRequest request) async {
    DateWiseEventsResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.dateWiseEventsApi, requestModel: request.toJson());

    if (result != null) {
      response = DateWiseEventsResponse.fromJson(result);
      print("--->");
      print(response);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<EventDetailsResponse?> hitEventDetailsApi(
      EventDetailsRequest request) async {
    EventDetailsResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.eventDetailsApi, requestModel: request.toJson());

    if (result != null) {
      response = EventDetailsResponse.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<DateWiseEventsResponse?> hitAllEventsApi(
      AllEventListRequest request) async {
    DateWiseEventsResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.allEventsApi, requestModel: request.toJson());

    if (result != null) {
      response = DateWiseEventsResponse.fromJson(result);
    }
    return response;
  }

  ///
  static fetchEventsOnSelectedDate(DateTime date) async {
    final String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    Events? response;
    // Replace with your actual API endpoint
    final String apiUrl = "https://example.com/api/events?date=$formattedDate";

    dynamic result = await ApiClient().getRequestFormData(url: apiUrl);
    if (result != null) {
      response = Events.fromJson(result);
    }
    return response;
  }

  ///
  ///
  ///
  static Future<ExternalDetailResponse?> hitExternalDetailsApi(
      ExternalDetailRequest request) async {
    ExternalDetailResponse? response;
    final result = await ApiClient().postRequestFormData(
        url: ApiConstants.externalDetailApi, requestModel: request.toJson());

    if (result != null) {
      response = ExternalDetailResponse.fromJson(result);
    }
    return response;
  }

  static Future<searchResponse?> searchDataApi(String search) async {
    searchResponse? response;
    final result = await ApiClient().getEventRequestWithDataSearch(
        url: "${ApiConstants.searchApi}?search=$search");

    if (result != null) {
      response = searchResponse.fromJson(result);
    }
    return response;
  }
}
