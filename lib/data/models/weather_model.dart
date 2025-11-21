class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final String iconCode; // icon để hiển thị hình ảnh
  final double windSpeed; // tốc độ gió cho chi tiết UI

  // Constructor cho WeatherModel
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.iconCode,
    required this.windSpeed,
  });

  // factory constructor để phân tích JSON từ API
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      // lấy tên thành phố
      cityName: json["name"],
      // lấy nhiệt độ, ép kiểu an toàn từ num (int hoặc double) sang double
      temperature: (json["main"]["temp"] as num).toDouble(),
      // lấy mô tả tình trạng thời tiết (từ mảng weather[0])
      description: json["weather"][0]["description"],
      // lấy độ ẩm
      humidity: json["main"]["humidity"] as int,
      // lấy mã icon (ví dụ: '01d', '10n')
      iconCode: json["weather"][0]["icon"],
      // lấy tốc độ gió
      windSpeed: (json["wind"]["speed"] as num).toDouble(),
    );
  }
}
