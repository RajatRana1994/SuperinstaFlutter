import 'package:instajobs/models/categoris.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:instajobs/models/feed_model.dart';
import 'package:instajobs/models/feed_tab_model.dart';
import 'package:instajobs/models/forgot_pass.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/popular_service_details_model/popular_services_details_model.dart';
import 'package:instajobs/models/portfolio_model.dart';
import 'package:instajobs/models/subCategory_model.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

import '../models/customer_sign_up_model.dart';
import '../models/login.dart';
import '../network/api_url.dart';
import '../network/network_service.dart';

class FeedRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<FeedTabModel>> getFeedData() async {
    return await _networkService.get<FeedTabModel>(
      path: ApiUrlConstants.feedTabData,
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> getMyFeedData() async {
    print('objectsss');
    final currentLoginUserId = StorageService().getUserData().userId.toString();
    return await _networkService.get<FeedTabModel>(
      path: "${ApiUrlConstants.myFeedTabData}/$currentLoginUserId?page=1&limit=10",
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedDetailModel>> getFeedDetail(String feedId) async {
    return await _networkService.get<FeedDetailModel>(
      path: "feed/$feedId",
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedDetailModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedDetailModel>> sendFeedComment(String feedId, String comment) async {
    return await _networkService.post<FeedDetailModel>(
      path: "feed/comment",
      data: {'feedId': feedId, 'comment': comment},
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedDetailModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ForgotPassModel>> sendFeedReport(String feedId, String comment) async {
    return await _networkService.post<ForgotPassModel>(
      path: "feed/report",
      data: {'feedId': feedId, 'comment': comment},
      converter: (data) {

        // The converter is only called for successful responses now
        return ForgotPassModel.fromJson(data);
      },
    );
  }


  Future<ApiResponse<ForgotPassModel>> sendJobReport(String userId, String reason, String description) async {
    return await _networkService.post<ForgotPassModel>(
      path: "report-user",
      data: {'userId': userId, 'reason': reason, 'description': description, 'blockReasonId': '1' },
      converter: (data) {

        // The converter is only called for successful responses now
        return ForgotPassModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<AppSettingModel>> getAppSetting() async {
    print('objectsss');
    final currentLoginUserId = StorageService().getUserData().userId.toString();
    return await _networkService.get<AppSettingModel>(
      path: "${ApiUrlConstants.appSetting}",
      converter: (data) {
        // The converter is only called for successful responses now
        return AppSettingModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> deleteMyFeed(String feedId) async {
    return await _networkService.delete<FeedTabModel>(
      path: 'feed/$feedId',
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> boostMyFeed(String feedId, String amount) async {
    return await _networkService.post<FeedTabModel>(
      path: 'boost-feeds/$feedId',
      data: {'amount': amount},
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabFavModel>> getFavFeed() async {
    return await _networkService.get<FeedTabFavModel>(
      path: ApiUrlConstants.getSavedFeed,
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabFavModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> saveFeedData(String feedId) async {
    return await _networkService.post<FeedTabModel>(
      path: 'feed/like/$feedId',
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }
}
