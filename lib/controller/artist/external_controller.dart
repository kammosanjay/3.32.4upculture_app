import 'package:get/get.dart';
import 'package:upculture/model/artist/request/external_detail_request.dart';
import 'package:upculture/model/artist/response/external_detail_response.dart';
import 'package:upculture/network/repository.dart';

class ExternalController extends GetxController {
  var detail = Data().obs;
  var isLoading = false.obs;

  ///
  ///
  ///
  void getExternalDetails({required externalId}) async {
    isLoading.value = true;
    ExternalDetailRequest request =
        ExternalDetailRequest(externalId: externalId);
    ExternalDetailResponse? response =
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
    isLoading.value = false;
  }
}
