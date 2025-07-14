class ArtistRegistrationStep1DrowResponseNew {
  bool? status;
  int? code;
  String? type;
  String? message;
  Data? data;

  ArtistRegistrationStep1DrowResponseNew({this.status, this.code, this.type, this.message, this.data});

  ArtistRegistrationStep1DrowResponseNew.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? Data?.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['type'] = type;
    data['message'] = message;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class ArtistExperience {
  String? exprience;

  ArtistExperience({this.exprience});

  ArtistExperience.fromJson(Map<String, dynamic> json) {
    exprience = json['exprience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exprience'] = exprience;
    return data;
  }
}

class Data {
  DateOfBirth? dateofbirth;
  List<Gender?>? genders;
  List<ArtistExperience?>? artistExperience;

  Data({this.dateofbirth, this.genders, this.artistExperience});

  Data.fromJson(Map<String, dynamic> json) {
    dateofbirth = json['date_of_birth'] != null ? DateOfBirth?.fromJson(json['date_of_birth']) : null;
    if (json['genders'] != null) {
      genders = <Gender>[];
      json['genders'].forEach((v) {
        genders!.add(Gender.fromJson(v));
      });
    }
    if (json['artistExperience'] != null) {
      artistExperience = <ArtistExperience>[];
      json['artistExperience'].forEach((v) {
        artistExperience!.add(ArtistExperience.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_of_birth'] = dateofbirth!.toJson();
    data['genders'] =genders?.map((v) => v?.toJson()).toList();
    data['artistExperience'] =artistExperience?.map((v) => v?.toJson()).toList();
    return data;
  }
}

class DateOfBirth {
  List<Year?>? years;
  List<Month?>? months;
  List<Day?>? days;

  DateOfBirth({this.years, this.months, this.days});

  DateOfBirth.fromJson(Map<String, dynamic> json) {
    if (json['years'] != null) {
      years = <Year>[];
      json['years'].forEach((v) {
        years!.add(Year.fromJson(v));
      });
    }
    if (json['months'] != null) {
      months = <Month>[];
      json['months'].forEach((v) {
        months!.add(Month.fromJson(v));
      });
    }
    if (json['days'] != null) {
      days = <Day>[];
      json['days'].forEach((v) {
        days!.add(Day.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['years'] =years?.map((v) => v?.toJson()).toList();
    data['months'] =months?.map((v) => v?.toJson()).toList();
    data['days'] =days?.map((v) => v?.toJson()).toList();
    return data;
  }
}

class Day {
  int? day;

  Day({this.day});

  Day.fromJson(Map<String, dynamic> json) {
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    return data;
  }
}

class Gender {
  String? name;

  Gender({this.name});

  Gender.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class Month {
  String? month;

  Month({this.month});

  Month.fromJson(Map<String, dynamic> json) {
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    return data;
  }
}

class Year {
  int? year;

  Year({this.year});

  Year.fromJson(Map<String, dynamic> json) {
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    return data;
  }
}

