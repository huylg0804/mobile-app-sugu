import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/sensor_model.dart'; // Đảm bảo đường dẫn này đúng với project của bạn

class SensorLineChart extends StatelessWidget {
  final List<SensorData> data;

  const SensorLineChart({super.key, required this.data});

  // Hàm phụ trợ để format thời gian (HH:mm) từ DateTime
  // Giúp bạn không cần cài thêm thư viện intl mà vẫn hiển thị đẹp
  String _formatTime(DateTime dt) {
    final String hour = dt.hour.toString().padLeft(2, '0');
    final String minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("Đang chờ dữ liệu..."));
    }

    return Column(
      children: [
        const Text(
          "Biểu đồ EC (Vàng) và PPT (Xanh)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: LineChart(
              LineChartData(
                // 1. Cấu hình lưới (Grid)
                gridData: const FlGridData(
                  show: true, 
                  drawVerticalLine: false,
                  horizontalInterval: 1, // Kẻ dòng ngang mỗi 1 đơn vị (tuỳ chỉnh nếu cần)
                ),
                
                // 2. Cấu hình Tiêu đề (Titles)
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1, // Bắt buộc set interval = 1 để logic index bên dưới chạy đúng
                      getTitlesWidget: (value, meta) {
                        // Hiển thị giờ ở trục dưới
                        final index = value.toInt();
                        
                        // Kiểm tra index hợp lệ để tránh lỗi Crash App
                        if (index >= 0 && index < data.length && index % 5 == 0) {
                          // Lấy timestamp từ data tại vị trí index
                          final dt = data[index].timestamp;
                          
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              _formatTime(dt), // SỬA LỖI 1: Gọi hàm format thay vì .formatedTime
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                
                // 3. Khung viền
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                
                // 4. Dữ liệu đường vẽ (Lines)
                lineBarsData: [
                  // --- Đường biểu diễn EC (Vàng) ---
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.ec);
                    }).toList(),
                    isCurved: true,
                    color: Colors.amber,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      // SỬA LỖI 2: Dùng withValues(alpha: 0.1) thay cho withOpacity(0.1)
                      color: Colors.amber.withValues(alpha: 0.1),
                    ),
                  ),
                  
                  // --- Đường biểu diễn PPT (Xanh) ---
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.ppt);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}