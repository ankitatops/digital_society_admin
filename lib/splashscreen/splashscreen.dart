import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../adminlogin/adminlogin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkconnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(child: Image.asset("assets/no1.png", height: 250)),
    );
  }

  void checkconnectivity() async {
    var connectivityresult = await Connectivity().checkConnectivity();

    if (connectivityresult != ConnectivityResult.none) {
      bool hasInternet = await checkInternetAccess();

      if (hasInternet) {
        Timer(
          Duration(seconds: 4),
              () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          ),
        );
      } else {
        shownetworkerrordialog();
      }
    } else {
      shownetworkerrordialog();
    }
  }

  Future<bool> checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void shownetworkerrordialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: const [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text("No Internet"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/error.png",
                height: 120,
              ),
              SizedBox(height: 15),
              Text(
                "No internet connection.\nPlease check your network.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                checkconnectivity();
              },
              child: Text("Retry"),
            ),
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
  }
}
