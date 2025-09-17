import 'package:instajobs/models/categoris.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:instajobs/models/feed_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/popular_service_details_model/popular_services_details_model.dart';
import 'package:instajobs/models/portfolio_model.dart';
import 'package:instajobs/models/subCategory_model.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/models/offer-details_model.dart';
import 'package:instajobs/models/offer_tab_model.dart';
import '../models/customer_sign_up_model.dart';
import '../models/login.dart';
import '../network/api_url.dart';
import '../network/network_service.dart';

class HomeTabRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<CustomerHomeModel>> getHomeDataApi() async {
    return await _networkService.get<CustomerHomeModel>(
      path: ApiUrlConstants.homeListing,
      converter: (data) {
        // The converter is only called for successful responses now
        return CustomerHomeModel.fromJson(data);
      },
    );
  }
  Future<ApiResponse<PopularServiceDetailsMoel>> getUserPopularServices(String itemId, String subCategoryId, String page) async {
    final path = subCategoryId.isEmpty
        ? 'users/$itemId/?page=1'
        : 'users/$itemId/$subCategoryId/?page=1';

    return await _networkService.get<PopularServiceDetailsMoel>(
      path: path,
      converter: (data) {
        // The converter is only called for successful responses now
        return PopularServiceDetailsMoel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<PopularServiceDetailsMoel>> addVendertoFav(String vendorId) async {
    return await _networkService.post<PopularServiceDetailsMoel>(
      path: 'fav-vendors/$vendorId',
      converter: (data) {
        // The converter is only called for successful responses now
        return PopularServiceDetailsMoel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<OfferTabModel>> offerFavApi(String offerId) async {
    return await _networkService.post<OfferTabModel>(
      path: 'fav-offers/$offerId',
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<SubCategoryModel>> getSubCategories({
    required String categoryId,
  }) async {
    return await _networkService.get<SubCategoryModel>(
      path: ApiUrlConstants.getSubCategories(categoryId),

      converter: (data) {
        // The converter is only called for successful responses now
        return SubCategoryModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<VendorDetailsModel>> getVendorDetails({
    required String vendorId,
  }) async {
    return await _networkService.get<VendorDetailsModel>(
      path: 'vendor-details/$vendorId',

      converter: (data) {
        // The converter is only called for successful responses now
        return VendorDetailsModel.fromJson(data);
      },
    );
  }
  Future<ApiResponse<PortfilioModel>> getVendorPortfolio({
    required String vendorId,
  }) async {
    return await _networkService.get<PortfilioModel>(
      path: 'portfolio/$vendorId',

      converter: (data) {
        // The converter is only called for successful responses now
        return PortfilioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<OffersModel>> getVendorOffers({
    required String vendorId,
  }) async {
    return await _networkService.get<OffersModel>(
      path: 'offers/$vendorId',

      converter: (data) {
        // The converter is only called for successful responses now
        return OffersModel.fromJson(data);
      },
    );
  }
  Future<ApiResponse<UserFeedModel>> getVendorFeed({
    required String vendorId,
  }) async {
    return await _networkService.get<UserFeedModel>(
      path: 'users/feed/$vendorId',

      converter: (data) {
        // The converter is only called for successful responses now
        return UserFeedModel.fromJson(data);
      },
    );
  }
  Future<ApiResponse<CategoriesModel>> getCategories() async {
    return await _networkService.get<CategoriesModel>(
      path: ApiUrlConstants.categories,

      converter: (data) {
        // The converter is only called for successful responses now
        return CategoriesModel.fromJson(data);
      },
    );
  }
}
