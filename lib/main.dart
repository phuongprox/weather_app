// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Imports
import 'package:weather_app/data/repository/weather_repo.dart';
import 'package:weather_app/presentation/state_mgt/weather_notifier.dart';
import 'package:weather_app/presentation/screens/home_screen.dart';
import 'package:weather_app/config/constants.dart';

void main() {
  runApp(
    // Chú thích: MultiProvider để cung cấp các dịch vụ/trạng thái cho toàn ứng dụng
    MultiProvider(
      providers: [
        // 1. Cung cấp WeatherRepository (Service/Data Layer)
        Provider(create: (_) => WeatherRepository()),

        // 2. Cung cấp WeatherNotifier (State Manager/Business Logic)
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
      // 🚨 SỬA ĐỔI CHÍNH: Thêm thuộc tính này để ẩn tag DEBUG
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Sử dụng HomeScreen chính thức
    );
  }
}
