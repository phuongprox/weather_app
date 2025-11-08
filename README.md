
**New Project Flutter**

## Bắt đầu

Dự án này là điểm khởi đầu cho một ứng dụng Flutter.

Một vài tài nguyên để bạn bắt đầu nếu đây là dự án Flutter đầu tiên của bạn:

- [Thực hành: Viết ứng dụng Flutter đầu tiên](https://docs.flutter.dev/get-started/codelab)
- [Sách hướng dẫn: Các ví dụ Flutter hữu ích](https://docs.flutter.dev/cookbook)

Để được hỗ trợ bắt đầu phát triển Flutter, hãy xem
[tài liệu trực tuyến](https://docs.flutter.dev/), nơi cung cấp các hướng dẫn,
ví dụ, hướng dẫn về phát triển ứng dụng di động và tài liệu tham khảo API đầy đủ.

🌧️ **WeatherInsight**: Ứng Dụng Dự Báo Thời Tiết Thông Minh (Flutter)
🌟 Giới Thiệu Dự Án
WeatherInsight là một ứng dụng di động được xây dựng bằng Flutter, cung cấp thông tin dự báo thời tiết chính xác và chi tiết. Điểm đặc biệt của dự án là việc tích hợp tính năng Phân tích Dữ liệu Lịch sử (AI/ML) để đưa ra các nhận định và đối chiếu thông minh, giúp người dùng hiểu rõ hơn về xu hướng thời tiết hiện tại so với quá khứ.

Dự án này được phát triển như một sản phẩm cuối kỳ cho môn **Phát triển ứng dụng đa nền tảng** với mục tiêu kết hợp kỹ năng phát triển di động (Flutter) và xử lý dữ liệu (Phân tích Thống kê Nâng cao).

🚀 Tính Năng Nổi Bật
- Dự báo Chi tiết 7 Ngày: Cung cấp thông tin nhiệt độ, độ ẩm, tốc độ gió và áp suất cho 7 ngày tiếp theo.

- Tự động Định vị: Sử dụng geolocator để tự động hiển thị thời tiết của vị trí hiện tại của người dùng.

- Tìm kiếm Linh hoạt: Cho phép người dùng tìm kiếm và xem thời tiết của bất kỳ thành phố nào trên thế giới.

🔥 Weather AI Insight (Điểm nhấn):

- Đối chiếu Lịch sử: So sánh các chỉ số thời tiết hiện tại (ví dụ: nhiệt độ trung bình) với cùng kỳ năm trước.

- Phán đoán Xu hướng: Đưa ra các nhận định đơn giản dựa trên sự khác biệt về phần trăm (ví dụ: "Nhiệt độ tuần này cao hơn 10% so với năm ngoái, cảnh báo nắng nóng bất thường").

- Giao diện Đẹp mắt: UI hiện đại, sử dụng gradient và biểu tượng động để tăng trải nghiệm người dùng.

🛠️ Công nghệ Sử dụng

- Framework: Flutter

- Ngôn ngữ: Dart

- Quản lý Trạng thái (State Management): Sử dụng Provider (dựa trên cấu trúc thư mục providers).

- API Dữ liệu: OpenWeatherMap API.

- HTTP Client: http package (hoặc dio).

- Location: geolocator package (để lấy vị trí hiện tại).

⚙️ Hướng Dẫn Cài Đặt và Chạy Dự Án

Để chạy dự án này trên thiết bị của bạn, vui lòng thực hiện các bước sau:

1.Clone Repository:
git clone [LINK_ĐẾN_REPOSITORY_CỦA_BẠN]
cd weather_insight

2.Cài đặt Dependencies:
flutter pub get

3.Thiết lập API Key:
Đăng ký tài khoản tại [Tên API bạn sử dụng] và lấy API Key.

Tạo file cấu hình (ví dụ: lib/constants/api_keys.dart) và thêm key của bạn:
const String OPEN_WEATHER_API_KEY = "YOUR_API_KEY_HERE";

4.Chạy Ứng Dụng:
flutter run


📐 Kiến trúc Code

Dự án được tổ chức theo kiến trúc phân lớp rõ ràng để dễ dàng bảo trì và mở rộng.

Thư mục

- lib/models

  Chứa các mô hình dữ liệu (Dart classes) để ánh xạ (map) phản hồi JSON từ API.

- weather.dart (Chứa class Weather và các class liên quan như Main, Wind, v.v.)

- lib/services

  Chứa logic nghiệp vụ liên quan đến việc giao tiếp với các dịch vụ bên ngoài (như API).

- weather_service.dart (Chứa các hàm như fetchCurrentWeather() và fetchForecast())

- lib/providers

  Chứa các lớp quản lý trạng thái (ChangeNotifier hoặc Provider tương đương) để cung cấp dữ liệu cho toàn bộ ứng dụng.

- weather_provider.dart (Quản lý trạng thái tải, lỗi và dữ liệu thời tiết đã fetch).

- lib/screens

  Chứa các màn hình chính (pages) của ứng dụng.

- home_screen.dart (Màn hình chính hiển thị thời tiết).

- lib/widgets

  Chứa các thành phần UI có thể tái sử dụng được (reusable UI components).

- weather_card.dart (Widget để hiển thị thông tin thời tiết trong thẻ).

🧑‍💻 Tác Giả
[Nguyễn Nam Phương] - [TDMU/2224801030038@student.tdmu.edu.vn] - [Email: namphuong.844220@gmail.com/Github: https://github.com/phuongprox]
