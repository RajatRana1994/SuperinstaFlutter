import 'package:get/get.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:instajobs/models/feed_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/portfolio_model.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/repositories/home_tab_repository.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../models/categoris.dart';
import '../models/subCategory_model.dart';

class DirectoryTabController extends GetxController with BaseClass {

  final HomeTabRepository _homeTabRepository = HomeTabRepository();
  List<CategoriesModelDataCategories?>? categoriesData;
  Future<void> getCategories() async {
    categoriesData = null;
    final response = await _homeTabRepository.getCategories();
    if (response.isSuccess) {
      categoriesData = response.data?.data?.categories ?? [];
    } else {
      categoriesData = [];
    }
    update();
  }
}
