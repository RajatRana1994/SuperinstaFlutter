import 'package:get/get.dart';
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
  List<ServicesUsersModel?>? usersPopularServicesList;
  VendorDetailsModelData? vendorDetailsModel;
  PortfilioModelData? portfolioModelData;
  UserFeedModelData? userFeedModelData;
  OffersModelData? offersModelData;
  final HomeTabRepository _homeTabRepository = HomeTabRepository();

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

  Future<void> getUsersPopularServices(String itemId) async {
    try {
      popularServiceDetailsModel = null;
      final response = await _homeTabRepository.getUserPopularServices(itemId);
      if (response.isSuccess) {
        popularServiceDetailsModel = response.data?.data?.data??[];
      } else {
        popularServiceDetailsModel = [];
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getSelectedPopularServiceItem({
    required String categoryId,
  }) async {
    subCategoriesData = null;
    final response = await _homeTabRepository.getSubCategories(
      categoryId: categoryId,
    );
    if (response.isSuccess) {
      subCategoriesData = response.data?.data?.subCategories ?? [];
    } else {
      subCategoriesData = [];
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
