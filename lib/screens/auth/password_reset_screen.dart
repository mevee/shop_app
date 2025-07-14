import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/utils/image_constants.dart';
import 'package:shop_app/widgets/app_logo.dart';
import '../../utils/routes.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  
  @override
  void dispose() {
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        actions: [
          // forgotPasswordBtn(() {
          //   Get.offAllNamed(AppRoutes.login);
          // }),
        ],
      ) ,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo and Title
                  topLogoTagLine(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordBtn(Function() onPressed) {
    return 
        TextButton(
          onPressed: onPressed,
          child: const Text(
            "Forgot Password ?",
            style: TextStyle(
              color: Color(0xFF667eea),
              fontWeight: FontWeight.bold,
            ),
          ),
      
    );
  }

  Column topLogoTagLine() {
    return Column(
      children: [
        AppLogo(
          subtitle: 'Password.',
          assetPath: AppImages.premier,
          iconSize: 100,
          assetColor: Colors.white,
          titleSize: 32.0,
          showBackground: false,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
