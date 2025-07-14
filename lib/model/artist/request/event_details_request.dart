class EventDetailsRequest {
  int? eventId;

  EventDetailsRequest({this.eventId});

  EventDetailsRequest.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_id'] = eventId;
    return data;
  }
}
