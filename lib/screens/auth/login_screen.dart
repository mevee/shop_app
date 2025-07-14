import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/utils/image_constants.dart';
import 'package:shop_app/widgets/app_logo.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import '../../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // if (_formKey.currentState!.validate()) {
      print('Login: ${_emailController.text}');
      Get.offAllNamed(AppRoutes.home);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  topLogoTagLine(),
                  Container(
                    padding: const EdgeInsets.all(24),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(20),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.1),
                    //       blurRadius: 20,
                    //       offset: const Offset(0, 10),
                    //     ),
                    //   ],
                    // ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets.text(
                            controller: _emailController,
                            labelText: 'Enter Email',
                            errorMessage: 'Please enter your email',
                            fontSize: 14.0,
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          CommonWidgets.text(
                            controller: _passwordController,
                            labelText: 'Enter Password',
                            errorMessage: 'Please enter your password',
                            fontSize: 14.0,
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                          ),
                          forgotPasswordBtn(() {
                            Get.toNamed(AppRoutes.forgotPassword);
                          }),
                          const SizedBox(height: 8),
                          CommonWidgets.button(
                            lable: 'LOGIN',
                            onPressed: _login,
                            color: Colors.white,
                            textColor: Colors.deepPurpleAccent,
                          ),
                           
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordBtn(Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        "Forgot Password ?",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Column topLogoTagLine() {
    return Column(
      children: [
        AppLogo(
          subtitle: 'Welcome back.',
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
