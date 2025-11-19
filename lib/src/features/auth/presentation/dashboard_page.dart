import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD

// Import các thành phần logic/data trong dự án
=======
import 'package:fl_chart/fl_chart.dart'; // Thư viện biểu đồ
import 'package:intl/intl.dart'; // Thư viện định dạng ngày giờ

// Import các thành phần trong dự án
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
import '../../auth/data/auth_repository.dart';
import '../../dashbroard/logic/dashboard_providers.dart';
import '../data/sensor_model.dart';

<<<<<<< HEAD
// Import các Widget con đã tách
import 'sensor_card.dart';
import 'sensor_line_chart.dart';

// --- BƯỚC 4: Import Notification Service ---
import '../../../services/notification_service.dart'; 
// (Lưu ý: Kiểm tra lại đường dẫn import tùy thuộc vào cấu trúc thư mục thực tế của bạn)

// Chuyển thành ConsumerStatefulWidget để giữ trạng thái _lastAlertTime
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  // Cấu hình ngưỡng cảnh báo
  static const double ecThreshold = 2.5;
  static const double pptThreshold = 30.0;

  // Biến lưu thời gian lần báo động cuối để tránh spam (Debounce)
  DateTime? _lastAlertTime;

  @override
  Widget build(BuildContext context) {
    // --- 1. LOGIC LẮNG NGHE & CẢNH BÁO (Side Effect) ---
    ref.listen<AsyncValue<List<SensorData>>>(sensorHistoryProvider, (previous, next) {
      next.whenData((data) {
        if (data.isEmpty) return;
        final latest = data.last;

        // Kiểm tra xem có chỉ số nào vượt ngưỡng không
        bool isDanger = latest.ec > ecThreshold || latest.ppt > pptThreshold;

        // Logic chặn spam: Chỉ báo nếu chưa báo bao giờ HOẶC đã qua 1 phút
        bool shouldNotify = isDanger &&
            (_lastAlertTime == null ||
                DateTime.now().difference(_lastAlertTime!).inMinutes >= 1);

        if (shouldNotify) {
          String title = "CẢNH BÁO KHẨN CẤP ⚠️";
          String body = "";

          if (latest.ec > ecThreshold) {
            body = "Độ mặn (EC) quá cao: ${latest.ec} (Ngưỡng: $ecThreshold)";
          } else {
            body = "Nồng độ (PPT) quá cao: ${latest.ppt} (Ngưỡng: $pptThreshold)";
          }

          // A. Gửi thông báo đẩy (System Notification)
          ref.read(notificationServiceProvider).showNotification(
                id: 1,
                title: title,
                body: body,
              );

          // B. Hiển thị SnackBar trong app
          _showEmergencyAlert(context, title, body);

          // Cập nhật thời gian
          _lastAlertTime = DateTime.now();
        }
      });
    });

    // --- 2. LOGIC HIỂN THỊ GIAO DIỆN ---
=======
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe luồng dữ liệu lịch sử (Danh sách các SensorData)
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
    final AsyncValue<List<SensorData>> historyAsync = ref.watch(
      sensorHistoryProvider,
    );

    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.grey[100],
=======
      backgroundColor: Colors.grey[100], // Màu nền nhẹ
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
      appBar: AppBar(
        title: const Text('Hệ Thống Giám Sát'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
<<<<<<< HEAD
=======
              // Đăng xuất
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: historyAsync.when(
<<<<<<< HEAD
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
        ),
=======
        // 1. Trạng thái Đang tải
        loading: () => const Center(child: CircularProgressIndicator()),

        // 2. Trạng thái Lỗi
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
        ),

        // 3. Trạng thái Có dữ liệu
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
        data: (dataList) {
          if (dataList.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có dữ liệu.\nHãy đợi thiết bị gửi bản ghi đầu tiên...',
              ),
            );
          }

<<<<<<< HEAD
=======
          // Lấy bản ghi mới nhất (cuối danh sách) để hiển thị lên các thẻ
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
          final latest = dataList.last;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông số hiện tại",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

<<<<<<< HEAD
                // === PHẦN 1: CÁC THẺ SENSOR ===
=======
                // === PHẦN 1: CÁC THẺ SENSOR (CARDS) ===
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
                SensorCard(
                  title: 'Nhiệt độ',
                  value: '${latest.temp.toStringAsFixed(1)} °C',
                  icon: Icons.thermostat,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 12),
                SensorCard(
                  title: 'Độ mặn (EC)',
                  value: latest.ec.toStringAsFixed(2),
                  icon: Icons.flash_on,
<<<<<<< HEAD
                  // Logic đổi màu thẻ khi nguy hiểm
                  color: latest.ec > ecThreshold ? Colors.red : Colors.amber[700]!,
=======
                  color: Colors.amber[700]!,
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
                ),
                const SizedBox(height: 12),
                SensorCard(
                  title: 'Nồng độ (PPT)',
                  value: latest.ppt.toStringAsFixed(4),
                  icon: Icons.water_drop,
<<<<<<< HEAD
                  // Logic đổi màu thẻ khi nguy hiểm
                  color: latest.ppt > pptThreshold ? Colors.red : Colors.blue,
=======
                  color: Colors.blue,
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
                ),
                const SizedBox(height: 12),
                SensorCard(
                  title: 'Độ pH',
                  value: latest.ph.toStringAsFixed(2),
                  icon: Icons.science,
                  color: Colors.green,
                ),

                const SizedBox(height: 30),
                const Text(
                  "Biểu đồ theo dõi (EC & PPT)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

<<<<<<< HEAD
                // === PHẦN 2: BIỂU ĐỒ ===
                Container(
                  height: 350,
=======
                // === PHẦN 2: BIỂU ĐỒ (CHART) ===
                Container(
                  height: 350, // Chiều cao biểu đồ
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
                  padding: const EdgeInsets.fromLTRB(10, 25, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
<<<<<<< HEAD
                        color: Colors.black.withValues(alpha: 0.05),
=======
                        color: Colors.black.withOpacity(0.05),
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SensorLineChart(data: dataList),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
<<<<<<< HEAD

  // Hàm hiển thị SnackBar cảnh báo
  void showEmergencyAlert(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[900],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
=======
}

// ==========================================
// WIDGET CON: THẺ CẢM BIẾN (SENSOR CARD)
// ==========================================
class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGET CON: BIỂU ĐỒ ĐƯỜNG (LINE CHART)
// ==========================================
class SensorLineChart extends StatelessWidget {
  final List<SensorData> data;

  const SensorLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // Cấu hình lưới
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.5, // Khoảng cách lưới ngang
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),

        // Cấu hình Tiêu đề trục (Trục dưới và Trục trái)
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          // Trục dưới (Thời gian)
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                // Chỉ hiển thị nhãn cho một số điểm nhất định để tránh chồng chéo
                if (index >= 0 && index < data.length && index % 3 == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('HH:mm').format(data[index].timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Trục trái (Giá trị)
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),

        // Cấu hình khung viền
        borderData: FlBorderData(show: false),

        // Cấu hình Tooltip khi chạm vào
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final spotIndex = touchedSpot.x.toInt();
                String label = touchedSpot.barIndex == 0 ? "EC" : "PPT";
                return LineTooltipItem(
                  '$label: ${touchedSpot.y}\n${DateFormat('HH:mm:ss').format(data[spotIndex].timestamp)}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),

        // DỮ LIỆU VẼ BIỂU ĐỒ
        lineBarsData: [
          // Đường 1: EC (Màu Vàng)
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.ec);
            }).toList(),
            isCurved: true, // Làm mềm đường
            color: Colors.amber,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.amber.withOpacity(0.1),
            ),
          ),

          // Đường 2: PPT (Màu Xanh)
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.ppt);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
