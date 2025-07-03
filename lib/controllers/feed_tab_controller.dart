import 'package:get/get.dart';
import 'package:instajobs/models/feed_tab_model.dart';
import 'package:instajobs/repositories/feed_repository.dart';

class FeedTabController extends GetxController {
  FeedRepository feedRepository = FeedRepository();
  List<FeedTabModelDataData?>? feedList;
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
}