import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import file cấu hình Firebase
import 'firebase_options.dart';

// Import file router
import 'src/core/routing/app_router.dart';
// Import service thông báo
import 'src/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- BƯỚC 3: KHỞI TẠO NOTIFICATION SERVICE ---
  // Chúng ta khởi tạo service này ngay khi app bật để xin quyền và cấu hình kênh
  final notificationService = NotificationService();
  await notificationService.init();
  // ---------------------------------------------

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 'watch' routerProvider từ Riverpod
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Sensor Dashboard',
      // Tắt banner debug cho app nhìn chuyên nghiệp hơn
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true, // Khuyến nghị dùng Material 3 cho UI hiện đại
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Cấu hình router
      routerConfig: router,
    );
  }
}