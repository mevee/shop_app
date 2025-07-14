// import 'dart:convert';

// import 'package:digilawyer/app/data/service/model/feedback_request.dart';
// import 'package:digilawyer/app/network/api_endpoint.dart';
// import 'package:digilawyer/app/network/base_network_client.dart';

// import 'model/chat_by_id_response.dart';

// abstract class ChatServiceProtocol {
//   Future<int> pinnedChat(String chatId, bool isPinned);
//   Future<int> updateChatLabel(String chatId, String label);
//   Future<int> shareChat(String chatId);
//   Future<int> submitFeedback(FeedbackRequest feedbackRequest, String chatId,
//       String conversationId, String responseId);
//   Future<ChatByIdResponse> getChatById(
//       String chatId, Map<String, dynamic> query);
// }

// class ChatService extends BaseNetworkClient implements ChatServiceProtocol {
//   @override
//   Future<int> pinnedChat(String chatId, bool isPinned) async {
//     final endPoint =
//         EndPoints.archivePinnedChats.replaceAll('{chat_id}', chatId);
//     final body = {"pinned": isPinned};
//     try {
//       final response = await client.patch(endPoint, data: jsonEncode(body));
//       return response.statusCode ?? 400;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   @override
//   Future<int> updateChatLabel(String chatId, String label) async {
//     final endPoint =
//         EndPoints.archivePinnedChats.replaceAll('{chat_id}', chatId);
//     final body = {"label": label};
//     try {
//       final response = await client.patch(endPoint, data: jsonEncode(body));
//       return response.statusCode ?? 400;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   @override
//   Future<int> shareChat(String chatId) async {
//     final Map<String, dynamic> query = {"chatId": chatId};
//     final body = {"chatId": chatId, "isAnonymous": true};
//     const endPoint = EndPoints.shareChat;
//     try {
//       final response = await client.post(endPoint,
//           queryParameters: query, data: jsonEncode(body));
//       return response.statusCode ?? 400;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   @override
//   Future<int> submitFeedback(FeedbackRequest feedbackRequest, String chatId,
//       String conversationId, String responseId) async {
//     final endPoint = EndPoints.submitResponseFeedback
//         .replaceAll("{chat_id}", chatId)
//         .replaceAll("{conversation_id}", conversationId)
//         .replaceAll("{message_id}", responseId);
//     try {
//       final response =
//           await client.patch(endPoint, data: feedbackRequest.toJson());
//       return response.statusCode ?? 400;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ChatByIdResponse> getChatById(
//       String chatId, Map<String, dynamic> query) async {
//     final endPoint = EndPoints.chatById.replaceAll('{chat_id}', chatId);
//     try {
//       final response = await client.get(endPoint, queryParameters: query);
//       return ChatByIdResponse.fromJson(response.data);
//     } catch (error) {
//       rethrow;
//     }
//   }
// }
