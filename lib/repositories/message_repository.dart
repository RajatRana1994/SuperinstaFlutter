import 'package:instajobs/models/forgot_pass.dart';
import 'package:instajobs/models/message_data/message_model.dart';

import '../network/network_service.dart';
import 'package:instajobs/models/message_data/inbox_model.dart';

class MessageRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<InboxModel>> getInboxMessage() async {
    return await _networkService.get<InboxModel>(
      path: 'chats/last',
      converter: (data) => InboxModel.fromJson(data),
    );
  }

  Future<ApiResponse<MessageModel>> getChatList({String? page, String? limit, String? chatId}) async {
    return await _networkService.get<MessageModel>(
      path: 'chats/$chatId?page=$page&limit=$limit',
      converter: (data) => MessageModel.fromJson(data),
    );
  }


  Future<ApiResponse<ForgotPassModel>> sendMessageFromInbox({String? chatId, String? friendId, String? message}) async {
    return await _networkService.post<ForgotPassModel>(
      path: 'chats/send/$chatId',
      data: {'friendId': friendId, 'messageType': '0', 'message': message},
      converter: (data) => ForgotPassModel.fromJson(data),
    );
  }

  Future<ApiResponse<ForgotPassModel>> sendMessageFromOffer({String? chatId, String? friendId, String? message}) async {
    return await _networkService.post<ForgotPassModel>(
      path: 'chats/offer/send/$chatId',
      data: {'friendId': friendId, 'messageType': '0', 'message': message},
      converter: (data) => ForgotPassModel.fromJson(data),
    );
  }

  Future<ApiResponse<ForgotPassModel>> sendMessageFromBooking({String? chatId, String? friendId, String? message}) async {
    return await _networkService.post<ForgotPassModel>(
      path: 'chats/booking/send/$chatId',
      data: {'friendId': friendId, 'messageType': '0', 'message': message},
      converter: (data) => ForgotPassModel.fromJson(data),
    );
  }

  Future<ApiResponse<MessageModel>> getChatListBooking({String? page, String? limit, String? friendId, String? bookingId, String? type}) async {
    return await _networkService.get<MessageModel>(
      path: 'chats?page=$page&limit=$limit&friendId=$friendId&$type=$bookingId',
      converter: (data) => MessageModel.fromJson(data),
    );
  }
}