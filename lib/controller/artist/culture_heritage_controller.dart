import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:translator/translator.dart';
import 'package:upculture/model/artist/request/heritage_detail_request.dart';
import 'package:upculture/model/artist/request/heritage_gallery_request.dart';

import 'package:upculture/model/artist/response/heritage_gallery_response.dart'
    as gallery;
import 'package:upculture/model/artist/response/heritage_detail_response.dart';
import 'package:upculture/network/repository.dart';

class CultureHeritageController extends GetxController {
  var heritageDetail = Data().obs;
  var heritageGallery = <gallery.Data>[].obs;

  ///
  ///
  ///
  void getHeritageDetail({required heritageId}) async {
    HeritageDetailRequest request =
        HeritageDetailRequest(cultureHeritageId: heritageId);
    HeritageDetailResponse? response =
        await Repository.hitHeritageDetailApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            ///
            final document = parse(response.data![0].name);
            final plainText = document.body?.text ?? '';
            final translator = GoogleTranslator();

            // Translate the name field
            final translation = await translator.translate(
              plainText,
              to: 'en',
            );

            final translatedName = translation.text; // Translated text
            print('Translated Name: $translatedName');

            ///
            heritageDetail.value = response.data![0];
          }
        }
      }
    }
  }

  ///
  ///
  ///
  void getGalleryDetail({required heritageId}) async {
    heritageGallery.clear();
    HeritageGalleryRequest request =
        HeritageGalleryRequest(cultureHeritageId: heritageId);
    gallery.HeritageGalleryResponse? response =
        await Repository.hitHeritageGalleryApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            heritageGallery.value = response.data!;
          }
        }
      }
    }
    getHeritageDetail(heritageId: heritageId);
  }
}
