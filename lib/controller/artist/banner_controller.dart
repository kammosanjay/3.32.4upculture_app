import 'package:get/get.dart';
import 'package:upculture/model/artist/request/banner_detail_request.dart';
import 'package:upculture/network/repository.dart';

import '../../model/artist/response/banner_detail_response.dart';
import '../../model/artist/response/banner_gallery_response.dart' as gallery;

class BannerController extends GetMaterialApp{


  var bannerDetail = Data().obs;
  var bannerGallery = <gallery.Data>[].obs;

  BannerController({super.key});



  ///
  ///
  ///
  void getBannerDetail({required bannerId}) async{

    BannerDetailRequest request = BannerDetailRequest(
        bannerId: bannerId
    );
    BannerDetailResponse? response = await Repository.hitBannerDetailApi(request);

    if(response != null){
      if(response.code == 200){
        if(response.type == 'success'){
          if(response.data != null && response.data!.isNotEmpty){
            bannerDetail.value = response.data![0];
          }
        }
      }
    }
  }


  ///
  ///
  ///
  void getGalleryDetail({required bannerId}) async{
    bannerGallery.clear();
    BannerDetailRequest request = BannerDetailRequest(
        bannerId: bannerId
    );
    gallery.BannerGalleryResponse? response = await Repository.hitBannerGalleryApi(request);

    if(response != null){
      if(response.code == 200){
        if(response.type == 'success'){
          if(response.data != null && response.data!.isNotEmpty){
            bannerGallery.value = response.data!;
          }
        }
      }
    }
    getBannerDetail(bannerId: bannerId);
  }




}