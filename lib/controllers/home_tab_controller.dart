import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:instajobs/models/feed_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/popular_service_details_model/popular_services_details_model.dart';
import 'package:instajobs/models/portfolio_model.dart';
import 'package:instajobs/models/services_users_model.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/repositories/home_tab_repository.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../models/categoris.dart';
import '../models/subCategory_model.dart';

class HomeTabController extends GetxController with BaseClass {

  CustomerHomeModelData? customerHomeModel;
  List<PopularServiceDetailsMoelDataData?>? popularServiceDetailsModel;
  List<SubCategoryModelDataSubCategories?>? subCategoriesData;
  List<SubCategoryModelDataSubCategories?>? subMainCategoriesData;
  List<ServicesUsersModel?>? usersPopularServicesList;
  VendorDetailsModelData? vendorDetailsModel;
  PortfilioModelData? portfolioModelData;
  UserFeedModelData? userFeedModelData;
  OffersModelData? offersModelData;
  TextEditingController searchController = TextEditingController();
  final HomeTabRepository _homeTabRepository = HomeTabRepository();

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  Future<void> getHomeData() async {
    try {
      final response = await _homeTabRepository.getHomeDataApi();

      if (response.isSuccess) {
        customerHomeModel = response.data!.data;
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  void applyFilter() {
    searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase();

    if (subCategoriesData != null) {
      subCategoriesData = subMainCategoriesData!
          .where((cat) =>
      cat != null &&
          cat.name != null &&
          cat.name!.toLowerCase().contains(query))
          .toList();
      update(); // notify listeners
    }
  }


  Future<void> loadInitial(String itemId, String subCategory) async {
    currentPage = 1;
    hasMoreData = true;
    await getUsersPopularServices(itemId, subCategory, currentPage.toString());
  }

  Future<void> loadMore(String itemId, String subCategory) async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    currentPage++;

    await getUsersPopularServices(
      itemId,
      subCategory,
      currentPage.toString(),
      isLoadMore: true,
    );

    // If API returned no data, mark no more
    if ((popularServiceDetailsModel?.isEmpty ?? true)) {
      hasMoreData = false;
    }

    isLoadingMore = false;
  }

  Future<void> getUsersPopularServices(
      String itemId,
      String subCategory,
      String page, {
        bool isLoadMore = false,
      }) async {
    print(itemId);

    try {
      if (!isLoadMore) {
        print('keshav');
        popularServiceDetailsModel = null; // fresh call
        update();
      }
      print('keshav kumar');
      final response = await _homeTabRepository.getUserPopularServices(
        itemId,
        subCategory,
        page,
      );

      if (response.isSuccess) {
        if (isLoadMore) {
          // Append data
          popularServiceDetailsModel?.addAll(response.data?.data?.data ?? []);
        } else {
          // Fresh load
          popularServiceDetailsModel = response.data?.data?.data ?? [];
        }
      } else {
        if (!isLoadMore) {
          popularServiceDetailsModel = [];
        }
        throw response.message.toString();
      }

      update();
    } catch (e) {
      throw e.toString();
    }
  }


  Future<void> addRemoveFacVendor(String vendorId, int index) async {
    try {
      final response = await _homeTabRepository.addVendertoFav(vendorId);

      if (response.isSuccess == true) {
        var value = popularServiceDetailsModel?[index]?.users?.favVendor;
        popularServiceDetailsModel?[index]?.users?.favVendor = (value == 0) ? 1 : 0;

        update();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getSelectedPopularServiceItem({
    required String categoryId,
  }) async {
    subCategoriesData = null;
    subMainCategoriesData = null;
    final response = await _homeTabRepository.getSubCategories(
      categoryId: categoryId,
    );
    if (response.isSuccess) {
      subMainCategoriesData = response.data?.data?.subCategories ?? [];
      subCategoriesData = response.data?.data?.subCategories ?? [];
    } else {
      subCategoriesData = [];
      subMainCategoriesData = [];
    }
    update();
  }

  Future<void> getVendorDetails({required String vendorId}) async {
    vendorDetailsModel = null;
    final response = await _homeTabRepository.getVendorDetails(
      vendorId: vendorId,
    );
    if (response.isSuccess) {
      vendorDetailsModel = response.data?.data;
      print(vendorDetailsModel?.userInfo?.profile);
    } else {
      throw response.message ?? 'Something went wrong';
    }
    update();
  }

  Future<void> getVendorPortfolio({required String vendorId}) async {
    portfolioModelData = null;
    final response = await _homeTabRepository.getVendorPortfolio(
      vendorId: vendorId,
    );
    if (response.isSuccess) {
      portfolioModelData = response.data?.data;
      print(vendorDetailsModel?.userInfo?.profile);
    } else {
      throw response.message ?? 'Something went wrong';
    }
    update();
  }


  Future<void> favOffeerApi(String offerId, int index) async {
    try {

      final response = await _homeTabRepository.offerFavApi(offerId);

      if (response.isSuccess) {

        final currentFav = offersModelData?.data?[index]?.isFavOffer ?? 0;
        offersModelData?.data?[index]?.isFavOffer = currentFav == 1 ? 0 : 1;
        update(); // Notify UI
      } else {

      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }


  Future<void> getVendorOffers({required String vendorId}) async {
    offersModelData = null;
    final response = await _homeTabRepository.getVendorOffers(
      vendorId: vendorId,
    );
    if (response.isSuccess) {
      offersModelData = response.data?.data;
    } else {
      offersModelData = OffersModelData();
      throw response.message ?? 'Something went wrong';
    }
    update();
  }

  Future<void> getVendorFeed({required String vendorId}) async {
    userFeedModelData = null;
    final response = await _homeTabRepository.getVendorFeed(vendorId: vendorId);
    if (response.isSuccess) {
      userFeedModelData = response.data?.data;
    } else {
      throw response.message ?? 'Something went wrong';
    }
    update();
  }




}
