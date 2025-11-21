class ForecastModel {
  final double temperature; // nhiệt độ duy nhất (do dùng API /forecast)
  final String iconCode;
  final DateTime date;

  // constructor cho dữ liệu dự báo
  ForecastModel({
    required this.temperature,
    required this.iconCode,
    required this.date,
  });

  // factory constructor để ánh xạ từ JSON của API /forecast (phần 'list')
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    // chuyển đổi timestamp (giây) thành đối tượng DateTime
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      json['dt'] * 1000,
    );

    // lấy nhiệt độ chính (temp) từ main (là Celsius nhờ units=metric)
    final double temp = json['main']['temp'].toDouble();

    return ForecastModel(
      temperature: double.parse(temp.toStringAsFixed(1)),
      iconCode: json['weather'][0]['icon'],
      date: dateTime,
    );
  }
}
