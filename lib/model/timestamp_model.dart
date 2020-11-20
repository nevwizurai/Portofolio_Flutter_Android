class TimeStampModel {
  String deviceId;
  String date;
  String checkIn;
  String checkOut;

  TimeStampModel({this.deviceId, this.date, this.checkIn, this.checkOut});

  factory TimeStampModel.fromJson(Map<String, dynamic> json){
    return TimeStampModel(
      deviceId: json['device_id'] as String,
      date: json['date'] as String,
      checkIn: json['check_in'] as String,
      checkOut: json['check_out'] as String,
    );
  }
}