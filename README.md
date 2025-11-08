# flutter_application_1

New Project Flutter

## Bắt đầu

Dự án này là điểm khởi đầu cho một ứng dụng Flutter.

Một vài tài nguyên để bạn bắt đầu nếu đây là dự án Flutter đầu tiên của bạn:

- [Thực hành: Viết ứng dụng Flutter đầu tiên](https://docs.flutter.dev/get-started/codelab)
- [Sách hướng dẫn: Các ví dụ Flutter hữu ích](https://docs.flutter.dev/cookbook)

Để được hỗ trợ bắt đầu phát triển Flutter, hãy xem
[tài liệu trực tuyến](https://docs.flutter.dev/), nơi cung cấp các hướng dẫn,
ví dụ, hướng dẫn về phát triển ứng dụng di động và tài liệu tham khảo API đầy đủ.

Ứng dụng Dự báo Thời tiết (Flutter Weather App)

Đây là một ứng dụng di động được xây dựng bằng Flutter, cho phép người dùng xem dự báo thời tiết hiện tại và trong tương lai gần cho bất kỳ địa điểm nào trên thế giới, sử dụng API của OpenWeatherMap (hoặc một nhà cung cấp khác).

🌍 Tính năng Chính

Thời tiết Hiện tại: Hiển thị nhiệt độ, điều kiện thời tiết, độ ẩm, tốc độ gió và áp suất.

Dự báo Chi tiết: Cung cấp dự báo theo giờ hoặc theo ngày (tùy thuộc vào tích hợp API).

Tìm kiếm Địa điểm: Cho phép người dùng tìm kiếm thời tiết theo tên thành phố.

Vị trí Hiện tại: Tự động phát hiện và hiển thị thời tiết tại vị trí hiện tại của người dùng.

Giao diện Đẹp mắt: Giao diện người dùng trực quan và phản hồi nhanh (responsive UI).

🛠️ Công nghệ Sử dụng

Framework: Flutter

Ngôn ngữ: Dart

Quản lý Trạng thái (State Management): Sử dụng Provider (dựa trên cấu trúc thư mục providers).

API Dữ liệu: OpenWeatherMap API (hoặc tương đương).

HTTP Client: http package (hoặc dio).

Location: geolocator package (để lấy vị trí hiện tại).

🚀 Bắt đầu Nhanh

Thực hiện theo các bước dưới đây để chạy dự án trên máy cục bộ của bạn.

1. Yêu cầu Tiên quyết

Đã cài đặt Flutter SDK và cấu hình môi trường.

Có một API Key hợp lệ từ nhà cung cấp dịch vụ thời tiết (ví dụ: OpenWeatherMap).

2. Cấu hình Dự án

Clone repository này:

git clone [LINK_REPOSITORY_CỦA_BẠN]
cd flutter_application_1


Cài đặt các dependencies:

flutter pub get


Cấu hình API Key:

Mở file dịch vụ thời tiết (lib/services/weather_service.dart).

Thay thế chuỗi YOUR_OPENWEATHER_API_KEY bằng API Key thực tế của bạn.

// Ví dụ trong weather_service.dart
const String _apiKey = 'YOUR_OPENWEATHER_API_KEY';


Cấu hình quyền (cho thiết bị di động):

Đảm bảo bạn đã thêm quyền truy cập mạng và vị trí cần thiết trong file AndroidManifest.xml (Android) và Info.plist (iOS).

3. Chạy Ứng dụng

Kết nối thiết bị hoặc chạy simulator/emulator, sau đó:

flutter run


📐 Kiến trúc Code

Dự án được tổ chức theo kiến trúc phân lớp rõ ràng để dễ dàng bảo trì và mở rộng.

Thư mục

Mục đích

Ví dụ File

lib/models

Chứa các mô hình dữ liệu (Dart classes) để ánh xạ (map) phản hồi JSON từ API.

weather.dart (Chứa class Weather và các class liên quan như Main, Wind, v.v.)

lib/services

Chứa logic nghiệp vụ liên quan đến việc giao tiếp với các dịch vụ bên ngoài (như API).

weather_service.dart (Chứa các hàm như fetchCurrentWeather() và fetchForecast())

lib/providers

Chứa các lớp quản lý trạng thái (ChangeNotifier hoặc Provider tương đương) để cung cấp dữ liệu cho toàn bộ ứng dụng.

weather_provider.dart (Quản lý trạng thái tải, lỗi và dữ liệu thời tiết đã fetch).

lib/screens

Chứa các màn hình chính (pages) của ứng dụng.

home_screen.dart (Màn hình chính hiển thị thời tiết).

lib/widgets

Chứa các thành phần UI có thể tái sử dụng được (reusable UI components).

weather_card.dart (Widget để hiển thị thông tin thời tiết trong thẻ).

