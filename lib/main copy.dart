import 'package:flutter/material.dart';

// Step 2: Install loading app screen
import 'package:project/first_screen.dart';

// Step 4: Connect to Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // ✅ ให้ Flutter ทำงานกับ async ก่อน runApp
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initial Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Run app
  runApp(const MyApp());
}

/// ✅ ตัวหลักของแอป
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anime Rating App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: "Roboto"),
      home: const FirstScreen(), // ✅ หน้าแรก
    );
  }
}
