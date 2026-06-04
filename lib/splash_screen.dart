import 'dart:async';

import 'package:flutter/material.dart';
import 'network/secure_storge.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final token =
    await SecureStorageService.getToken();

    final role =
    await SecureStorageService.getRole();

    // /// User already logged in
    // if (token != null && token.isNotEmpty) {
    //
    //   // FCM token save/update
    //   await FCMService.initialize();
    // }

    /// Splash delay
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    /// Already logged in
    if (token != null && token.isNotEmpty) {

      if (role == "owner") {
        Navigator.pushReplacementNamed(
          context,
          '/dashboardScreen',
        );
      }

      else if (role == "member") {
        Navigator.pushReplacementNamed(
          context,
          '/dashboardContainer',
        );
      }

      else {
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      }
    }

    /// Not logged in
    else {
      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          "asset/splash_image.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}