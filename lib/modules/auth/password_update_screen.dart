import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app/modules/auth/controllers/auth_controller.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class UpdatePasswordScreen extends GetView<AuthController> {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpacing(24),
                CommonWidgets.text(
                  controller: controller.loginEmailCtr,
                  labelText: 'Enter User',
                  errorMessage: 'Please enter your username',
                  fontSize: 14.0,
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 16),
                CommonWidgets.text(
                  controller: controller.oldPasswordCtr,
                  labelText: 'Old Password',
                  errorMessage: 'Please enter',
                  fontSize: 14.0,
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 16),
                CommonWidgets.text(
                  controller: controller.newPasswordCtr,
                  labelText: 'Enter New Password',
                  errorMessage: 'Please enter your new password',
                  fontSize: 14.0,
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => buttonWithLoader(
                    disable: controller.isUpdatePasswordLoading.value
                        ? true
                        : false,
                    isLoading: controller.isUpdatePasswordLoading.value,
                    context: context,
                    label: "Submit",
                    onPressed: () {
                      controller.updatePassword();
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sendForgotPasswordView({required BuildContext context}) {
    return Column(
      children: [
        CommonWidgets.text(
          controller: controller.fpUserNameCtr,
          labelText: 'Enter User Name',
          errorMessage: 'Please enter user name',
          fontSize: 14.0,
          prefixIcon: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Obx(
          () => buttonWithLoader(
            disable: controller.isSendOtpLoading.value ? true : false,
            isLoading: controller.isSendOtpLoading.value,
            context: context,
            label: "Send OTP",
            onPressed: () {
              controller.sendOtp();
            },
          ),
        ),
      ],
    );
  }

  Widget verifyOtpAndPasswordView({required BuildContext context}) {
    return Column(children: [
        
      ],
    );
  }

  Widget forgotPasswordBtn(Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Color(0xFF667eea), fontWeight: FontWeight.bold),
      ),
    );
  }
}
