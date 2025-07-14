class searchResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<SearchData>? data;

  searchResponse({this.status, this.code, this.type, this.message, this.data});

  searchResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchData {
  int? id;
  String? name;
  String? type;
  String? method;
  String? url;
  String? slider_url;
  Map<dynamic, dynamic>? parameter;
  SearchData(
      {this.id,
      this.name,
      this.type,
      this.method,
      this.url,
      this.slider_url,
      this.parameter});

  SearchData.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    method = json["method"];
    url = json["url"];
    slider_url = json["slider_url"];
    parameter = json["parameter"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["type"] = type;
    data["method"] = method;
    data["url"] = url;
    data["slider_url"] = slider_url;
    data["parameter"] = parameter;
    return data;
  }
}
