class LatestEventModalRequest {
  int? programId;

  LatestEventModalRequest({this.programId});

  LatestEventModalRequest.fromJson(Map<String, dynamic> json) {
    programId = json['programme_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['programme_id'] = programId;
    return data;
  }
}
