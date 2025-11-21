import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/repository/weather_repo.dart';
import 'package:weather_app/presentation/state_mgt/weather_notifier.dart';
import 'package:weather_app/presentation/screens/home_screen.dart';
import 'package:weather_app/config/constants.dart';

void main() {
  runApp(
    //MultiProvider để cung cấp các dịch vụ/trạng thái cho toàn ứng dụng
    MultiProvider(
      providers: [
        //Cung cấp WeatherRepository
        Provider(create: (_) => WeatherRepository()),

        // Cung cấp WeatherNotifier
        ChangeNotifierProvider(
          create: (context) =>
              WeatherNotifier(
                context.read<WeatherRepository>(), // Inject Repository
              )..fetchWeatherData(
                kDefaultCity,
              ), // Tải dữ liệu mặc định khi ứng dụng khởi động
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherInsight',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      //Thêm thuộc tính ẩn tag DEBUG
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Sử dụng HomeScreen chính thức
    );
  }
}
