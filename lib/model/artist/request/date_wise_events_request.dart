class DateWiseEventsRequest {
  String? date;

  DateWiseEventsRequest({this.date});

  DateWiseEventsRequest.fromJson(Map<String, dynamic> json) {
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    return data;
  }
}
