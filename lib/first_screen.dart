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

  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      _showToast("Mobile network available");
      _timer(context);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _showToast("Wi-fi is available.");
      _timer(context);
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      _showToast("Ethernet connection available.");
      _timer(context);
    } else if (connectivityResult == ConnectivityResult.vpn) {
      _showToast("Vpn connection active.");
      _timer(context);
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      _showToast("Bluetooth connection available.");
      _timer(context);
    } else if (connectivityResult == ConnectivityResult.other) {
      _showToast("Other network is available.");
      _timer(context);
    } else if (connectivityResult == ConnectivityResult.none) {
      _showAlertDialog(
        context,
        "No Internet Connection",
        "Please check your internet settings.",
      );
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }

  void _timer(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NextScreen()),
      );
    });
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: const Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 60.0,
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Welcome to Next Screen")),
    );
  }
}
