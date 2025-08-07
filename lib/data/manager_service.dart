import 'package:dio/dio.dart';
import 'package:shop_app/data/common_response.dart';
import 'package:shop_app/data/network/api_endpoint.dart';
import 'package:shop_app/data/network/base_network_client.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/agent_list_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/schedule_request.dart';

abstract class ManagerServiceProtocol {
  Future<AgentListResponse> getAgentList(); //d
  Future<CommonModel> updateAuthorizeSchedule(AuthorizeRequest request);
  Future<ScheduleListResponse> getScheduleByAgent(
    String? agentName,
    String? date,
  );
    Future<AgentAddressResponse> getAgentLastLocation(String? agent,String? dateTime);

}

class ManagerService extends BaseNetworkClient
    implements ManagerServiceProtocol {
  @override
  Future<AgentListResponse> getAgentList() async {
    var endPoint = EndPoints.agentListGET;
    try {
      final response = await client.get(endPoint);
      return AgentListResponse.fromJson(response.data);
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
  Future<AgentAddressResponse> getAgentLastLocation(String? agent,String? dateTime) async {
    var endPoint = EndPoints.getAgentAddressGET;
    endPoint = endPoint.replaceAll("{agentId}", agent??"");
    endPoint = endPoint.replaceAll("{dateTime}", dateTime??"");
    try {
      final response = await client.get(endPoint);
      return AgentAddressResponse.fromJson(response.data);
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
  Future<CommonModel> updateAuthorizeSchedule(AuthorizeRequest request) async {
    const endPoint = EndPoints.authorizeSchedulePOST;
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
  Future<ScheduleListResponse> getScheduleByAgent(
    String? agentName,
    String? date,
  ) async {
    var endPoint = EndPoints.allScheduleByAgentGET;
    endPoint = endPoint.replaceAll("{userName}", agentName ?? "");
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
}
