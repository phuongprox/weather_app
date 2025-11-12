import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/repository/weather_repo.dart';
import 'package:weather_app/data/models/weather_model.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final WeatherRepository _weatherRepo = WeatherRepository();
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String _statusMessage = "";

  Future<void> _testApiConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Đang lấy thời tiết Tokyo...";
    });

    try {
      final data = await _weatherRepo.fetchWeatherByCity("Tokyo");
      setState(() {
        _weatherData = data;
        _statusMessage = "✅ KẾT NỐI THÀNH CÔNG!";
      });
    } catch (e) {
      setState(() => _statusMessage = "❌ Lỗi: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Đang lấy vị trí...";
    });

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _statusMessage = "❌ Bạn đã từ chối quyền GPS");
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await _weatherRepo.fetchWeatherByLocation(
        pos.latitude,
        pos.longitude,
      );

      setState(() {
        _weatherData = data;
        _statusMessage = "✅ ĐÃ LẤY THỜI TIẾT THEO GPS!";
      });
    } catch (e) {
      setState(() => _statusMessage = "❌ Lỗi GPS: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSuccessData() {
    return Card(
      margin: const EdgeInsets.all(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thành phố: ${_weatherData!.cityName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Nhiệt độ: ${_weatherData!.temperature}°C"),
            Text("Tình trạng: ${_weatherData!.description}"),
            Text("Độ ẩm: ${_weatherData!.humidity}%"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Test Screen (OpenWeather)")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  _weatherData != null
                      ? _buildSuccessData()
                      : Column(
                          children: [
                            ElevatedButton(
                              onPressed: _testApiConnection,
                              child: const Text("Lấy thời tiết Tokyo"),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _getWeatherByLocation,
                              child: const Text("📍 Lấy thời tiết theo vị trí"),
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}
