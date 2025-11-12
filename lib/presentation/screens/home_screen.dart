// lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/state_mgt/weather_notifier.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/models/forecast_model.dart';
import 'package:weather_app/config/constants.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Chú thích: Hàm lấy biểu tượng Flutter tương ứng với mã icon của OpenWeatherMap
  IconData _getIconData(String iconCode) {
    if (iconCode.contains('01')) {
      // Sửa: Thêm block {}
      return Icons.wb_sunny; // Clear sky
    }
    if (iconCode.contains('02')) {
      return Icons.wb_cloudy; // Few clouds
    }
    if (iconCode.contains('03') || iconCode.contains('04')) {
      return Icons.cloud; // Scattered/Broken clouds
    }
    if (iconCode.contains('09')) {
      return Icons.shower; // Shower rain
    }
    if (iconCode.contains('10')) {
      return Icons.umbrella; // Rain
    }
    if (iconCode.contains('11')) {
      return Icons.thunderstorm; // Thunderstorm
    }
    if (iconCode.contains('13')) {
      return Icons.snowing; // Snow
    }
    if (iconCode.contains('50')) {
      return Icons.foggy; // Mist
    }
    return Icons.wb_sunny; // Mặc định
  }

  // Chú thích: Lấy nhiệt độ Max/Min từ danh sách dự báo (Sử dụng 5 điểm đầu tiên)
  Map<String, double> _getTempExtremes(List<ForecastModel> forecasts) {
    if (forecasts.isEmpty) return {'max': 0.0, 'min': 0.0};

    // Tìm nhiệt độ min/max trong các điểm dự báo 3 giờ của ngày hôm nay
    double max = forecasts
        .map((f) => f.temperature)
        .reduce((a, b) => a > b ? a : b);
    double min = forecasts
        .map((f) => f.temperature)
        .reduce((a, b) => a < b ? a : b);

    return {'max': max, 'min': min};
  }

  @override
  Widget build(BuildContext context) {
    // Chú thích: Lắng nghe trạng thái (state) và dữ liệu từ WeatherNotifier
    final notifier = context.watch<WeatherNotifier>();

    Widget content;

    // Chú thích: Xử lý hiển thị dựa trên các trạng thái chính
    switch (notifier.state) {
      case WeatherState.initial:
        content = const Center(
          child: Text(
            'Đang khởi động ứng dụng...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
        break;
      case WeatherState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case WeatherState.loaded:
        // Khi tải thành công, hiển thị giao diện chính
        content = _buildLoadedUI(
          context,
          notifier,
          _getTempExtremes(notifier.forecasts),
        );
        break;
      case WeatherState.error:
        // Xử lý hiển thị lỗi chỉ khi dữ liệu chính (currentWeather) là null
        content = _buildErrorUI(context, notifier);
        break;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Gradient màu xanh đậm theo mẫu thiết kế mới
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: content),
      ),
    );
  }

  // === CÁC WIDGET CHÍNH (LOADED) ===

  Widget _buildLoadedUI(
    BuildContext context,
    WeatherNotifier notifier,
    Map<String, double> tempExtremes,
  ) {
    final weather = notifier.currentWeather;
    if (weather == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(context, weather.cityName),
          _buildCurrentWeatherInfo(weather, tempExtremes),
          const SizedBox(height: 30),
          _buildHourlyForecast(notifier.forecasts), // Dự báo hàng giờ
          const SizedBox(height: 30),
          _buildWeatherDetailsGrid(weather), // Chi tiết (Humidity/Wind)
          const SizedBox(height: 30),
          _buildSevenDayForecast(notifier.forecasts), // Dự báo 5 ngày
        ],
      ),
    );
  }

  // Chú thích: 1. Header (Vị trí và Menu)
  Widget _buildHeader(BuildContext context, String cityName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Nút tìm kiếm / Menu (Sẽ chuyển sang màn hình tìm kiếm ở Tuần 4)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng Tìm kiếm sẽ được triển khai!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Chú thích: 2. Thông tin Thời tiết Hiện tại
  Widget _buildCurrentWeatherInfo(
    WeatherModel weather,
    Map<String, double> tempExtremes,
  ) {
    return Column(
      children: [
        Icon(_getIconData(weather.iconCode), size: 140, color: Colors.white),
        const SizedBox(height: 10),
        // Nhiệt độ
        Text(
          '${weather.temperature.round()}°',
          style: const TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        // Tình trạng thời tiết
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        // Nhiệt độ Cao/Thấp (H/L)
        Text(
          'H: ${tempExtremes['max']!.round()}° L: ${tempExtremes['min']!.round()}°',
          style: const TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
    );
  }

  // Chú thích: 3. Dự báo Hàng giờ (Hourly/3-Hour Forecast)
  Widget _buildHourlyForecast(List<ForecastModel> forecasts) {
    // Chỉ lấy 8 điểm dự báo đầu tiên (24 giờ)
    final hourlyData = forecasts.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Dự báo Hôm nay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final item = hourlyData[index];
              return Container(
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                // Sửa: Thay thế .withOpacity bằng Color.fromARGB để giải quyết cảnh báo deprecated
                decoration: BoxDecoration(
                  color: Color.fromARGB(51, 255, 255, 255), // 20% Opacity
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat(
                        'ha',
                      ).format(item.date), // Hiển thị giờ (ví dụ: 5PM)
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      _getIconData(item.iconCode),
                      size: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Chú thích: 4. Grid Chi tiết (Humidity & Wind Speed)
  Widget _buildWeatherDetailsGrid(WeatherModel weather) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.8, // Tăng chiều ngang cho gọn hơn
        ),
        children: [
          _detailCard(
            title: 'Độ ẩm (Humidity)',
            value: '${weather.humidity}%',
            icon: Icons.water_drop_outlined,
          ),
          _detailCard(
            title: 'Tốc độ gió (Wind)',
            value: '${weather.windSpeed} m/s',
            icon: Icons.air,
          ),
        ],
      ),
    );
  }

  // Chú thích: Widget bọc bên ngoài cho Detail Card
  Widget _detailCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      // Sửa: Thay thế .withOpacity bằng Color.fromARGB để giải quyết cảnh báo deprecated
      decoration: BoxDecoration(
        color: Color.fromARGB(51, 255, 255, 255), // 20% Opacity
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.water_drop_outlined,
                  size: 20,
                  color: Colors.white70,
                ), // Sử dụng Icon cố định cho ví dụ
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chú thích: 5. Dự báo 5 Ngày (Daily Forecast List)
  Widget _buildSevenDayForecast(List<ForecastModel> forecasts) {
    // Chỉ lấy 5 điểm đầu tiên (5 ngày)
    final dailyData = forecasts.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dự báo 5 Ngày tới',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Sửa: Xóa .toList() không cần thiết trong spread
          ...dailyData.map((item) {
            return _dailyForecastRow(item);
          }),
        ],
      ),
    );
  }

  // Chú thích: Hàng hiển thị dự báo từng ngày
  Widget _dailyForecastRow(ForecastModel item) {
    // Biến 'range' đã bị xóa
    // Chúng ta sẽ mô phỏng nhiệt độ Min/Max dựa trên nhiệt độ 3 giờ duy nhất
    final tempMax = item.temperature.round() + 2;
    final tempMin = item.temperature.round() - 3;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // Sửa: Thay thế .withOpacity bằng Color.fromARGB để giải quyết cảnh báo deprecated
      decoration: BoxDecoration(
        color: Color.fromARGB(38, 255, 255, 255), // 15% Opacity
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Ngày (Ví dụ: MON)
          SizedBox(
            width: 50,
            child: Text(
              DateFormat(
                'EEE',
              ).format(item.date).toUpperCase(), // Thứ (Mon, Tue...)
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Icon
          Icon(_getIconData(item.iconCode), size: 24, color: Colors.white),
          const SizedBox(width: 15),
          // Nhiệt độ Thấp (Low)
          Text(
            '$tempMin°',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(width: 10),
          // Thanh nhiệt độ (Mô phỏng)
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.yellow, Colors.red],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Nhiệt độ Cao (High)
          SizedBox(
            width: 30,
            child: Text(
              '$tempMax°',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chú thích: Widget hiển thị Lỗi (khi dữ liệu chính thất bại)
  Widget _buildErrorUI(BuildContext context, WeatherNotifier notifier) {
    // Chú thích: Cần import 'package:weather_app/config/constants.dart'
    // (Đã được sửa ở phần imports trên cùng)

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Rất tiếc! Đã xảy ra lỗi.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              notifier.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => notifier.fetchWeatherData(
                notifier.currentWeather?.cityName ?? kDefaultCity,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
