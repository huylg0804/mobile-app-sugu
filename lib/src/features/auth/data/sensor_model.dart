import 'package:flutter/foundation.dart'; // Cần thiết cho @immutable

@immutable
class SensorData {
  final double ec;
  final double ppt;
  final double temp;
  final double ph;
  final DateTime timestamp;

  const SensorData({
    required this.ec,
    required this.ppt,
    required this.temp,
    required this.ph,
    required this.timestamp,
  });

  // Factory constructor để parse dữ liệu từ Firebase
  factory SensorData.fromMap(Map<dynamic, dynamic> map) {
    // 1. Hàm phụ xử lý an toàn: Chuyển mọi thứ (int, String, null) thành double
    double parseValue(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    // 2. Xử lý Timestamp an toàn
    final timestampVal = map['timestamp'];
    DateTime date;
    if (timestampVal is int) {
      // Nếu Firebase lưu timestamp dạng số (milliseconds)
      date = DateTime.fromMillisecondsSinceEpoch(timestampVal);
    } else if (timestampVal is String) {
      // Phòng trường hợp Firebase lưu dạng chuỗi ISO8601
      date = DateTime.tryParse(timestampVal) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    // 3. Return object đã map đúng key
    // Lưu ý: Tôi đã đổi input thành Map<dynamic, dynamic> vì Firebase
    // thường trả về key dạng dynamic chứ không phải lúc nào cũng là String chặt chẽ.
    return SensorData(
      ec: parseValue(map['ec_ms_cm']),      
      temp: parseValue(map['temperature']), 
      ph: parseValue(map['ph_value']),      
      ppt: parseValue(map['salinity_ppt']), 
      timestamp: date,
    );
  }
  
  // Bonus: Getter để lấy giá trị X cho biểu đồ (chuyển timestamp thành double)
  double get xValue => timestamp.millisecondsSinceEpoch.toDouble();
}