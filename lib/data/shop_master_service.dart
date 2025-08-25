import 'package:dio/dio.dart';
import 'package:shop_app/data/common_response.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/data/shop_image_list_response.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_shop_request.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/models/schedule_request.dart';
import 'package:shop_app/models/shop_master_response.dart';

abstract class ShopMasterServiceProtocol {
  Future<CommonModel> addShop(AddShopRequest request); //d
  Future<CommonModel> addShopImage(AddShopImageRequest request); //d
  Future<ShopImageLisResposne> getShopImage(
    String shopMasterId,
    String shopType,
  ); //d
  Future<ProductMasterListResponse> getSkuList(); //d
  Future<ProductMasterListResponse> getSkuListForSchedule(
    String? scheduleId,
  ); //d
  Future<List<ShopMasterModel>> getShopList(); //d
  Future<ShopMasterListResponse> getShopByName(String query);
  Future<ShopMasterListResponse> getWholeSellerName(
    String query,
    String? districtName,
  );
  Future<CommonModel> updateShopLatlong(UpdateShopLatLongRequestst request);
  Future<CommonModel> updateShopWholeSellerLatlong(
    UpdateShopLatLongRequestst request,
  );
}

class ShopMasterService extends BaseNetworkClient
    implements ShopMasterServiceProtocol {
  @override
  Future<CommonModel> addShop(AddShopRequest request) async {
    const endPoint = EndPoints.addSShopPOST;
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
  Future<ProductMasterListResponse> getSkuList() async {
    var endPoint = EndPoints.productListGET;

    try {
      final response = await client.get(endPoint);
      return ProductMasterListResponse.fromJson(response.data);
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
  Future<ProductMasterListResponse> getSkuListForSchedule(
    String? scheduleId,
  ) async {
    var endPoint = EndPoints.productListByScheduleGET;
    endPoint = endPoint.replaceAll('{scheduleId}', scheduleId ?? "");

    try {
      final response = await client.get(endPoint);
      return ProductMasterListResponse.fromJson(response.data);
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
  Future<List<ShopMasterModel>> getShopList() async {
    var endPoint = EndPoints.shopListGET;

    try {
      final response = await client.get(endPoint);
      final List<ShopMasterModel> shopList = [];
      if (response.data is List) {
        response.data.forEach((element) {
          shopList.add(ShopMasterModel.fromJson(element));
        });
      }
      return shopList;
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
  Future<ShopMasterListResponse> getShopByName(String query) async {
    var endPoint = EndPoints.shopListSearchGET;
    endPoint = endPoint.replaceAll("{shopName}", query);
    endPoint = endPoint.replaceAll("{pageSize}", "100");
    endPoint = endPoint.replaceAll("{pageNumber}", "0");

    try {
      final response = await client.get(endPoint);
      return ShopMasterListResponse.fromJson(response.data);
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
  Future<ShopMasterListResponse> getWholeSellerName(
    String query,
    String? districtName,
  ) async {
    var endPoint = EndPoints.shopWholeSaleListSearchGET;
    endPoint = endPoint.replaceAll("{shopName}", query);
    endPoint = endPoint.replaceAll("{districtName}", districtName ?? "");
    endPoint = endPoint.replaceAll("{pageSize}", "100");
    endPoint = endPoint.replaceAll("{pageNumber}", "0");
    try {
      final response = await client.get(endPoint);
      return ShopMasterListResponse.fromJson(response.data);
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
  Future<CommonModel> updateShopLatlong(
    UpdateShopLatLongRequestst request,
  ) async {
    var endPoint = EndPoints.shopUpdateLatLongPOST;
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
  Future<CommonModel> updateShopWholeSellerLatlong(
    UpdateShopLatLongRequestst request,
  ) async {
    var endPoint = EndPoints.shopWholeSaleUpdateLatLongPOST;
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
  Future<CommonModel> addShopImage(AddShopImageRequest request) async {
    var endPoint = EndPoints.addShopPOST;
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
  Future<ShopImageLisResposne> getShopImage(
    String shopMasterId,
    String shopType,
  ) async {
    var endPoint = EndPoints.getShopImagesGET;
    endPoint = endPoint.replaceAll('{shopId}', shopMasterId);
    endPoint = endPoint.replaceAll('{shopType}', shopType);
    try {
      final response = await client.get(endPoint);
      return ShopImageLisResposne.fromJson(response.data);
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
