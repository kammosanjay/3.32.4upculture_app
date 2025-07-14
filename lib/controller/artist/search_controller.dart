import 'package:get/get.dart';
import 'package:upculture/model/artist/response/search_data_response.dart';
import 'package:upculture/network/repository.dart';

class SearchController1 extends GetxController {
  var datas = <SearchData>[].obs;
  var search = ''.obs;
  void searchData() async {
    print("this runs");
    datas.clear();
    searchResponse? response = await Repository.searchDataApi(search.value);

    if (response != null) {
      if (response.code == 200) {
        if (response.type == 'success') {
          if (response.data != null && response.data!.isNotEmpty) {
            if (search.isEmpty) {
              datas.value = [];
            } else {
              datas.value = response.data!;
            }
          } else {
            datas.value = [];
          }
        } else {
          datas.value = [];
        }
      } else {
        datas.value = [];
      }
    } else {
      datas.value = [];
    }
  }
}
