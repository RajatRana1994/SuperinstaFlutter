import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
  TextEditingController searchController = TextEditingController();
  final HomeTabRepository _homeTabRepository = HomeTabRepository();
  List<CategoriesModelDataCategories?>? categoriesData;
  List<CategoriesModelDataCategories?>? categoriesMainData;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterCategories);
    getCategories();
  }

  Future<void> getCategories() async {
    categoriesData = null;
    categoriesMainData = null;
    final response = await _homeTabRepository.getCategories();
    if (response.isSuccess) {
      categoriesMainData = response.data?.data?.categories ?? [];
      categoriesData = response.data?.data?.categories ?? [];
    } else {
      categoriesMainData = [];
      categoriesData = [];
    }
    update();
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase();

    if (categoriesMainData != null) {
      categoriesData = categoriesMainData!
          .where((cat) =>
      cat != null &&
          cat.name != null &&
          cat.name!.toLowerCase().contains(query))
          .toList();
      update(); // notify listeners
    }
  }
}
