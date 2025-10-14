import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:upculture/dialog/check_internt_dialog.dart';
import 'package:upculture/dialog/custom_progress_dialog.dart';
import 'package:upculture/dialog/error_dialog.dart';
import 'package:upculture/model/artist/request/artist_edit_profile_request.dart';
import 'package:upculture/model/artist/request/artist_registration_request.dart';
import 'package:upculture/model/artist/request/upload_artist_gallery_request.dart';
import 'package:upculture/network/my_internet_connection.dart';
import 'package:upculture/resources/my_string.dart';

class ApiClient {
  ///*
  ///
  ///
  Future<Map?> getEventRequestWithData({
    required String url,
    required requestModel,
  }) async {
    Get.dialog(const ProgressDialogWidget(), barrierColor: Colors.transparent);
    log("API : $url$requestModel");
    // log("RequestBody : ${json.encode(requestModel)}");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        // final data = requestModel;
        var request = http.MultipartRequest(
          'GET',
          Uri.parse("$url$requestModel"),
        );
        // request = jsonToFormData(request, data);
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }

  // Future<Map?> getEventRequestWithDataSearch({required String url}) async {
  //   //Get.dialog(ProgressDialogWidget(), barrierColor: Colors.transparent);
  //   log("API : $url");
  //   // log("RequestBody : ${json.encode(requestModel)}");
  //   bool flagNet = await MyInternetConnection.isInternetAvailable();
  //   if (flagNet) {
  //     try {
  //       // final data = requestModel;
  //       var request = http.MultipartRequest('GET', Uri.parse(url));

  //       http.StreamedResponse response = await request.send();

  //       if (response.statusCode == 200) {
  //         //  Get.back(); //close progressDialog
  //         var responseString = await response.stream.bytesToString();
  //         final decodedMap = json.decode(responseString);
  //         log("Response JSON :$decodedMap");
  //         return decodedMap;
  //       } else {
  //         // Get.back(); //close progressDialog
  //         log("Request API : null");
  //         throw '';
  //       }
  //     } catch (exception) {
  //       log("Request API Exception:  ${exception.toString()}");
  //       // Get.back(); //close progressDialog
  //       throw '';
  //     }
  //   } else {
  //     //  Get.back(); //close progressDialog
  //     log("Request API : No Net ");
  //     throw '';
  //   }
  // }

  Future<Map?> getEventRequestWithDataSearch({
    required String baseUrl,
    Map<String, String>? queryParams,
  }) async {
    try {
      bool isConnected = await MyInternetConnection.isInternetAvailable();

      if (!isConnected) {
        log("❌ No Internet");
        Get.dialog(const CheckInternetDialog());
        throw Exception('No Internet Connection');
      }

      // Build URL with query parameters
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      log("🔍 API GET: $uri");

      final response = await http.get(
        uri,
        headers: {
          "Content-Type":
              "application/json", // Change if your API needs different headers
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        log("✅ Response JSON: $decoded");
        return decoded;
      } else {
        log("❌ Error [${response.statusCode}]: ${response.body}");
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw Exception("API responded with status ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Exception: $e");
      Get.dialog(ErrorDialog(msg: MyString.errorMsg));
      throw Exception("API Exception: $e");
    }
  }

  Future<Map?> postRequestFormData({
    required String url,
    required Map<String, dynamic> requestModel,
  }) async {
    // Show Progress Dialog
    Get.dialog(
      const ProgressDialogWidget(),
      barrierColor: Colors.transparent,
      barrierDismissible: false,
    );

    log("API URL: $url");
    log("Request Body: ${json.encode(requestModel)}");

    try {
      // Check Internet Connection
      bool isConnected = await MyInternetConnection.isInternetAvailable();
      if (!isConnected) {
        if (Get.isDialogOpen ?? false) Get.back(); // Close ProgressDialog
        log("No Internet Connection");
        Get.dialog(const CheckInternetDialog());
        return null;
      }

      // Prepare Headers
      var headers = {"Content-Type": "multipart/form-data"};

      // Create Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request = jsonToFormData(request, requestModel);
      request.headers.addAll(headers);

      // Send the Request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        log("Request Successful - Status Code: ${response.statusCode}");
        var responseString = await response.stream.bytesToString();
        log("Response String: $responseString");

        final decodedMap = json.decode(responseString);
        log("Decoded Response: $decodedMap");
        return decodedMap;
      } else {
        log("Request Failed - Status Code: ${response.statusCode}");
        log("Response Body: ${await response.stream.bytesToString()}");
        if (Get.isDialogOpen ?? false) Get.back(); // Close ProgressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        return null;
      }
    } catch (e) {
      log("Request Exception: $e");
      if (Get.isDialogOpen ?? false) Get.back(); // Close ProgressDialog
      Get.dialog(ErrorDialog(msg: MyString.errorMsg));
      return null;
    } finally {
      // Ensure ProgressDialog is dismissed
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close ProgressDialog
      }
    }
  }

  ///////////////////////new register api//////////////////////////////////////
  Future<Map?> postRequestRegisteFormData({
    required String url,
    required Map<String, dynamic> requestModel,
  }) async {
    Get.dialog(const ProgressDialogWidget(), barrierColor: Colors.transparent);
    log("API : $url");
    log("RequestBody : ${json.encode(requestModel)}");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        final data = requestModel;
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request = jsonToFormData(request, data);
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }

  ///*
  ///
  ///
  Future<Map?> postRequestNoLoaderFormData({
    required String url,
    required Map<String, dynamic> requestModel,
  }) async {
    // Get.dialog(const ProgressDialogWidget());
    log("API : $url");
    log("RequestBody : ${json.encode(requestModel)}");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        final data = requestModel;
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request = jsonToFormData(request, data);
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          // Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          // Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        // Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      // Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }

  ///*
  ///
  ///
  // Future<Map?> getRequestFormData({required String url}) async {
  //   // Get.dialog(const ProgressDialogWidget());
  //   log("API : $url");
  //   bool flagNet = await MyInternetConnection.isInternetAvailable();
  //   if (flagNet) {
  //     try {
  //       var headers = {"Content-Type": "multipart/form-data"};

  //       var request = http.MultipartRequest('GET', Uri.parse(url));
  //       request.headers.addAll(headers);

  //       http.StreamedResponse response = await request.send();

  //       if (response.statusCode == 200) {
  //         // Get.back(); //close progressDialog
  //         var responseString = await response.stream.bytesToString();
  //         final decodedMap = json.decode(responseString);
  //         log("Response JSON :$decodedMap");
  //         return decodedMap;
  //       } else {
  //         // Get.back(); //close progressDialog
  //         log("Request API : null");
  //         Get.dialog(ErrorDialog(msg: MyString.errorMsg));
  //         throw '';
  //       }
  //     } catch (exception) {
  //       log("Request API Exception:  ${exception.toString()}");
  //       // Get.back(); //close progressDialog
  //       Get.dialog(ErrorDialog(msg: MyString.errorMsg));
  //       throw '';
  //     }
  //   } else {
  //     // Get.back(); //close progressDialog
  //     log("Request API : No Net ");
  //     Get.dialog(const CheckInternetDialog());
  //     throw '';
  //   }
  // }

  Future<Map?> getRequestFormData({required String url}) async {
    log("🌐 API URL: $url");

    bool isConnected = await MyInternetConnection.isInternetAvailable();

    if (!isConnected) {
      log("❌ No Internet");
      Get.dialog(const CheckInternetDialog());
      throw Exception('No Internet Connection');
    }

    try {
      var headers = {
        "Content-Type":
            "application/json", // Use this unless your API says otherwise
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        log("✅ Response JSON: $decoded");
        return decoded;
      } else {
        log("❌ API Error [${response.statusCode}]: ${response.body}");
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw Exception('API responded with status ${response.statusCode}');
      }
    } catch (e) {
      log("❌ Exception: $e");
      Get.dialog(ErrorDialog(msg: MyString.errorMsg));
      throw Exception("API Exception: $e");
    }
  }

  ///*
  ///
  ///
  Future<Map?> postRequestFormDataNoRequest({required String url}) async {
    // Get.dialog(const ProgressDialogWidget());
    log("API : $url");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          // Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          // Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        // Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      // Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }

  ///*
  ///
  ///
  // Future<Map?> getRequestFormDataWithLoader({required String url}) async {
  //   Get.dialog(const ProgressDialogWidget(), barrierColor: Colors.transparent);
  //   log("API : $url");
  //   bool flagNet = await MyInternetConnection.isInternetAvailable();
  //   print("internet==> $flagNet");
  //   if (flagNet) {
  //     try {
  //       var headers = {
  //         "Content-Type": "multipart/form-data",
  //       };

  //       var request = http.MultipartRequest('GET', Uri.parse(url));
  //       request.headers.addAll(headers);

  //       http.StreamedResponse response = await request.send();

  //       if (response.statusCode == 200) {
  //         Get.back(); //close progressDialog
  //         var responseString = await response.stream.bytesToString();
  //         final decodedMap = json.decode(responseString);
  //         log("Response JSON :$decodedMap");
  //         return decodedMap;
  //       } else {
  //         Get.back(); //close progressDialog
  //         log("Request API : null");
  //         Get.dialog(ErrorDialog(msg: MyString.errorMsg));
  //         throw '';
  //       }
  //     }
  //      catch (exception) {
  //       log("Request API Exception:  ${exception.toString()}");
  //       Get.back(); //close progressDialog
  //       Get.dialog(ErrorDialog(msg: MyString.errorMsg));
  //       throw '';
  //     }
  //   } else {
  //     Get.back(); //close progressDialog
  //     log("Request API : No Net ");
  //     Get.dialog(const CheckInternetDialog());
  //     throw '';
  //   }
  // }
  // Future<Map?> getRequestFormDataWithLoader({required String url}) async {
  //   if (Get.isDialogOpen != true) {
  //     Get.dialog(
  //       const ProgressDialogWidget(),
  //       barrierColor: Colors.transparent,
  //     );
  //   }

  //   log("API : $url");
  //   bool flagNet = await MyInternetConnection.isInternetAvailable();
  //   print("internet==> $flagNet");

  //   if (flagNet) {
  //     try {
  //       var headers = {"Content-Type": "multipart/form-data"};
  //       var request = http.MultipartRequest('GET', Uri.parse(url));
  //       request.headers.addAll(headers);

  //       http.StreamedResponse response = await request.send();

  //       if (response.statusCode == 200) {
  //         var responseString = await response.stream.bytesToString();
  //         final decodedMap = json.decode(responseString);
  //         log("Response JSON :$decodedMap");

  //         if (Get.isDialogOpen == true) Get.back();
  //         return decodedMap;
  //       } else {
  //         if (Get.isDialogOpen == true) Get.back();
  //         Get.dialog(ErrorDialog(msg: MyString.errorMsg));
  //         throw Exception('API responded with status ${response.statusCode}');
  //       }
  //     } catch (exception) {
  //       if (Get.isDialogOpen == true) Get.back();
  //       log("Request API Exception: ${exception.toString()}");
  //       Get.dialog(ErrorDialog(msg: MyString.errorMsg));
  //       throw Exception("API exception: ${exception.toString()}");
  //     }
  //   } else {
  //     if (Get.isDialogOpen == true) Get.back();
  //     log("Request API : No Net ");
  //     Get.dialog(const CheckInternetDialog());
  //     throw Exception('No Internet Connection');
  //   }
  // }
  Future<Map?> getRequestFormDataWithLoader({required String url}) async {
    // Show loading dialog
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        const ProgressDialogWidget(),
        barrierColor: Colors.transparent,
      );
    }

    log("🌐 API URL: $url");

    bool flagNet = await MyInternetConnection.isInternetAvailable();
    print("📶 Internet: $flagNet");

    if (!flagNet) {
      if (Get.isDialogOpen == true) Get.back();
      log("❌ No Internet");
      Get.dialog(const CheckInternetDialog());
      throw Exception('No Internet Connection');
    }

    try {
      // Optional: Add Authorization or other headers here
      var headers = {
        "Content-Type": "application/json", // or as required
        // "Authorization": "Bearer YOUR_TOKEN", // if needed
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (Get.isDialogOpen == true) Get.back();

      if (response.statusCode == 200) {
        final decodedMap = json.decode(response.body);
        log("✅ Response JSON: $decodedMap");
        return decodedMap;
      } else {
        log("❌ API Error Status: ${response.statusCode}");
        log("❌ Response Body: ${response.body}");
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw Exception('API responded with status ${response.statusCode}');
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      log("❌ Exception: ${e.toString()}");
      Get.dialog(ErrorDialog(msg: MyString.errorMsg));
      throw Exception("API exception: ${e.toString()}");
    }
  }

  ///*
  ///
  ///
  Future<Map?> requestFormDataEditProfile({
    required String url,
    required ArtistEditProfileRequest requestModel,
    required File? compressFile,
  }) async {
    Get.dialog(const ProgressDialogWidget());
    log("API : $url");
    log("RequestBody : ${json.encode(requestModel)}");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        final data = requestModel.toJson();
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request = jsonToFormData(request, data);

        if (compressFile != null) {
          request.files.add(
            await http.MultipartFile.fromPath('photo', requestModel.photo!),
          );
        }
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }

  ///*
  ///
  ///
  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  ///*
  ///
  ///
  Future<Map?> requestUploadGallery({
    required String url,
    required UploadArtistGalleryRequest requestModel,
  }) async {
    Get.dialog(const ProgressDialogWidget());
    log("API : $url");
    log("RequestBody : ${json.encode(requestModel)}");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        final data = requestModel.toJson();
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request = jsonToFormData(request, data);
        request.files.add(
          await http.MultipartFile.fromPath('photo[]', requestModel.photo!),
        );
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }

  ///*
  ///
  ///
  Future<Map?> requestUploadMultipleGallery({
    required String url,
    required UploadArtistGalleryRequest requestModel,
    required List<XFile> multipleGallery,
  }) async {
    Get.dialog(const ProgressDialogWidget());
    log("API : $url");
    log("RequestBody : ${json.encode(requestModel)}");
    bool flagNet = await MyInternetConnection.isInternetAvailable();
    if (flagNet) {
      try {
        var headers = {"Content-Type": "multipart/form-data"};

        final data = requestModel.toJson();
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request = jsonToFormData(request, data);

        for (int index = 0; index < multipleGallery.length; index++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photo[]',
              multipleGallery[index].path,
            ),
          );
        }
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Get.back(); //close progressDialog
          var responseString = await response.stream.bytesToString();
          final decodedMap = json.decode(responseString);
          log("Response JSON :$decodedMap");
          return decodedMap;
        } else {
          Get.back(); //close progressDialog
          log("Request API : null");
          Get.dialog(ErrorDialog(msg: MyString.errorMsg));
          throw '';
        }
      } catch (exception) {
        log("Request API Exception:  ${exception.toString()}");
        Get.back(); //close progressDialog
        Get.dialog(ErrorDialog(msg: MyString.errorMsg));
        throw '';
      }
    } else {
      Get.back(); //close progressDialog
      log("Request API : No Net ");
      Get.dialog(const CheckInternetDialog());
      throw '';
    }
  }
}
