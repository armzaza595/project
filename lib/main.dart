import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: FirstScreen()));
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My First Screen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('test').add({
              'message': 'Hello Firestore!',
              'timestamp': DateTime.now(),
            });
          },
          child: const Text("Add Data to Firestore"),
        ),
      ),
    );
  }
}
