// lib/presentation/state_mgt/weather_notifier.dart

import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/data/models/historical_model.dart';
import 'package:weather_app/data/repository/weather_repo.dart';

// enum định nghĩa các trạng thái chính của ứng dụng
enum WeatherState { initial, loading, loaded, error }

class WeatherNotifier extends ChangeNotifier {
  final WeatherRepository _repository; // dependency injection

  // biến trạng thái
  WeatherState _state = WeatherState.initial;
  WeatherModel? _currentWeather;
  List<ForecastModel> _forecasts = []; // dữ liệu dự báo 5 ngày
  HistoricalModel? _historicalData; // dữ liệu lịch sử (đã mô phỏng)
  String _errorMessage = '';

  // constructor
  WeatherNotifier(this._repository);

  // getters công khai để UI có thể lắng nghe
  WeatherState get state => _state;
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecasts => _forecasts;
  HistoricalModel? get historicalData => _historicalData;
  String get errorMessage => _errorMessage;

  // hàm mô phỏng dữ liệu lịch sử cho tính năng AI (Vì API gốc bị lỗi 401)
  HistoricalModel _getMockHistoricalData() {
    // tạo dữ liệu 30 ngày trước với nhiệt độ ngẫu nhiên
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final randomTemp = 20.0 + Random().nextInt(5);

    return HistoricalModel(
      averageTemp: double.parse(randomTemp.toStringAsFixed(1)),
      date: thirtyDaysAgo,
    );
  }

  // logic lấy dữ liệu Dự báo (Tách biệt) ===
  Future<void> _fetchForecasts(String city) async {
    try {
      final rawForecasts = await _repository.fetchFiveDayForecast(city);

      // lọc dữ liệu thô (3 giờ/lần) để chỉ lấy 1 điểm dự báo mỗi ngày
      // lấy 5 điểm dữ liệu đầu tiên (thường là 5 ngày tiếp theo)
      _forecasts = rawForecasts.take(5).toList();
    } catch (e) {
      // k ném lỗi ra ngoài. Chỉ ghi lại lỗi và để forecasts rỗng
      _forecasts = [];
      debugPrint('Lỗi tải dự báo: ${e.toString()}');
      // có thể lưu lỗi vào biến phụ nếu muốn hiển thị lỗi cục bộ trên Widget dự báo
    }
  }

  // logic lấy dữ liệu Hiện tại (Chính) ===
  Future<WeatherModel> _fetchCurrentWeather(String city) async {
    try {
      return await _repository.fetchWeatherByCity(city);
    } catch (e) {
      throw Exception(
        e.toString(),
      ); // ném lỗi để toàn bộ ứng dụng hiển thị lỗi nếu dữ liệu chính thất bại
    }
  }

  // hàm chính: Lấy TẤT CẢ dữ liệu
  Future<void> fetchWeatherData(String city, {double? lat, double? lon}) async {
    _state = WeatherState.loading;
    notifyListeners(); // bắt đầu Loading

    try {
      // 1. Lấy dữ liệu hiện tại
      _currentWeather = await _fetchCurrentWeather(city);

      // 2. Lấy dữ liệu Dự báo
      await _fetchForecasts(city);

      // 3. Lấy/Mô phỏng dữ liệu lịch sử
      _historicalData = _getMockHistoricalData();

      _state = WeatherState.loaded;
    } catch (e) {
      // Xử lý lỗi chỉ khi dữ liệu chính (currentWeather) thất bại
      _errorMessage = e.toString().contains("Exception:")
          ? e.toString().replaceAll("Exception: ", "")
          : e.toString();
      _state = WeatherState.error;
    }

    notifyListeners(); // Hoàn tất, cập nhật UI
  }
}
