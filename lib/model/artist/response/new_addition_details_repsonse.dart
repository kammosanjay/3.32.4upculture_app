class NewAdditionDetailsResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  AdditionDetails? data;

  NewAdditionDetailsResponse(
      {this.status, this.code, this.type, this.message, this.data});

  NewAdditionDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? AdditionDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AdditionDetails {
  String? name;
  String? description;
  String? image;
  String? place;
  String? programType;
  String? programDate;

  AdditionDetails(
      {this.name,
        this.description,
        this.image,
        this.place,
        this.programType,
        this.programDate});

  AdditionDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    image = json['image'];
    place = json['place'];
    programType = json['program_type'];
    programDate = json['program_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['place'] = place;
    data['program_type'] = programType;
    data['program_date'] = programDate;
    return data;
  }
}