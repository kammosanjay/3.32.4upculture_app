class UploadArtistGalleryResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<Data>? data;

  UploadArtistGalleryResponse(
      {this.status, this.code, this.type, this.message, this.data});

  UploadArtistGalleryResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}

class Data{

}
