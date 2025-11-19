<<<<<<< HEAD
=======
// File: lib/main.dart (ĐÃ CẬP NHẬT)

>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

<<<<<<< HEAD
// Import file cấu hình Firebase
import 'firebase_options.dart';

// Import file router
import 'src/core/routing/app_router.dart';
// Import service thông báo
import 'src/services/notification_service.dart';
=======
// Import file cấu hình Firebase (Giai đoạn 1)
import 'firebase_options.dart';

// Import file router (Giai đoạn 3)
import 'src/core/routing/app_router.dart';
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
  // 1. Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- BƯỚC 3: KHỞI TẠO NOTIFICATION SERVICE ---
  // Chúng ta khởi tạo service này ngay khi app bật để xin quyền và cấu hình kênh
  final notificationService = NotificationService();
  await notificationService.init();
  // ---------------------------------------------
=======
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb

  runApp(const ProviderScope(child: MyApp()));
}

<<<<<<< HEAD
=======
// Biến MyApp thành ConsumerWidget để có thể 'watch' provider
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
<<<<<<< HEAD
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
=======
    // 1. 'watch' (theo dõi) routerProvider
    final router = ref.watch(routerProvider);

    // 2. Thay đổi MaterialApp thành MaterialApp.router
    return MaterialApp.router(
      title = 'Sensor Dashboard',
      theme = ThemeData(
        primarySwatch: Colors.indigo, // Bạn có thể đổi màu nếu muốn
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // 3. Cấu hình router
      routerConfig = router,
    );
  }
}
>>>>>>> 686fe6d8173fdcd73e709813ec74096408f0dddb
