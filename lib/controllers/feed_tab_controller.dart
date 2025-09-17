import 'package:get/get.dart';
import 'package:instajobs/models/feed_tab_model.dart';
import 'package:instajobs/repositories/feed_repository.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:flutter/material.dart';

class FeedTabController extends GetxController with BaseClass {
  FeedRepository feedRepository = FeedRepository();
  List<FeedTabModelDataData?>? feedList;
  List<FeedTabModelDataData?>? feedMyList;
  var feedDetail = Rxn<FeedTabModelDataData>();
  //FeedTabModelDataData? feedDetail;
  List<AppSettingBodyModel>? appSetting;
  List<FeedTabModelFavFeedData?>? feedFavList;
  final TextEditingController commentController = TextEditingController();
  Future<void> getFeedData() async {
    feedList = null;
    final response = await feedRepository.getFeedData();
    if (response.isSuccess) {
      feedList = response.data?.data?.data ?? [];
    } else {
      feedList = [];
    }
    update();
  }

  Future<void> getMyFeedData() async {
    feedMyList = null;
    final response = await feedRepository.getMyFeedData();
    if (response.isSuccess) {
      feedMyList = response.data?.data?.data ?? [];
    } else {
      feedMyList = [];
    }
    update();
  }

  Future<void> getFeedDetail(String feedId) async {
    final response = await feedRepository.getFeedDetail(feedId);
    if (response.isSuccess) {
      feedDetail.value = response.data?.data;
    }
    update();
  }

  Future<void> sendFeedComment(String feedId, String comment) async {
    final response = await feedRepository.sendFeedComment(feedId, comment);
    if (response.isSuccess) {
      commentController.text = '';
      getFeedDetail(feedId);
    }
    update();
  }

  Future<void> reportFeed(String feedId, String comment, BuildContext context) async {
    final response = await feedRepository.sendFeedReport(feedId, comment);
    print('OmPras');
    print(response.isSuccess);
    if (response.isSuccess) {
      showSuccess(title: 'Boost', message: response.data?.message ?? '');
      Navigator.of(context).pop();
    }
    update();
  }

  Future<void> reportUser(String userId, String reason, String description, BuildContext context) async {
    final response = await feedRepository.sendJobReport(userId, reason, description);
    print('OmPras');
    print(response.isSuccess);
    if (response.isSuccess) {
      showSuccess(title: 'Report', message: response.data?.message ?? '');
      Navigator.of(context).pop();
    }
    update();
  }

  Future<void> getAppSetting() async {
    appSetting = null;
    final response = await feedRepository.getAppSetting();
    if (response.isSuccess) {
      appSetting = response.data?.data ?? [];
    } else {
      appSetting = [];
    }
    update();
  }

  Future<void> deleteMyFeed(String id, int index) async {
    final response = await feedRepository.deleteMyFeed(id);
    if (response.isSuccess) {
      feedMyList?.removeAt(index);
    }
    update();
  }

  Future<void> boostMyFeed(String id, String amount) async {
    final response = await feedRepository.boostMyFeed(id, amount);
    print("Raw wrapper message: ${response.message}");
    print("Model message: ${response.data?.message}");
    if (response.isSuccess) {
      showSuccess(title: 'Boost', message: response.data?.message ?? '');
    } else {
      showError(title: 'Boost', message: response.data?.message ?? '');
    }
    update();
  }

  Future<void> getSavedFavData() async {
    feedFavList = null;
    final response = await feedRepository.getFavFeed();
    if (response.isSuccess) {
      feedFavList = response.data?.data?.data ?? [];
    } else {
      feedFavList = [];
    }
    update();
  }

  Future<void> saveFeedData(String feedId, int index, {int type = 0}) async {
    final response = await feedRepository.saveFeedData(feedId);
    if (response.isSuccess) {
      if (type == 1) {
        feedFavList?.removeAt(index);
      } else  if (type == 4) {
        var currentStatu = feedDetail.value?.isLike ?? 0;
        var totalLike = feedDetail.value?.totalLikes ?? 0;
        feedDetail.value?.isLike = (currentStatu == 0) ? 1 : 0;
        feedDetail.value?.totalLikes =
        (currentStatu == 0) ? (totalLike + 1) : (totalLike - 1);
        feedDetail.refresh();

        // 🔥 update list also so previous screen reflects change
        final indexInList = feedList?.indexWhere((e) => e?.id.toString() == feedId);
        if (indexInList != null && indexInList != -1) {
          feedList?[indexInList]?.isLike = feedDetail.value?.isLike;
          feedList?[indexInList]?.totalLikes = feedDetail.value?.totalLikes;
          print('Sham Sunder');
          update();
        }

        // 🔥 update list also so previous screen reflects change
        final indexInList1 = feedMyList?.indexWhere((e) => e?.id.toString() == feedId);
        if (indexInList1 != null && indexInList1 != -1) {
          feedMyList?[indexInList1]?.isLike = feedDetail.value?.isLike;
          feedMyList?[indexInList1]?.totalLikes = feedDetail.value?.totalLikes;
          print('Sham Sunder');
          update();
        }
      } else if (type == 2) {
        var currentStatu = feedMyList?[index]?.isLike ?? 0;
        var totalLike = feedMyList?[index]?.totalLikes ?? 0;
        feedMyList?[index]?.isLike = (currentStatu == 0) ? 1 : 0;
        feedMyList?[index]?.totalLikes =
        (currentStatu == 0) ? (totalLike + 1) : (totalLike - 1);
      }else {
        var currentStatu = feedList?[index]?.isLike ?? 0;
        var totalLike = feedList?[index]?.totalLikes ?? 0;
        feedList?[index]?.isLike = (currentStatu == 0) ? 1 : 0;
        feedList?[index]?.totalLikes =
        (currentStatu == 0) ? (totalLike + 1) : (totalLike - 1);
      }
    }
    update();
  }
}
