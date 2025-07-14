class ExternalDetailRequest {
  int? externalId;

  ExternalDetailRequest({this.externalId});

  ExternalDetailRequest.fromJson(Map<String, dynamic> json) {
    externalId = json['external_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['external_id'] = externalId;
    return data;
  }
}
