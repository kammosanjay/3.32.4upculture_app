class GetEventResponse {
  bool? status;
  int? code;
  String? type;
  String? message;
  List<EventData>? data;

  GetEventResponse(
      {this.status, this.code, this.type, this.message, this.data});

  GetEventResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventData>[];
      json['data'].forEach((v) {
        data!.add(EventData.fromJson(v));
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

class EventData {
  int? id;
  String? eventName;
  String? eventDate;
  String? eventStartTime;
  String? eventEndTime;

  EventData(
      {this.id,
        this.eventName,
        this.eventDate,
        this.eventStartTime,
        this.eventEndTime});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDate = json['event_date'];
    eventStartTime = json['event_start_time'];
    eventEndTime = json['event_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event_name'] = eventName;
    data['event_date'] = eventDate;
    data['event_start_time'] = eventStartTime;
    data['event_end_time'] = eventEndTime;
    return data;
  }
}