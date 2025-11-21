class HistoricalModel {
  final double averageTemp;
  final DateTime date;

  // constructor cho dữ liệu lịch sử
  HistoricalModel({required this.averageTemp, required this.date});

  // factory constructor cho dữ liệu lịch sử (mô phỏng/API cũ)
  factory HistoricalModel.fromJson(Map<String, dynamic> json) {
    // logic placeholder vì đang mô phỏng dữ liệu lịch sử
    // dữ liệu thực tế sẽ được tạo ngẫu nhiên trong notifier.
    return HistoricalModel(averageTemp: 0.0, date: DateTime.now());
  }
}
