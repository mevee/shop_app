import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;
import 'package:get/get.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/pref/session_pref_impl.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/location_service/permission_helper.dart';
import 'package:shop_app/logic/block/auth/auth_state.dart';
import 'package:shop_app/logic/block/auth/login_bloc.dart';
import 'package:shop_app/logic/block/auth/login_event.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/utils/image_constants.dart';
import 'package:shop_app/widgets/app_logo.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final loginEmailCtr = TextEditingController(text: "");
  final loginPasswordCtr = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, AuthState>(
        listener: (context, state) {
          if (state is Failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text((state as Failure).message)));
          }
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, "/home");
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(color: AppColors.cherryRed),
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
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets.text(
                                controller: loginEmailCtr,
                                labelText: 'Enter Email',
                                errorMessage: 'Please enter your email',
                                fontSize: 14.0,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CommonWidgets.text(
                                controller: loginPasswordCtr,
                                labelText: 'Enter Password',
                                errorMessage: 'Please enter your password',
                                fontSize: 14.0,
                                isPassword: state.passVisible ? false : true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                tailfixIcon: InkWell(
                                  onTap: () {
                                    state.passVisible = !state.passVisible;
                                  },
                                  child: Icon(
                                    state.passVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              forgotPasswordBtn(() {
                                // controller.forgetPasswordView();
                                Get.toNamed(Routes.passwordReset);
                                // Get.pushNamed(context, Routes.passwordReset);
                                // Navigate when login is successful
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (_) => const HomePage()),
                                // );
                              }),
                              Row(
                                children: [
                                  CheckboxTheme(
                                    data: CheckboxThemeData(
                                      side: BorderSide(
                                        color: Colors.white,
                                      ), // Border color
                                      // Other checkbox styling
                                    ),

                                    child: Checkbox(
                                      value: state.remember,
                                      onChanged: (togle) {
                                        state.remember = !state.remember;
                                      },
                                      fillColor:
                                          WidgetStateProperty.resolveWith<
                                            Color
                                          >((states) {
                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return Colors
                                                  .white; // Fill color when checked
                                            }
                                            return Colors
                                                .transparent; // Fill color when unchecked
                                          }),
                                      checkColor: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Remember',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              buttonWithLoader(
                                disable: state is LoginLoading ? true : false,
                                isLoading: state is LoginLoading,
                                context: context,
                                label: "LOGIN",
                                onPressed: () async {
                                  final p1 =
                                      await PermissionUtil.notificationPermissionCheck();
                                  final loc =
                                      await PermissionUtil.locationPermissionCheck();
                                  final locService =
                                      await PermissionUtil.checkLocationServiceEnabled();
                                  aLog("$locService");
                                  if (p1 && loc && locService) {
                                    context.read<LoginBloc>().add(
                                      LoginButtonPressed(
                                        email: loginEmailCtr.text,
                                        password: loginPasswordCtr.text,
                                      ),
                                    );
                                  }
                                },
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
          );
        },
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
        GestureDetector(
          onTap: () async {
            final userManager = SPrefSessiomImpl();
            userManager.initPreferences();
            final userData = userManager.getUserData();
            AppToast.showToast(
              message: "User: ${userData?.login?.userName ?? 'Unknown'}",
            );
          },
          child: AppLogo(
            subtitle: 'Welcome back.',
            assetPath: AppImages.premier,
            iconSize: 200,
            assetColor: Colors.white,
            titleSize: 32.0,
            showBackground: false,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
