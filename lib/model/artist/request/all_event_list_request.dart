class AllEventListRequest {
  String? event;

  AllEventListRequest({this.event});

  AllEventListRequest.fromJson(Map<String, dynamic> json) {
    event = json['event'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    return data;
  }
}
