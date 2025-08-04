import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/auth/controllers/auth_controller.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/utils/image_constants.dart';
import 'package:shop_app/widgets/app_logo.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.cherryRed,
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
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets.text(
                            controller: controller.loginEmailCtr,
                            labelText: 'Enter Email',
                            errorMessage: 'Please enter your email',
                            fontSize: 14.0,
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => CommonWidgets.text(
                              controller: controller.loginPasswordCtr,
                              labelText: 'Enter Password',
                              errorMessage: 'Please enter your password',
                              fontSize: 14.0,
                              isPassword: controller.passVisible.value
                                  ? false
                                  : true,
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                              tailfixIcon: InkWell(
                                onTap: () {
                                  controller.passVisible.value =
                                      !controller.passVisible.value;
                                },
                                child: Icon(
                                  controller.passVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          forgotPasswordBtn(() {
                            controller.forgetPasswordView();
                            Get.toNamed(Routes.passwordReset);
                          }),
                          const SizedBox(height: 8),
                          Obx(
                            () => buttonWithLoader(
                              disable: controller.isLoginButtonLoading.value
                                  ? true
                                  : false,
                              isLoading: controller.isLoginButtonLoading.value,
                              context: context,
                              label: "LOGIN",
                              onPressed: () {
                                controller.requestLogin();
                              },
                            ),
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
          iconSize: 200,
          assetColor: Colors.white,
          titleSize: 32.0,
          showBackground: false,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
