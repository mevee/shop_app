import 'package:dio/dio.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/models/shop_master_response.dart';

abstract class ProductServiceProtocol {
  // Future<GetDistanceResponse> addSchedule(AddScheduleRequest request); //d
  Future<ProductMasterListResponse> getProductList(); //d
}

class ProductService extends BaseNetworkClient
    implements ProductServiceProtocol {
  // @override
  // Future<GetDistanceResponse> addSchedule(AddScheduleRequest request) async {
  //   const endPoint = EndPoints.addEmployeeSchedulePOST;
  //   try {
  //     final response = await client.post(endPoint, data: request.toJson());
  //     return GetDistanceResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     // Handle Dio-specific errors
  //     if (e.response != null) {
  //       // You can throw a custom exception or return an error response
  //       throw ServerException(
  //         message: e.response?.data['error'] ?? 'Internal Server Error',
  //         statusCode: e.response?.statusCode ?? 500,
  //       );
  //     } else {
  //       // Other Dio errors (network, timeout, etc.)
  //       throw NetworkException(message: e.message ?? 'Network error occurred');
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  @override
  Future<ProductMasterListResponse> getProductList() async {
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
  Future<ShopMasterListResponse> getShopByName(String query) async {
    var endPoint = EndPoints.shopListSearchGET;
    endPoint = endPoint.replaceAll("{shopName}", query);

    try {
      final response = await client.get(endPoint);
      // final List<ShopMasterResponse> shopList = [];
      // if (response.data is List) {
      //   response.data.forEach((element) {
      //     shopList.add(ShopMasterResponse.fromJson(element));
      //   });
      // }
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
}
