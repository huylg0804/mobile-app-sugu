import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import các thành phần logic/data trong dự án
import '../../auth/data/auth_repository.dart';
import '../../dashbroard/logic/dashboard_providers.dart';
import '../data/sensor_model.dart';

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
    final AsyncValue<List<SensorData>> historyAsync = ref.watch(
      sensorHistoryProvider,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
        ),
        data: (dataList) {
          if (dataList.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có dữ liệu.\nHãy đợi thiết bị gửi bản ghi đầu tiên...',
              ),
            );
          }

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

                // === PHẦN 1: CÁC THẺ SENSOR ===
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
                  // Logic đổi màu thẻ khi nguy hiểm
                  color: latest.ec > ecThreshold ? Colors.red : Colors.amber[700]!,
                ),
                const SizedBox(height: 12),
                SensorCard(
                  title: 'Nồng độ (PPT)',
                  value: latest.ppt.toStringAsFixed(4),
                  icon: Icons.water_drop,
                  // Logic đổi màu thẻ khi nguy hiểm
                  color: latest.ppt > pptThreshold ? Colors.red : Colors.blue,
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

                // === PHẦN 2: BIỂU ĐỒ ===
                Container(
                  height: 350,
                  padding: const EdgeInsets.fromLTRB(10, 25, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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

  // Hàm hiển thị SnackBar cảnh báo
  void _showEmergencyAlert(BuildContext context, String title, String message) {
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