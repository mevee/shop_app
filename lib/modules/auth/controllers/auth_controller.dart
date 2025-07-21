import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as ConnectivityResult;
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/data/common_response.dart';
import 'package:shop_app/data/login_service.dart';
import 'package:shop_app/data/network/api_caller.dart';
import 'package:shop_app/data/network/network_interceptor.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  final SessionPref _userManager = Get.find();
  final LoginServiceProtocol _authService = Get.find();

  final formKey = GlobalKey<FormState>();
  final loginEmailCtr = TextEditingController(text: "");
  final loginPasswordCtr = TextEditingController(text: "");

  final fpUserNameCtr = TextEditingController(text: "ddd");
  final otpCtr = TextEditingController(text: "");
  final newPasswordCtr = TextEditingController(text: "");

  final oldPasswordCtr = TextEditingController(text: "");

  final RxString emailValue = "".obs;
  final RxString passwordValue = "".obs;
  final RxBool isObscureNewPassword = true.obs;
  RxBool isLoginActive = false.obs;
  RxBool isLoginButtonLoading = false.obs;

  RxBool otpSendView = true.obs;

  RxBool isSendOtpLoading = false.obs;

  // RxBool otpSendView = true.obs;
  RxBool updatePasswordViewVisible = false.obs;
  RxBool isUpdatePasswordLoading = false.obs;
  String? uniqueKey;

  void forgetPasswordView() {
    otpSendView.value = true;
    isSendOtpLoading.value = false;
    isUpdatePasswordLoading.value = false;
    updatePasswordViewVisible.value = false;
    fpUserNameCtr.clear();
    otpCtr.clear();
    newPasswordCtr.clear();
    uniqueKey = null;
  }

  @override
  void onInit() {
    // final ApplicationState appState = Get.find();
    super.onInit();
  }

  void isLoginButtonActive() {
    if (loginEmailCtr.text.isValidEmail() &&
        loginPasswordCtr.text.isNotEmptyAndNotNull) {
      isLoginActive.value = true;
    } else {
      isLoginActive.value = false;
    }
  }

  Future<void> requestLogin() async {
    if (isLoginButtonLoading.value == true) {
      return;
    }
    if (loginEmailCtr.text.isEmpty || loginPasswordCtr.text.isEmpty) {
      formKey.currentState?.validate();
      return;
    }

    isLoginButtonLoading.value = true;
    final LoginRequest loginData = LoginRequest(
      userName: loginEmailCtr.text,
      password: loginPasswordCtr.text,
    );
    await callDataService<Either<Object, APIResponse<LoginResponse>>>(
      _authService.getLoginResponse(loginData),
      onSuccess: (value) {
        value.fold(
          (l) => {isLoginButtonLoading.value = false},
          (r) async => {
            // await Future.delayed(Duration(seconds: 5)),
            isLoginButtonLoading.value = false,
            _userManager.setIsUserLoggedIn(true),
            _userManager.setUserData(r.response),
            _userManager.setUserToken(r.response.token),
            _userManager.setUserId(r.response.login?.id.toString()),
            ApplicationState().userLoggedIn(),
            Get.offAllNamed(Routes.bottomNavigation),
          },
        );
      },
      onError: (exception, {statusCode}) {
        isLoginButtonLoading.value = false;
        if (statusCode == 400) {
          AppToast.showToast(message: AppConstants.loginError);
        } else {
          AppToast.showToast();
        }
      },
    );
  }

  Future<void> sendOtp() async {
    if (isSendOtpLoading.value == true) {
      return;
    }

    if (fpUserNameCtr.text.isEmpty) {
      AppToast.showToast(message: "Please enter user name");
      return;
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      AppToast.showToast(message: NetworkAPIServicesString.noInternetMessgae);
      return;
    }
    isSendOtpLoading.value = true;
    final ForgotPasswordRequest request = ForgotPasswordRequest(
      userName: fpUserNameCtr.text,
      purpose: "Forget Password",
    );
    try {
      final response = await _authService.forgotPasswordSendOtp(request);
      otpSendView.value = false;
      updatePasswordViewVisible.value = true;
      if (response.results != null && response.results!.isNotEmpty) {
        uniqueKey = response.results!.first;
      }
      AppToast.showToast(
        message: response.responseCode ?? "OTP sent successfully",
        // toastType:ToastType.success, // Assuming you have different toast types
      );
    } on DioException catch (e) {
      isSendOtpLoading.value = false;
      _handleOtpError(e);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to send OTP");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to send OTP");
    } catch (e) {
      AppToast.showToast(message: "Failed to send OTP");
    } finally {
      isSendOtpLoading.value = false;
    }
  }

  void _handleOtpError(Exception exception) {
    String errorMessage = "";

    if (exception is DioException) {
      errorMessage =
          exception.response?.data['error'] ??
          "Something went wrong. Please try again later.";
      // Log specific server errors if needed
      // debugPrint("Server error (${exception.statusCode}): ${exception.message}");
    }
    if (exception is ServerException) {
      errorMessage = _getServerErrorMessage(exception);
      // Log specific server errors if needed
      // debugPrint("Server error (${exception.statusCode}): ${exception.message}");
    } else if (exception is NetworkException) {
      errorMessage = "Network error: ${exception.message}";
    } else {
      errorMessage = "Something went wrong. Please try again later.";
      // Consider logging unexpected errors
      // debugPrint("Unexpected error: $exception");
    }

    AppToast.showToast(
      message: errorMessage,
      // toastType: ToastType.error,
    );
  }

  String _getServerErrorMessage(ServerException exception) {
    switch (exception.statusCode) {
      case 400:
        return "Invalid username format";
      case 404:
        return "Username not found";
      case 429:
        return "Too many attempts. Please try again later";
      case 500:
        return "Server error. Please try again";
      default:
        return exception.message ?? "Something went wrong";
    }
  }

  Future<void> verifyOtpAndPassword() async {
    if (isUpdatePasswordLoading.value == true) {
      return;
    }

    if (otpCtr.text.isEmpty) {
      AppToast.showToast(message: "Please enter OTP");
      return;
    }
    if (newPasswordCtr.text.isEmpty) {
      AppToast.showToast(message: "Please enter new password");
      return;
    }
    isUpdatePasswordLoading.value = true;
    final VerifyOtpAndNewPassowrdRequest loginData =
        VerifyOtpAndNewPassowrdRequest(
          otp: otpCtr.text,
          newPassword: newPasswordCtr.text,
          uniqueId: uniqueKey,
        );
    try {
      CommonResponse response = await _authService.verifyOtpAndChangePassword(
        loginData,
      );
      if (response.responseCode?.toLowerCase() ==
          "Otp Verification failed".toLowerCase()) {
        AppToast.showToast(
          message: response.responseCode ?? "Otp Verification failed",
        );
      } else {
        isSendOtpLoading.value = false;
        otpSendView.value = false;
        isUpdatePasswordLoading.value = true;
        updatePasswordViewVisible.value = true;
        isUpdatePasswordLoading.value = false;
        // fpUserNameCtr.clear();
        AppToast.showToast(
          message: response.responseCode ?? "Password updated successfully",
        );
        forgetPasswordView();
        loginEmailCtr.text = "";
        loginPasswordCtr.text = "";
        Get.offAllNamed(Routes.login);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to update password";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isUpdatePasswordLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (isUpdatePasswordLoading.value == true) {
      return;
    }

    if (loginEmailCtr.text.isEmpty) {
      AppToast.showToast(message: "Please enter user name");
      return;
    }
    if (oldPasswordCtr.text.isEmpty) {
      AppToast.showToast(message: "Please enter old password");
      return;
    }
    if (newPasswordCtr.text.isEmpty) {
      AppToast.showToast(message: "Please enter new password");
      return;
    }
    isUpdatePasswordLoading.value = true;
    final ChangePasswordRequest loginData = ChangePasswordRequest(
      userName: _userManager.getUserData()?.login?.userName,
      newPassword: newPasswordCtr.text,
      oldPassword: oldPasswordCtr.text,
    );
    try {
      CommonResponse response = await _authService.changePassword(loginData);
      if (response.responseCode?.toLowerCase() ==
          "Otp Verification failed".toLowerCase()) {
        AppToast.showToast(
          message: response.responseCode ?? "Otp Verification failed",
        );
      } else {
        isSendOtpLoading.value = false;
        otpSendView.value = false;
        isUpdatePasswordLoading.value = true;
        updatePasswordViewVisible.value = true;
        isUpdatePasswordLoading.value = false;
        // fpUserNameCtr.clear();
        AppToast.showToast(
          message: response.responseCode ?? "Password updated successfully",
        );
        forgetPasswordView();
        loginEmailCtr.text = "";
        loginPasswordCtr.text = "";
        Get.offAllNamed(Routes.login);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to update password";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      AppToast.showToast();
    } finally {
      isUpdatePasswordLoading.value = false;
    }
  }

  void moveToNextScreen() {
    Get.offAllNamed(Routes.login);
  }
}
