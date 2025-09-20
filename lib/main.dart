import 'package:flutter/material.dart';

// Step 2: Install loading app screen
import 'package:project/first_screen.dart';

// Step 4: Connect to Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Step 4: Connect to Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    // Step 6: Firestore CRUD operation
    const MaterialApp(home: FirstScreen(), debugShowCheckedModeBanner: false),
  );
}
/// เกษม เกษมสุข 027 67/1
/// ทิวัตถ์ แอสบิลลี่ 09 67/1
/// กฤษณพงศ์ ปรีชามาตร์ 001 67/1