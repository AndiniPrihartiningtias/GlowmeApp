import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';

import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Local Notification
  await NotificationService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => ProductProvider()),
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
      debugShowCheckedModeBanner: false,

      title: "GlowMe",

      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF4A80),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffFFF8FA),
      ),

      home: const LoginPage(),
    );
  }
}
