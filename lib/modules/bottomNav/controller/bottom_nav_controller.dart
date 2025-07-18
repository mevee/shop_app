import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/models/login_response.dart';

class BotomNavController extends GetxController {
  final SessionPref _userManager = Get.find();
  // final LoginServiceProtocol _authService = Get.find();
  RxBool isLoginButtonLoading = false.obs;
  RxInt currentIndex = 0.obs;

  Rx<LoginResponse> userData = LoginResponse().obs;

  @override
  void onInit() {
    final ApplicationState appState = Get.find();
    super.onInit();
    // loadUserData();
  }

  void loadUserData() {
    userData.value = _userManager.getUserData() ?? LoginResponse();
  }

  // Future<void> requestLogin() async {
  //   if (isLoginButtonLoading.value == true) {
  //     return;
  //   }
  //   if(loginEmailCtr.text.isEmpty || loginPasswordCtr.text.isEmpty) {
  //     formKey.currentState?.validate();
  //     return;
  //   }

  //   isLoginButtonLoading.value = true;
  //   final LoginRequest loginData = LoginRequest(
  //     userName: loginEmailCtr.text,
  //     password: loginPasswordCtr.text,
  //   );
  //   await callDataService<Either<Object, APIResponse<LoginResponse>>>(
  //     _authService.getLoginResponse(loginData),
  //     onSuccess: (value) {
  //       value.fold(
  //         (l) => {isLoginButtonLoading.value = false},
  //         (r) async => {
  //           // await Future.delayed(Duration(seconds: 5)),
  //           isLoginButtonLoading.value = false,
  //           _userManager.setIsUserLoggedIn(true),
  //           _userManager.setUserData(r.response),
  //           _userManager.setUserToken(r.response.token),
  //           _userManager.setUserId(r.response.login?.id.toString()),
  //           ApplicationState().userLoggedIn(),
  //           Get.offAllNamed(Routes.bottomNavigation),
  //         },
  //       );
  //     },
  //     onError: (exception, {statusCode}) {
  //       isLoginButtonLoading.value = false;
  //       if (statusCode == 400) {
  //         AppToast.showToast(message: AppConstants.loginError);
  //       } else {
  //         AppToast.showToast();
  //       }
  //     },
  //   );
  // }

  // Future<void> getForgotPasswordStatus() async {
  //     await callDataService<int>(
  //       _service.forgotPassword(email: forgotPasswordEmailController.text),
  //       onSuccess: (value) {
  //         if (value == 200) {
  //           isForgotPasswordLoading.value = false;
  //           controller.fromForgotPassword.value = true;
  //           newPasswordValue.value = "";
  //           confirmPasswordValue.value = "";
  //           Get.to(const NewPasswordView());
  //           controller.secondsRemaining.value = 120;
  //           controller.startTimer();
  //         }
  //       },
  //       onError: (error, {statusCode}) {
  //         isForgotPasswordLoading.value = false;
  //         if (statusCode == 400) {
  //           AppToast.showToast(message: 'Email not registered');
  //         } else {
  //           AppToast.showToast(message: 'Something went Wrong');
  //         }
  //       },
  //     );
  //   }
  // }
}
