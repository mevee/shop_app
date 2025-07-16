import 'package:dio/dio.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/employee_response.dart';

abstract class EmployeeServiceProtocol {
  Future<GetDistanceResponse> clockIn(ClockRequest request);
  Future<GetDistanceResponse> clockOut(ClockRequest request);
  Future<GetDistanceResponse> employeeRouteUpdate(
    List<UserDateLatRequest> request,
  );
  Future<GetDistanceResponse> getEmployeeTravelDistance(
    GetDistanceRequest request,
  );
  Future<GetDistanceResponse> getEmployeeAttandance(GetDistanceRequest request);
}

class EmployeeService extends BaseNetworkClient
    implements EmployeeServiceProtocol {
  @override
  Future<GetDistanceResponse> clockIn(ClockRequest data) async {
    const endPoint = EndPoints.employeeClockInPOST;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return GetDistanceResponse.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<GetDistanceResponse> clockOut(ClockRequest data) async {
    const endPoint = EndPoints.employeeClockOutPOST;
    try {
      final response = await client.post(endPoint, data: data.toJson());
      return GetDistanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
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
  Future<GetDistanceResponse> employeeRouteUpdate(
    List<UserDateLatRequest> data,
  ) async {
    const endPoint = EndPoints.employeeRouteUpdatePOST;
    try {
      final response = await client.post(endPoint, data: data);
      return GetDistanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
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
  Future<GetDistanceResponse> getEmployeeAttandance(
    GetDistanceRequest request,
  ) async {
    var endPoint = EndPoints.employeeAttendanceGET;
    endPoint = endPoint.replaceAll("{userName}", request.userName ?? "");

    try {
      final response = await client.get(endPoint);
      return GetDistanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
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
  Future<GetDistanceResponse> getEmployeeTravelDistance(GetDistanceRequest request) async {
    var endPoint = EndPoints.employeeDistanceGET;
    endPoint = endPoint.replaceAll("{userName}", request.userName ?? "");
    endPoint = endPoint.replaceAll("{date}", request.date ?? "");

    try {
      final response = await client.get(endPoint);
      return GetDistanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
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

}
