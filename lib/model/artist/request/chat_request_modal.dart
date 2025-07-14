import 'dart:io';

class ProgramEnquiryRequest {
  final String? userId; // Nullable to allow for optional fields
  final String? programName;
  final String? programDate;
  final String? mobileNumber;
  final String? artistName;
  final String? queryDetail;
  final String? message;

  ProgramEnquiryRequest({
    this.userId,
    this.programName,
    this.programDate,
    this.mobileNumber,
    this.artistName,
    this.queryDetail,
    this.message,
  });

  // Convert to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'program_name': programName,
      'program_date': programDate,
      'mobile_number': mobileNumber,
      'artist_name': artistName,
      'query_detail': queryDetail,
      'message': message,
    };
  }

  // Optional: from JSON if you're parsing response too
  factory ProgramEnquiryRequest.fromJson(Map<String, dynamic> json) {
    return ProgramEnquiryRequest(
      userId: json['user_id'],
      programName: json['program_name'],
      programDate: json['program_date'],
      mobileNumber: json['mobile_number'],
      artistName: json['artist_name'],
      queryDetail: json['query_detail'],
      message: json['message'],
    );
  }
}
