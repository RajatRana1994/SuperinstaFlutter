import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:instajobs/models/message_data/inbox_model.dart';
import 'package:instajobs/controllers/message/message_controller.dart';
import 'package:instajobs/models/message_data/message_model.dart';
import 'package:instajobs/repositories/message_repository.dart';

class MessageController extends GetxController {
  final MessageRepository _myMessageRepository = MessageRepository();
  var inboxArray = <InboxLastMessageModel>[].obs;
  var messageArray = <MessageMainModel>[].obs;
  var hasMore = true.obs;

  Future<void> getInboxData() async {
    inboxArray.clear();
    final response = await _myMessageRepository.getInboxMessage();
    if (response.isSuccess) {
      inboxArray.value = response.data?.data?.data ?? [];
    } else {
      inboxArray.clear();
    }
    update();
  }

  Future<void> getChatList(
      String chatId, {
        int page = 1,
        int limit = 10,
      }) async {
    final response = await _myMessageRepository.getChatList(
      page: page.toString(),
      limit: limit.toString(),
      chatId: chatId,
    );

    if (response.isSuccess) {
      final newMessages = (response.data?.data?.data ?? []).reversed.toList();
      if (newMessages.length != limit) {
        hasMore.value = false;
      } else {
        hasMore.value = true;
      }
      if (page == 1) {
        // first page, replace
        messageArray.value = newMessages;
      } else {
        // append older messages at the beginning
        messageArray.addAll(newMessages);
      }
    }
    update();
  }

  Future<void> senMessageFromInbox( String chatId, String friendId,String message) async {
    final response = await _myMessageRepository.sendMessageFromInbox(chatId: chatId, friendId: friendId, message: message);

    if (response.isSuccess) {

    }
    update();
  }


  Future<void> senMessageFromOffer( String chatId, String friendId,String message) async {
    final response = await _myMessageRepository.sendMessageFromOffer(chatId: chatId, friendId: friendId, message: message);

    if (response.isSuccess) {

    }
    update();
  }

  Future<void> senMessageFromBooking( String chatId, String friendId,String message) async {
    final response = await _myMessageRepository.sendMessageFromBooking(chatId: chatId, friendId: friendId, message: message);

    if (response.isSuccess) {

    }
    update();
  }

  Future<void> getChatListBooking(
      String bookingId,
      String type,
      String friendId,
      {
        int page = 1,
        int limit = 10,
      }) async {
    final response = await _myMessageRepository.getChatListBooking(
        page: page.toString(),
        limit: limit.toString(),
        bookingId: bookingId,
        type: type,
        friendId: friendId
    );

    if (response.isSuccess) {
      final newMessages = (response.data?.data?.data ?? []).reversed.toList();
      if (newMessages.length != limit) {
        hasMore.value = false;
      } else {
        hasMore.value = true;
      }
      if (page == 1) {
        // first page, replace
        messageArray.value = newMessages;
      } else {
        // append older messages at the beginning
        messageArray.addAll(newMessages);
      }
    }
    update();
  }
}
