import 'package:get/get.dart';
import 'package:instajobs/models/notification_model.dart';
import 'package:instajobs/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _notificationRepository = NotificationRepository();
  List<NotificationModelDataNotificationsData?>? notifications;
  Future<void> getNotification() async {
    notifications = null;
    final response = await _notificationRepository.getNotificationApi();
    if (response.isSuccess) {
      notifications = response.data?.data?.notifications?.data??[];
    } else {
      notifications = [];
    }
    update();
  }
}