import 'package:get/get.dart';
import 'package:upculture/model/artist/request/artist_detail_request.dart';
import 'package:upculture/model/artist/request/artist_gallery_list_request.dart';
import 'package:upculture/model/artist/request/artist_video_list_request.dart';
import 'package:upculture/model/artist/request/culture_category_list_request.dart';
import 'package:upculture/model/artist/request/culture_sub_category_list_request.dart';
import 'package:upculture/model/artist/request/culture_sub_category_product_list_request.dart';
import 'package:upculture/model/artist/request/culture_sub_category_slider_request.dart';
import 'package:upculture/model/artist/request/folder_list_request.dart';
import 'package:upculture/model/artist/request/sub_category_detail_request.dart';
import 'package:upculture/model/artist/request/sub_category_gallery_request.dart';
import 'package:upculture/model/artist/request/sub_category_list_request.dart';
import 'package:upculture/model/artist/response/artist_detail_response.dart';
import 'package:upculture/model/artist/response/sub_category_list_response.dart'
    as subCategory;
import 'package:upculture/model/artist/response/sub_category_gallery_response.dart'
    as subCategoryGallery;
import 'package:upculture/model/artist/response/sub_category_detail_response.dart'
    as subCategoryDetail;

import 'package:upculture/model/artist/response/culture_category_list_response.dart'
    as cultureCategory;
import 'package:upculture/model/artist/response/culture_sub_category_list_response.dart'
    as cultureSubCategory;
import 'package:upculture/model/artist/response/culture_sub_category_slider_response.dart'
    as cultureSubCategorySlider;
import 'package:upculture/model/artist/response/culture_sub_category_product_list_response.dart'
    as cultureSubCategoryProduct;
import 'package:upculture/network/repository.dart';
import 'package:upculture/screen/artist/districtLink.dart';
import '../../model/artist/response/artist_list_response.dart' as artist;
import 'package:upculture/model/artist/response/artist_gallery_list_response.dart'
    as gallery;
import 'package:upculture/model/artist/response/artist_video_list_response.dart'
    as video;
import 'package:upculture/model/artist/response/folder_list_response.dart'
    as folder;

class CategoryController extends GetxController {
  var subCategoryList = <subCategory.Data>[].obs;
  var subCategoryGalleryList = <subCategoryGallery.Data>[].obs;
  var subCategoryData = subCategoryDetail.Data().obs;

  var cultureCategoryList = <cultureCategory.Data>[].obs;
  var cultureSubCategoryList = <cultureSubCategory.Data>[].obs;
  var cultureSubCategorySliderList = <cultureSubCategorySlider.Data>[].obs;
  var cultureSubCategoryProductList = <cultureSubCategoryProduct.Data>[].obs;

  var artistList = <artist.Data>[].obs;
  var artistDetail = Data().obs;
  var folderList = <folder.Data>[].obs;
  var galleryList = <gallery.Data>[].obs;
  var youtubeVideoList = <video.Data>[].obs;
  var cityUrl = ''.obs;

  ///
  ///
  ///
  void getSubCategoriesData({required categoryId}) async {
    subCategoryList.clear();

    SubCategoryListRequest request = SubCategoryListRequest(cId: categoryId);
    print(categoryId.toString());
    subCategory.SubCategoryListResponse? response =
        await Repository.hitSubCategoryListApi( request);
        print("janpad");
        print(response!.data);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            subCategoryList.value = response.data!;
          }
        }
      }
    }
  }




  ///
  ///
  ///
  getSubCategoryGallery({required subCategoryId}) async {
    subCategoryGalleryList.clear();

    SubCategoryGalleryRequest request =
        SubCategoryGalleryRequest(subId: subCategoryId);

    subCategoryGallery.SubCategoryGalleryResponse? response =
        await Repository.hitSubCategoryGalleryApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            subCategoryGalleryList.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getSubCategoryDetail({required subCategoryId}) async {
    SubCategoryDetailRequest request =
        SubCategoryDetailRequest(subId: subCategoryId);

    subCategoryDetail.SubCategoryDetailResponse? response =
        await Repository.hitSubCategoryDetailApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            subCategoryData.value = response.data![0];
          }
        }
      }
    }
  }



  ///
  ///
  /// step 2 of city-Category  i.e lucknow, kanpur,
  void getCultureCategoriesData({required cultureId}) async {
    cultureCategoryList.clear();

    CultureCategoryListRequest request =
        CultureCategoryListRequest(cultureId: cultureId);
    cultureCategory.CultureCategoryListResponse? response =
        await Repository.hitCultureCategoryListApi(request);
   

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            cultureCategoryList.value = response.data!;
            print("testing inside");
            
           
           }
        }
      }
    }
  }

  ///
  ///
  /// step 3 of city - sub category of Lucknow  i.e food, tradition & custom, famous places
  void getCultureSubCategoriesData({required cultureCategoryId}) async {
    cultureSubCategoryList.clear();

    CultureSubCategoryListRequest request =
        CultureSubCategoryListRequest(cultureCategoryId: cultureCategoryId);
    cultureSubCategory.CultureSubCategoryListResponse? response =
        await Repository.hitCultureSubCategoryListApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            cultureSubCategoryList.value = response.data!;
            cityUrl.value=response.cityUrl!;
            
         
          }
        }
      }
    }
  }

  ///
  ///
  /// step 4.2 of city - culture-sub-category-product-list -- Product list of subcategory Food i.e Biryani, chat, kabab,
  void getCultureSubCategoryProductList({required cultureSubCategoryId}) async {
    cultureSubCategoryProductList.clear();

    CultureSubCategoryProductListRequest request =
        CultureSubCategoryProductListRequest(
            subCategoryId: cultureSubCategoryId);

    cultureSubCategoryProduct.CultureSubCategoryProductListResponse? response =
        await Repository.hitCultureSubCategoryProductListApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            cultureSubCategoryProductList.value = response.data!;
          }
        }
      }
    }
  }

  void getCultureSubCategoryProductItemDetail(
      {required cultureSubCategoryId}) async {
    cultureSubCategoryProductList.clear();

    CultureSubCategoryProductItemListRequest request =
        CultureSubCategoryProductItemListRequest(
            subCategoryId: cultureSubCategoryId);

    cultureSubCategoryProduct.CultureSubCategoryProductListResponse? response =
        await Repository.hitCultureSubCategoryProductItemDetailsApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            cultureSubCategoryProductList.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  /// step 4.1 of City culture-sub-category-slider --- gallery of sub category i.e gallery of Food
  void getCultureSubCategorySlider({required cultureSubCategoryId}) async {
    cultureSubCategorySliderList.clear();
    CultureSubCategorySliderRequest request =
        CultureSubCategorySliderRequest(subCategoryId: cultureSubCategoryId);
    cultureSubCategorySlider.CultureSubCategorySliderResponse? response =
        await Repository.hitCultureSubCategorySliderApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            cultureSubCategorySliderList.value = response.data!;
          }
        }
      }
    }
    getCultureSubCategoryProductList(
        cultureSubCategoryId: cultureSubCategoryId);
  }

  void getCultureSubCategorySliderItemDetail(
      {required cultureSubCategoryId, required String sliderUrl}) async {
    cultureSubCategorySliderList.clear();
    if (sliderUrl.isNotEmpty) {
      CultureSubCategorySliderRequest request =
          CultureSubCategorySliderRequest(subCategoryId: cultureSubCategoryId);
      cultureSubCategorySlider.CultureSubCategorySliderResponse? response =
          await Repository.hitCultureProductItemSliderApi(request);

      if (response != null) {
        if (response.code == 200) {
          if (response.type == 'success') {
            if (response.data != null && response.data!.isNotEmpty) {
              cultureSubCategorySliderList.value = response.data!;
            }
          }
        }
      }
    }
    getCultureSubCategoryProductItemDetail(
        cultureSubCategoryId: cultureSubCategoryId);
  }

  ///
  ///
  /// step 4 of CultureSubCategoryDetailScreen
/*
  void getCultureSubCategoryDetail({required cultureSubCategoryId}) async {

    CultureSubCategoryDetailRequest request = CultureSubCategoryDetailRequest(
        cultureSubCategoryId: cultureSubCategoryId
    );
    subCategoryDetail
        .CultureSubCategoryDetailResponse? response = await Repository
        .hitCultureSubCategoryDetailApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            cultureSubCategoryDetail.value = response.data!;
          }
        }
      }
    }
  }
*/

  ///
  ///
  ///
  void getArtistList() async {
    artistList.clear();
    artist.ArtistListResponse? response = await Repository.hitArtistListApi();

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            artistList.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  Future<void> getArtistDetail({required artistId}) async {
    ArtistDetailRequest request = ArtistDetailRequest(artistId: artistId);
    ArtistDetailResponse? response =
        await Repository.hitArtistDetailApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null) {
            artistDetail.value = response.data!;
          }
        }
      }
    }
  }

  ///
  ///
  ///
  getVideoList({required artistId}) async {
    ArtistVideoListRequest request = ArtistVideoListRequest(uId: artistId);

    video.ArtistVideoListResponse? response =
        await Repository.hitArtistVideoListApi(request);

    if (response != null) {
      if (response.code == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          youtubeVideoList.value = response.data!;
        }
      }
    }
  }

  ///
  ///
  ///
  void getImageList({required folderId, required artistId}) async {
    ArtistGalleryListRequest request =
        ArtistGalleryListRequest(uId: artistId, fId: folderId);
    gallery.ArtistGalleryListResponse? response =
        await Repository.hitArtistGalleryListApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          galleryList.value = response.data!;
        }
      }
    }
  }

  ///
  ///
  ///
  getFolderList({required artistId}) async {
    FolderListRequest request = FolderListRequest(uId: artistId);

    folder.FolderListResponse? response =
        await Repository.hitFolderListApi(request);
    if (response != null) {
      if (response.code == 200) {
        if (response.data != null && response.data!.isNotEmpty) {
          folderList.value = response.data!;
        }
      }
    }
  }
}
