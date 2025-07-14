import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:upculture/dialog/error_dialog.dart';
import 'package:upculture/dialog/success_dialog.dart';
import 'package:upculture/local_database/key_constants.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/model/artist/request/artist_edit_profile_request.dart';
import 'package:upculture/model/artist/request/artist_gallery_list_request.dart';
import 'package:upculture/model/artist/request/artist_profile_request.dart';
import 'package:upculture/model/artist/request/artist_video_list_request.dart';
import 'package:upculture/model/artist/request/create_folder_request.dart';
import 'package:upculture/model/artist/request/folder_list_request.dart';
import 'package:upculture/model/artist/request/upload_artist_gallery_request.dart';
import 'package:upculture/model/artist/request/upload_artist_video_request.dart';
import 'package:upculture/model/artist/response/artist_edit_profile_response.dart';
import 'package:upculture/model/artist/response/create_folder_response.dart';
import 'package:upculture/model/artist/response/folder_list_response.dart'
    as folder;
import 'package:upculture/model/artist/response/artist_gallery_list_response.dart'
    as gallery;
import 'package:upculture/model/artist/response/artist_video_list_response.dart'
    as video;

import 'package:upculture/model/artist/response/upload_artist_gallery_response.dart';
import 'package:upculture/model/artist/response/upload_artist_video_response.dart';
import 'package:upculture/network/repository.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/utils/my_global.dart';
import 'package:upculture/utils/my_widget.dart';

import '../../model/artist/response/artist_profile_response.dart' as profile;
import '../../model/artist/response/artist_experience_response.dart'
    as experience;
import '../../model/artist/response/city_list_response.dart' as city;

class ArtistProfileController extends GetxController {
  var profileData = profile.Data().obs;

  late GlobalKey<FormState> formKey;
  TextEditingController institutionNameController = TextEditingController();
  TextEditingController programDoneController = TextEditingController();
  TextEditingController participatedEventController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  var experienceList = <experience.Data>[].obs;
  var selectedExperience = experience.Data().obs;
  var cityList = <city.Data>[].obs;
  var selectedCity = city.Data().obs;
  XFile? imageFile;
  CroppedFile? croppedFile;
  File? compressFile;
  var profileImageUrl = ''.obs;
  var userName = ''.obs;
  List<String> photoImg = [];
  TextEditingController folderController = TextEditingController();

  // var folderGallery = <ArtistGalleryModel>[].obs;
  var folderList = <folder.Data>[].obs;

  XFile? galleryImageFile;
  CroppedFile? croppedGalleryImageFile;
  File? compressGalleryImageFile;
  var multiGalleryImageFile = <XFile>[].obs;

  var galleryList = <gallery.Data>[].obs;

  TextEditingController videoController = TextEditingController();
  var youtubeVideoList = <video.Data>[].obs;

  ///
  ///
  ///
  // artistProfile() async{
  //   ArtistProfileRequest request = ArtistProfileRequest(
  //     uId: MySharedPreference.getInt(KeyConstants.keyUserId)
  //   );
  //   print(MySharedPreference.getInt(KeyConstants.keyUserId));
  //   profile.ArtistProfileResponse? response = await Repository.hitArtistProfileApi(request);
  //
  //   if(response != null){
  //     if(response.code == 200){
  //       if(response.type == 'success'){
  //         if(response.data != null){
  //           profileData.value = response.data!;
  //           getCityList();
  //         }
  //       }
  //     }
  //   }
  // }
  artistProfile() async {
    ArtistProfileRequest request = ArtistProfileRequest(
      uId: MySharedPreference.getInt(KeyConstants.keyUserId),
    );
    print('User ID: ${MySharedPreference.getInt(KeyConstants.keyUserId)}');

    profile.ArtistProfileResponse? response =
        await Repository.hitArtistProfileApi(request);

    if (response != null) {
      print('Response received: ${response.toJson()}');

      if (response.code == 200) {
        if (response.data != null) {
         
          profileData.value = response.data!;

          print('Profile Data updated: ${profileData.value.toJson()}');
          getCityList();
        } else {
          print('Response data is null.');
        }
      } else {
        print('Response code is not 200: ${response.code}');
      }
    } else {
      print('Response is null.');
    }
  }

  ///
  ///
  ///
  void setEditScreenData() {
    profileImageUrl.value =
        MyGlobal.checkNullData(profileData.value.userProfile.toString());
    userName.value = MyGlobal.checkNullData(profileData.value.name);
    institutionNameController.text =
        MyGlobal.checkNullData(profileData.value.nameInstitution);
    // selectedExperience.value = MyGlobal.checkNullData(profileData.value.);
    programDoneController.text =
        MyGlobal.checkNullData(profileData.value.totalProgram.toString());
    participatedEventController.text =
        MyGlobal.checkNullData(profileData.value.programParticipate);
    // selectedCity.value = MyGlobal.checkNullData(profileData.value.programParticipate);
    emailController.text =
        MyGlobal.checkNullData(profileData.value.email_id); //unique
    mobileController.text =
        MyGlobal.checkNullData(profileData.value.mobile_number); //unique
    addressController.text = MyGlobal.checkNullData(profileData.value.address);
    instagramController.text =
        MyGlobal.checkNullData(profileData.value.instagramLink);
    facebookController.text =
        MyGlobal.checkNullData(profileData.value.facebookLink);
    youtubeController.text =
        MyGlobal.checkNullData(profileData.value.youtubeLink);
  }

  ///
  ///
  ///
  void editProfileApi() async {
    ArtistEditProfileRequest request = ArtistEditProfileRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId),
        exprience: selectedExperience.value.id,
        totalProgram: int.parse(programDoneController.text.trim()),
        programParticipate: participatedEventController.text.trim(),
        city: selectedCity.value.id,
        address: addressController.text.trim(),
        instagramLink: instagramController.text.trim(),
        facebookLink: facebookController.text.trim(),
        youtubeLink: youtubeController.text.trim(),
        photo:
            compressFile != null ? compressFile!.path : profileImageUrl.value);

    ArtistEditProfileResponse? response =
        await Repository.hitArtistEditProfileApi(request, compressFile);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          Get.dialog(
              SuccessDialog(msg: response.message!, yesFunction: yesFunction));
        }
      } else {
        Get.dialog(ErrorDialog(msg: response.message));
      }
    }
  }

  ///
  ///
  ///
  yesFunction() async {
    compressFile = null;
    imageFile = null;
    croppedFile = null;
    Get.back();
    await artistProfile();
  }

  ///
  ///
  /// use to check validations for all input field
  void isEditProfileDataValid() {
    final FormState formState = formKey.currentState!;
    if (formState.validate()) {
      if (compressFile != null || profileImageUrl.isNotEmpty) {
        editProfileApi();
      } else {
        Get.dialog(ErrorDialog(msg: 'कृपया अपना प्रोफ़ाइल चित्र जोड़ें'));
      }
    }
  }

  ///
  ///
  ///
  // void getCityList() async {
  //   cityList.clear();
  //   city.CityListResponse? response =
  //       await Repository.hitCityListApi(isLoaderShow: true);
  //   if (response != null) {
  //     if (response.code == 200 && response.type == 'success') {
  //       if (response.data != null && response.data!.isNotEmpty) {
  //         cityList.value = response.data!;
  //         var result = cityList
  //             .where((city) => city.id == int.parse(profileData.value.city!));
  //         selectedCity.value = result.first;
  //       }
  //     }
  //   }
  //   getExperienceList();
  // }
  void getCityList() async {
    cityList.clear();

    // Fetch city list from API
    city.CityListResponse? response =
        await Repository.hitCityListApi(isLoaderShow: true);

    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          cityList.value = response.data!;
          print('City List Loaded: ${cityList.map((e) => e.id).toList()}');

          // Get the city ID from profile
          if (profileData.value.city != null &&
              profileData.value.city!.isNotEmpty) {
            var cityId = int.tryParse(profileData.value.city!);
            if (cityId != null) {
              var result = cityList.where((city) => city.id == cityId);
              if (result.isNotEmpty) {
                selectedCity.value = result.first;
                print('Selected City: ${selectedCity.value.cityHindi}');
              } else {
                print('No matching city found for ID: $cityId');
              }
            } else {
              print('Invalid City ID: ${profileData.value.city}');
            }
          } else {
            print('City is null or empty in profile data.');
          }
        } else {
          print('City List is empty or null.');
        }
      } else {
        print(
            'API Response Error: Code=${response.code}, Type=${response.type}');
      }
    } else {
      print('API call failed or returned null.');
    }

    // Proceed to fetch experience list
    getExperienceList();
  }

  ///
  ///
  ///
  // void getExperienceList() async {
  //   experienceList.clear();
  //   experience.ArtistExperienceResponse? response =
  //       await Repository.hitExperienceListApi(isLoaderShow: true);
  //   if (response != null) {
  //     if (response.code == 200 && response.type == 'success') {
  //       if (response.data != null && response.data!.isNotEmpty) {
  //         experienceList.value = response.data!;
  //         var result = experienceList.where((experience) =>
  //             experience.id == int.parse(profileData.value.experience!));
  //         selectedExperience.value = result.first;
  //       }
  //     }
  //   }
  // }
  void getExperienceList() async {
    experienceList.clear();

    // Fetch experience list from API
    experience.ArtistExperienceResponse? response =
        await Repository.hitExperienceListApi(isLoaderShow: true);

    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          experienceList.value = response.data!;
          print(
              'Experience List Loaded: ${experienceList.map((e) => e.id).toList()}');

          // Get the experience ID from profile
          if (profileData.value.experience != null &&
              profileData.value.experience!.isNotEmpty) {
            var experienceId = int.tryParse(profileData.value.experience!);
            if (experienceId != null) {
              var result =
                  experienceList.where((exp) => exp.id == experienceId);
              if (result.isNotEmpty) {
                selectedExperience.value = result.first;
                print(
                    'Selected Experience: ${selectedExperience.value.exprience}');
              } else {
                print('No matching experience found for ID: $experienceId');
              }
            } else {
              print('Invalid Experience ID: ${profileData.value.experience}');
            }
          } else {
            print('Experience is null or empty in profile data.');
          }
        } else {
          print('Experience List is empty or null.');
        }
      } else {
        print(
            'API Response Error: Code=${response.code}, Type=${response.type}');
      }
    } else {
      print('API call failed or returned null.');
    }
  }

  ///
  ///
  getFolderList() async {
    // folderList.clear();
    FolderListRequest request = FolderListRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId));

    folder.FolderListResponse? response =
        await Repository.hitFolderListApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          folderList.value = response.data!;
          addCreateFolderData(folderList.length);
        } else {
          addCreateFolderData(0);
        }
      } else {
        addCreateFolderData(0);
      }
    }
  }

  ///
  ///
  ///
  void uploadGalleryImage({required folderId}) async {
    UploadArtistGalleryRequest request = UploadArtistGalleryRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId),
        photo: compressGalleryImageFile!.path,
        fId: folderId);

    UploadArtistGalleryResponse? response =
        await Repository.hitUploadArtistGalleryApi(request);

    if (response != null) {
      if (response.code == 200) {
        MyWidget.showSnackBar(response.message!);
        getImageGalleryList(folderId: folderId);
        compressGalleryImageFile = null;
        croppedGalleryImageFile = null;
        galleryImageFile = null;
      }
    }
  }

  ///
  ///
  ///
  okFunction() {
    // imageFile.
  }

  ///
  ///
  ///
  void uploadYoutubeVideo() async {
    UploadArtistVideoRequest request = UploadArtistVideoRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId),
        link: videoController.text.trim());

    UploadArtistVideoResponse? response =
        await Repository.hitUploadYoutubeVideoApi(request);

    if (response != null) {
      if (response.code == 200) {
        // Get.dialog(SuccessDialog(msg: response.message!, yesFunction: okFunction));
        MyWidget.showSnackBar(response.message!);
        getVideoGalleryList();
      }
    }
  }

  ///
  ///
  ///
  void createFolder() async {
    CreateFolderRequest request = CreateFolderRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId),
        name: folderController.text.trim());

    CreateFolderResponse? response =
        await Repository.hitCreateFolderApi(request);
    if (response != null) {
      if (response.code == 200) {
        MyWidget.showSnackBar(response.message!);
        getFolderList();
      }
    }
  }

  ///
  ///
  ///
  void getImageGalleryList({required folderId}) async {
    // galleryList.clear();

    ArtistGalleryListRequest request = ArtistGalleryListRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId), fId: folderId);

    gallery.ArtistGalleryListResponse? response =
        await Repository.hitArtistGalleryListApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          galleryList.value = response.data!;
          addImageData(galleryList.length);
        } else {
          addImageData(0);
        }
      } else {
        addImageData(0);
      }
    } else {
      addImageData(0);
    }
  }

  ///
  ///
  ///
  void addImageData(int index) {
    gallery.Data data = gallery.Data();
    data.id = 0;
    data.uId = MySharedPreference.getInt(KeyConstants.keyUserId);
    data.photo = '';
    data.createdAt = '';
    data.updatedAt = '';
    data.fId = 0;
    data.status = 0;
    galleryList.insert(index, data);
  }

  ///
  ///
  ///
  getVideoGalleryList() async {
    // youtubeVideoList.clear();

    ArtistVideoListRequest request = ArtistVideoListRequest(
      uId: MySharedPreference.getInt(KeyConstants.keyUserId),
    );

    video.ArtistVideoListResponse? response =
        await Repository.hitArtistVideoListApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          youtubeVideoList.value = response.data!;
          addVideoData(youtubeVideoList.length);
        } else {
          addVideoData(0);
        }
      } else {
        addVideoData(0);
      }
    } else {
      addVideoData(0);
    }
  }

  ///
  ///
  ///
  void addVideoData(int index) {
    video.Data data = video.Data();
    data.id = 0;
    data.uId = MySharedPreference.getInt(KeyConstants.keyUserId);
    data.link = '';
    data.createdAt = '';
    data.updatedAt = '';
    data.status = 0;
    youtubeVideoList.insert(index, data);
  }

  ///
  ///
  ///
  void uploadMultipleGalleryImage({required folderId}) async {
    UploadArtistGalleryRequest request = UploadArtistGalleryRequest(
        uId: MySharedPreference.getInt(KeyConstants.keyUserId),
        photo: '',
        fId: folderId);

    UploadArtistGalleryResponse? response =
        await Repository.hitUploadMultipleGalleryApi(
            request, multiGalleryImageFile);

    if (response != null) {
      if (response.code == 200) {
        MyWidget.showSnackBar(response.message!);
        getImageGalleryList(folderId: folderId);
        multiGalleryImageFile.clear();
      }
    }
  }

  ///
  ///
  ///
  void addCreateFolderData(int index) {
    folder.Data data = folder.Data();
    data.id = 0;
    data.uId = MySharedPreference.getInt(KeyConstants.keyUserId);
    data.name = MyString.createFolder;
    data.status = '';
    data.photo = '';
    data.createdAt = '';
    data.updatedAt = '';
    folderList.insert(index, data);
  }
}
