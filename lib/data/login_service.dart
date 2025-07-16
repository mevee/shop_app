import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shop_app/data/common_api_response.dart';
import 'package:shop_app/data/common_response.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/login_response.dart';

abstract class LoginServiceProtocol {
  Future<Either<Object, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  );
  Future<CommonResponse> forgotPasswordSendOtp(ForgotPasswordRequest request);

  Future<CommonResponse> verifyOtpAndChangePassword(VerifyOtpAndNewPassowrdRequest request);

  Future<CommonResponse> changePassword(ChangePasswordRequest request);

  // Future<Either<Object, APIResponse<LoginResponse>>> getGoogleLoginResponse(
  //     Map<String, dynamic> data);
}

class LoginService extends BaseNetworkClient implements LoginServiceProtocol {
  @override
  Future<Either<Object, APIResponse<LoginResponse>>> getLoginResponse(
    LoginRequest data,
  ) async {
    const endPoint = EndPoints.login;
    // const endPoint = "${AppConstants.host}/${EndPoints.login}";

    try {
      final response = await client.post(
        endPoint,
        data: data.toJson(),
      );
      final loginData = response.data;
      print(loginData);
      return Either.right(
        APIResponse(
          response: LoginResponse.fromJson(response.data),
          statusCode: response.statusCode ?? 400,
          accessToken: response.toString(),
          userId: response.toString(),
          // accessToken: response.headers['x-access-token']?.first ?? "",
          // userId: response.headers['x-userId']?.first ?? "",
        ),
      );
    } catch (error) {
      rethrow;
    }
  }


@override
  Future<CommonResponse> forgotPasswordSendOtp(
    ForgotPasswordRequest data,
  ) async {
    const endPoint = EndPoints.forgotPasswordAndSendOtp;
    try {
      final response = await client.post(
        endPoint,
        data: data.toJson(),
      );
      return  CommonResponse.fromJson(response.data);
    } on DioException catch (e) {
    // Handle Dio-specific errors
    if (e.response != null) {
      // Server responded with an error status code (like 500)
      print('Error status code: ${e.response?.statusCode}');
      print('Error response data: ${e.response?.data}');
    
      // You can throw a custom exception or return an error response
      throw ServerException(
        message: e.response?.data['error'] ?? 'Internal Server Error',
        statusCode: e.response?.statusCode ?? 500,
      );
    } else {
      // Other Dio errors (network, timeout, etc.)
      throw NetworkException(message: e.message ?? 'Network error occurred');
    }
  } catch (error) {
      rethrow;
    }
  }



@override
  Future<CommonResponse> verifyOtpAndChangePassword(
    VerifyOtpAndNewPassowrdRequest data,
  ) async {
    const endPoint = EndPoints.verifyOtpAndPassword;
    try {
      final response = await client.post(
        endPoint,
        data: data.toJson(),
      );
      return  CommonResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }
  
  
@override
  Future<CommonResponse> changePassword(
    ChangePasswordRequest data,
  ) async {
    const endPoint = EndPoints.verifyOtpAndPassword;
    try {
      final response = await client.post(
        endPoint,
        data: data.toJson(),
      );
      return  CommonResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }
  // @override
  // Future<Either<Object, APIResponse<LoginResponse>>> getGoogleLoginResponse(
  //     Map<String, dynamic> data) async {
  //   const endPoint = EndPoints.login;
  //   try {
  //     final response = await client.post(
  //       endPoint,
  //       data: data,
  //     );
  //     return Either.right(APIResponse(
  //       response: LoginResponse.fromJson(response.data),
  //       statusCode: response.statusCode ?? 400,
  //       accessToken: response.headers['x-access-token']?.first ?? "",
  //       userId: response.headers['x-userId']?.first ?? "",
  //     ));
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<int> forgotPassword({required String email}) async {
  //   const endPoint = EndPoints.forgotPassword;
  //   final Map<String, String> requestBody = {"email": email};
  //   try {
  //     final response =
  //         await client.patch(endPoint, data: jsonEncode(requestBody));
  //     return response.statusCode ?? 400;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<UserCredential> signInWithGoogle() async {
  //   await GoogleSignIn().signOut();

  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   if (googleUser == null) {
  //     throw Exception('Google Sign-In was canceled');
  //   }
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
}
