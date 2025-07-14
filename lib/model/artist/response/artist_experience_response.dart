class ArtistExperienceResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  ArtistExperienceResponse(
      {this.status, this.code, this.type, this.message, this.data});

  ArtistExperienceResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  String? exprience;

  Data({this.id, this.exprience});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    exprience = json['exprience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['exprience'] = exprience;
    return data;
  }

  ///
  ///
  String experienceAsString(){
    return '$exprience';
  }
}
