import 'package:instajobs/models/notification_model.dart';

import '../network/network_service.dart';

class NotificationRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<NotificationModel>> getNotificationApi() async {
    return await _networkService.get<NotificationModel>(
      path: 'notifications?limit=50&page=1',
      converter: (data) {
        // The converter is only called for successful responses now
        return NotificationModel.fromJson(data);
      },
    );
  }
}