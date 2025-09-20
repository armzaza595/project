import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  /// ✅ เช็คอินเทอร์เน็ต
  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      _showToast(context, "📱 Mobile network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      _showToast(context, "📶 Wi-Fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      _showToast(context, "🖥 Ethernet is available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      _showToast(context, "🔒 VPN connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      _showToast(context, "🌀 Bluetooth connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      _showToast(context, "🌐 Other network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        _showAlertDialog(
          context,
          "No Internet 😢",
          "Please check your internet connection.",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Gradient background สีม่วง-ชมพู-ฟ้า
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8E2DE2), // ม่วง
              Color(0xFF4A00E0), // ม่วงเข้ม
              Color(0xFFF48FB1), // ชมพู
              Color(0xFF80D8FF), // ฟ้าอ่อน
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Card รูปภาพสวย
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 12,
                  shadowColor: Colors.pinkAccent.withOpacity(0.4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/image/loadingScreen.jpeg',
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ✅ Spin animation สีชมพู
                const SpinKitFadingCircle(
                  color: Colors.pinkAccent,
                  size: 60.0,
                ),
                const SizedBox(height: 25),

                // ✅ ข้อความ Welcome
                const Text(
                  "Welcome to Anime Rating",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black38,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ Timer -> ไป SecondScreen
void _timer(BuildContext context) {
  Timer(
    const Duration(seconds: 3),
    () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    ),
  );
}

/// ✅ Toast
void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.pinkAccent,
    textColor: Colors.white,
    fontSize: 18.0,
  );
  _timer(context);
}

/// ✅ Alert Dialog
void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.deepPurple.shade50,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          msg,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// ✅ SecondScreen
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background สีม่วง-ชมพู
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFFF48FB1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 100, color: Colors.white.withOpacity(0.9)),
                const SizedBox(height: 30),
                Text(
                  'Welcome to the Second Screen!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
