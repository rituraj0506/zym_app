import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zymmanagement/network/api_end_point.dart';
import 'package:zymmanagement/network/secure_storge.dart';
import 'package:zymmanagement/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  bool isLoading = false;

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.trim().isEmpty) {
      showError("Please enter email");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      showError("Please enter password");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
        "${Apiendpoint.baseUrl}/users/login",
      );

      final response = await http.post(
        url,

        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = decoded["token"];
        final role = decoded["data"]["role"];

        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveRole(role);

        if (!mounted) return;

        if (role == "owner") {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/dashboardScreen",
                (route) => false,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            "memberDashboard",
          );
        }
      } else {
        showError(
          decoded["message"] ?? "Login failed",
        );
      }
    } catch (e) {
      showError(e.toString());
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,

      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Container(
                  height: 115,
                  width: 115,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Image.asset(
                    "assets/gym_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 42),

              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Login to continue managing your gym.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,

                decoration: inputDecoration(
                  hintText: "Enter your email",
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,

                decoration: inputDecoration(
                  hintText: "Enter your password",
                  icon: Icons.lock_outline,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible =
                        !isPasswordVisible;
                      });
                    },

                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},

                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : login,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),

                  child: isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(
                      color:
                      AppColors.textSecondary,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},

                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}