import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/utils/image_constants.dart';
import 'package:shop_app/utils/routes.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
     _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Navigate to login screen after delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(
                subtitle: 'Your Ultimate Shopping Companion',
                assetPath: AppImages.premier,
                assetColor: Colors.white,
                showBackground: false,
              ),
              const SizedBox(height: 40),
              const LoadingIndicator(
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 