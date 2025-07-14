import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:upculture/dialog/error_dialog.dart';
import 'package:upculture/dialog/success_dialog.dart';
import 'package:upculture/local_database/key_constants.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/model/artist/request/artist_login_request.dart';
import 'package:upculture/model/artist/request/artist_registration_request.dart';
import 'package:upculture/model/artist/request/artist_verify_login_otp_request.dart';
import 'package:upculture/model/artist/response/artist_login_response.dart';
import 'package:upculture/model/artist/response/artist_registration_response.dart';
import 'package:upculture/model/artist/response/artist_verify_login_otp_response.dart';
import 'package:upculture/network/repository.dart';
import 'package:upculture/screen/artist/artist_home_screen.dart';
import 'package:upculture/screen/artist/artist_login_screen.dart';
import 'package:upculture/screen/artist/artist_otp_screen.dart';
import 'package:upculture/screen/common/lngCodee.dart';

import '../../model/artist/response/artist_experience_response.dart'
    as experience;
import '../../model/artist/response/city_list_response.dart' as city;
import '../../model/artist/response/gender_list_response.dart' as gender;
import '../../model/artist/response/types_of_artist_response.dart' as type;

// ArtistRegistrationStep1DrowResponseNew
class ArtistOnboardingController extends GetxController {
  late ArtistOnboardingController getXController;

  //login field
  late GlobalKey<FormState> loginFormKey;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  var loginResponseOtp = '1234'.obs;
  var userId = 0.obs;
  var enteredOtp = ''.obs;

  ///registration field
  late GlobalKey<FormState> registrationFormKey;
  TextEditingController nameController = TextEditingController();
  TextEditingController institutionNameController = TextEditingController();
  TextEditingController regMobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  var selectedGender = gender.Data().obs;
  var genderList = <gender.Data>[].obs;
  var selectedCity = city.Data().obs;
  var cityList = <city.Data>[].obs;
  var selectedTypeOfArtist = type.Data().obs;
  var typeOfArtistList = <type.Data>[].obs;
  var selectedExperience = experience.Data().obs;
  var experienceList = <experience.Data>[].obs;


  //otp field
  late GlobalKey<FormState> otpFormKey;

  get typesOfArtist => null;

  ///
  ///
  /// use to check validations for all input field
  void isLoginValid() {
    final FormState formState = loginFormKey.currentState!;
    if (formState.validate()) {
      log('Login validate');
      loginApi();
    }
  }

  ///
  ///
  ///
  void isOtpValidate() {
    final FormState formState = otpFormKey.currentState!;
    if (formState.validate()) {
      // verifyLoginOtp();
      MySharedPreference.setBool(KeyConstants.keyIsLogin, true);
      // Get.offAll(() => const ArtistProfileScreen());
      Get.offAll(() => ArtistHomeScreen(
            callFrom: 'Artist',
            lang: MyLangCode.langcode,
          ));
    }
  }

  ///
  ///
  ///
  void isRegistrationValidate() {
    final FormState formState = registrationFormKey.currentState!;
    if (formState.validate()) {
      registrationApi();
    }
  }

  ///
  ///
  ///
  void getTypesOfArtist() async {
    typeOfArtistList.clear();
    type.TypesOfArtistResponse? response =
        await Repository.hitTypesOfArtistApi();
    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          typeOfArtistList.value = response.data!;
        }
      }
    }
    getGenderList();
  }

  ///
  ///
  ///
  void getGenderList() async {
    genderList.clear();
    gender.GenderListResponse? response = await Repository.hitGenderListApi();
    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          genderList.value = response.data!;
        }
      }
    }
    getCityList();
  }

  ///
  ///
  ///
  void getCityList() async {
    cityList.clear();
    city.CityListResponse? response =
        await Repository.hitCityListApi(isLoaderShow: false);
    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          cityList.value = response.data!;
        }
      }
    }
    getExperienceList();
  }

  ///
  ///
  ///
  void getExperienceList() async {
    experienceList.clear();
    experience.ArtistExperienceResponse? response =
        await Repository.hitExperienceListApi(isLoaderShow: false);
    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        if (response.data != null && response.data!.isNotEmpty) {
          experienceList.value = response.data!;
        }
      }
    }
  }



  ///
  ///
  ///
  void registrationApi() async {
    ArtistRegistrationRequest request = ArtistRegistrationRequest(
        name: nameController.text.trim(),
        mobile: int.parse(regMobileController.text.trim()),
        nameInstitution: institutionNameController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        city: selectedCity.value.id,
        typeArtist: selectedTypeOfArtist.value.id,
        exprience: selectedExperience.value.id,
        gander: selectedGender.value.id,
        dateOfBirth: dobController.text.trim(),
        instagramLink: instagramController.text.trim(),
        facebookLink: facebookController.text.trim(),
        youtubeLink: youtubeController.text.trim());

    ArtistRegistrationResponse? response =
        await Repository.hitArtistRegistrationApi(request);

    if (response != null) {
      if (response.code == 200 && response.type == 'success') {
        Get.dialog(
            SuccessDialog(
              msg: response.message!,
              yesFunction: successFunction,
            ),
            barrierDismissible: false);
      } else {
        Get.dialog(ErrorDialog(msg: response.message!),
            barrierDismissible: false);
      }
    }
  }

  ///
  ///
  ///
  void clearAllRegistrationField() {
    nameController.clear();
    institutionNameController.clear();
    regMobileController.clear();
    emailController.clear();
    addressController.clear();
    dobController.clear();
    instagramController.clear();
    facebookController.clear();
    youtubeController.clear();
    // genderList.clear();
    selectedGender.value = gender.Data();
    // cityList.clear();
    selectedCity.value = city.Data();
    // typeOfArtistList.clear();
    selectedTypeOfArtist.value = type.Data();
    // experienceList.clear();
    selectedExperience.value = experience.Data();
  }

  ///
  ///
  ///
  clearAllLoginField() {
    mobileController.clear();
    otpController.clear();
    loginResponseOtp.value = '';
    enteredOtp.value = '';
  }

  ///
  ///
  ///
  void loginApi() async {
    ArtistLoginRequest request =
        ArtistLoginRequest(mobile: int.parse(mobileController.text.trim()));
    ArtistLoginResponse? response = await Repository.hitArtistLoginApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            loginResponseOtp.value = response.data!.otp.toString();
            print("csxcscscs ${response.type}   ${response.data!.otp}   ${response.data!.user_id}");
            userId.value = response.data!.user_id!;

            MySharedPreference.setInt(KeyConstants.keyUserId, userId.value);

            Get.to(() => ArtistOtpScreen(getXController: getXController,otp_value: response.data!.otp.toString(),userId: response.data!.user_id.toString()));
          }
        }
      } else {
        log('loginApi Response ${response.code} ${response.message}');
        Get.dialog(ErrorDialog(msg: response.message));
      }
    }
  }

  ///
  ///
  ///
  void verifyLoginOtp() async {
    ArtistVerifyLoginOtpRequest request = ArtistVerifyLoginOtpRequest(
        uId: userId.value, otp: int.parse(loginResponseOtp.value));
    ArtistVerifyLoginOtpResponse? response =
        await Repository.hitVerifyLoginOtpApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          // Get.offAll(() => const ArtistProfileScreen());
        }
      }
    }
  }

  ///
  ///
  ///
  successFunction() {
    Get.offAll(() => const ArtistLoginScreen());
  }
}
