// lib/data/repository/weather_repo.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// Imports Models
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';

// Import Constants
import 'package:weather_app/config/constants.dart';

class WeatherRepository {
  // hàm lấy thời tiết hiện tại theo tên thành phố
  Future<WeatherModel> fetchWeatherByCity(String city) async {
    final url =
        '$kWeatherApiBaseUrl/weather?q=$city&appid=$kOpenWeatherApiKey&units=metric&lang=vi';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố: $city');
      } else {
        throw Exception(
          'Lỗi API: Không lấy được dữ liệu thời tiết. Mã: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối mạng hoặc xử lý dữ liệu: ${e.toString()}');
    }
  }

  // hàm lấy thời tiết hiện tại theo Tọa độ (Lat/Lon)
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    final url =
        '$kWeatherApiBaseUrl/weather?lat=$lat&lon=$lon&appid=$kOpenWeatherApiKey&units=metric&lang=vi';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return WeatherModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Lỗi API: Không lấy được thời tiết theo vị trí hiện tại. Mã: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối mạng hoặc xử lý dữ liệu: ${e.toString()}');
    }
  }

  // HÀM SỬ DỤNG GÓI MIỄN PHÍ LẤY TỪ OPENWEATHER - Dự báo 5 ngày / 3 giờ (Endpoint: /forecast)
  // logic lọc dữ liệu chỉ lấy 1 điểm/ngày sẽ nằm trong Notifier
  Future<List<ForecastModel>> fetchFiveDayForecast(String city) async {
    final uri = Uri.parse(
      '$kWeatherApiBaseUrl/forecast?q=$city&appid=$kOpenWeatherApiKey&units=metric',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List forecastList = json['list'];

        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        // chỉ throw exception nếu đây là hàm fetch chính (nhưng ở đây không phải)
        throw Exception(
          'Lỗi khi tải dự báo 5 ngày. Mã: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi tải dự báo: ${e.toString()}');
    }
  }
}
