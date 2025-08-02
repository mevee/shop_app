import 'package:dio/dio.dart';
import 'package:shop_app/data/common_response.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_schedule_request.dart';
import 'package:shop_app/models/schedule_detail_request.dart';
import 'package:shop_app/models/schedule_detail_response.dart';
import 'package:shop_app/models/schedule_image_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/schedule_qty_response.dart';
import 'package:shop_app/models/shop_prodlisr_response.dart';
import 'package:shop_app/models/schedule_request.dart';

abstract class ScheduleServiceProtocol {
  Future<CommonModel> addSchedule(AddScheduleRequest request); //d
  Future<CommonModel> updateSchedule(UpdateScheduleRequest request); //d
  Future<CommonModel> cancelSchedule(UpdateScheduleRequest request); //d
  Future<CommonModel> addScheduleDetail(UpdateScheduleRequest request); //d
  Future<CommonModel> checkUserAtShopLocation(
    CheckUserAtShopRequest request,
  ); //d

  Future<ScheduleListResponse> getScheduleByMonth(String? month);

  Future<ScheduleListResponse> getScheduleByDate(String? date);

  Future<ShopProductResponse> getProductDetails(); //d

  Future<ScheduleDetailResponse> getScheduleDetails(String? scheduleId); //d
  Future<ScheduleImageResponse> getScheduleImages(String? scheduleId); //d
  Future<ScheduleQtyResponse> getScheduleQuantity(String? scheduleId); //d
}

class ScheduleService extends BaseNetworkClient
    implements ScheduleServiceProtocol {
  @override
  Future<CommonModel> addSchedule(AddScheduleRequest request) async {
    const endPoint = EndPoints.addEmployeeSchedulePOST;
    try {
      final response = await client.post(endPoint, data: request.toJson());
      return CommonModel.fromJson(response.data);
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
  Future<CommonModel> updateSchedule(UpdateScheduleRequest request) async {
    const endPoint = EndPoints.addEmployeeScheduleDetailPOST;
    try {
      final response = await client.post(endPoint, data: request.toJson());
      return CommonModel.fromJson(response.data);
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
  Future<CommonModel> cancelSchedule(UpdateScheduleRequest request) async {
    const endPoint = EndPoints.cancelScheduleDetailPOST;
    try {
      final response = await client.post(endPoint, data: request.toJson());
      return CommonModel.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errorsr
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
  Future<CommonModel> addScheduleDetail(UpdateScheduleRequest request) async {
    const endPoint = EndPoints.addEmployeeScheduleDetailPOST;
    try {
      final response = await client.post(endPoint, data: request.toJson());
      return CommonModel.fromJson(response.data);
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
  Future<ScheduleListResponse> getScheduleByMonth(String? date) async {
    var endPoint = EndPoints.employeeSchuleByMonthGET;
    endPoint = endPoint.replaceAll("{date}", date ?? "");
    try {
      final response = await client.get(endPoint);
      return ScheduleListResponse.fromJson(response.data);
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
  Future<ScheduleListResponse> getScheduleByDate(String? date) async {
    var endPoint = EndPoints.employeeSchuleByDateGET;
    endPoint = endPoint.replaceAll("{date}", date ?? "");
    try {
      final response = await client.get(endPoint);
      return ScheduleListResponse.fromJson(response.data);
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
  Future<ShopProductResponse> getProductDetails() async {
    var endPoint = EndPoints.productListByScheduleGET;
    try {
      final response = await client.get(endPoint);
      return ShopProductResponse.fromJson(response.data);
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
  Future<ScheduleDetailResponse> getScheduleDetails(String? scheduleId) async {
    var endPoint = EndPoints.employeeSchuleDetailsGET;
    endPoint = endPoint.replaceAll("{scheduleId}", scheduleId ?? "");
    try {
      final response = await client.get(endPoint);
      return ScheduleDetailResponse.fromJson(response.data);
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
  Future<ScheduleQtyResponse> getScheduleQuantity(String? scheduleId) async {
    var endPoint = EndPoints.employeeSchuleQtyGET;
    endPoint = endPoint.replaceAll("{scheduleId}", scheduleId ?? "");

    try {
      final response = await client.get(endPoint);
      return ScheduleQtyResponse.fromJson(response.data);
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
  Future<ScheduleImageResponse> getScheduleImages(String? scheduleId) async {
    var endPoint = EndPoints.employeeSchuleImagesGET;
    endPoint = endPoint.replaceAll("{scheduleId}", scheduleId ?? "");
    try {
      final response = await client.get(endPoint);
      return ScheduleImageResponse.fromJson(response.data);
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
  Future<CommonModel> checkUserAtShopLocation(
    CheckUserAtShopRequest request,
  ) async {
    var endPoint = EndPoints.checkEmployeeAtShopLocationGET;
    endPoint = endPoint.replaceAll(
      "{scheduleId}",
      request.scheduleId?.toString() ?? "",
    );
    endPoint = endPoint.replaceAll("{lat}", request.lat ?? "");
    endPoint = endPoint.replaceAll("{long}", request.long ?? "");
    try {
      final response = await client.get(endPoint);
      return CommonModel.fromJson(response.data);
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
