import 'package:instajobs/models/add_potfolio_model.dart';
import 'package:instajobs/models/change_password.dart';
import 'package:instajobs/models/delete_portfolio_model.dart';
import 'package:instajobs/models/fav_freelancers_model.dart';
import 'package:instajobs/models/fav_offers_model.dart';
import 'package:instajobs/models/my_booking_model.dart';
import 'package:instajobs/models/my_insta_jobs_model.dart';
import 'package:instajobs/models/my_portfolio_model.dart';
import 'package:dio/dio.dart' as diox;
import 'package:dio/dio.dart' as dio;
import 'package:instajobs/models/popular_service_details_model/popular_services_details_model.dart';
import 'package:instajobs/models/profile_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/settings/change_password_page.dart';
import '../models/feed_tab_model.dart';
import '../models/offer_tab_model.dart';
import '../network/api_url.dart';
import '../network/network_service.dart';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

class ProfileRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<MyPortfolioModel>> getMyPortfolio() async {
    return await _networkService.get<MyPortfolioModel>(
      path: 'portfolio',
      converter: (data) {
        // The converter is only called for successful responses now
        return MyPortfolioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<AddPortfolioModel>> addPortfolio({
    required String title,
    required String description,
  }) async {
    return await _networkService.post<AddPortfolioModel>(
      path: 'add-portfolio',
      data: {'title': title, 'description': description, 'type': 0},
      converter: (data) {
        // The converter is only called for successful responses now
        return AddPortfolioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<DeletePortfolioModel>> deletePortfolio({
    required String id,
  }) async {
    return await _networkService.delete<DeletePortfolioModel>(
      path: 'remove-portfolio/$id',

      converter: (data) {
        // The converter is only called for successful responses now
        return DeletePortfolioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<DeletePortfolioModel>> editPortfolio({
    required String id,
    required String title,
    required String description,
  }) async {
    return await _networkService.put<DeletePortfolioModel>(
      path: 'edit-portfolio/$id',
      data: {'title': title, 'description': description},
      converter: (data) {
        // The converter is only called for successful responses now
        return DeletePortfolioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ChangePasswordModel>> changePasswordApi({
    required String oldPass,
    required String newPass,
  }) async {
    return await _networkService.put<ChangePasswordModel>(
      path: 'change-password',
      data: {'old_password': oldPass, 'new_password': newPass},
      converter: (data) {
        // The converter is only called for successful responses now
        return ChangePasswordModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ChangePasswordModel>> logoutApi() async {
    return await _networkService.post<ChangePasswordModel>(
      path: 'logout',
      data: {},
      converter: (data) {
        // The converter is only called for successful responses now
        return ChangePasswordModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ChangePasswordModel>> deleteAccountApi() async {
    return await _networkService.delete<ChangePasswordModel>(
      path: 'delete-account',
      data: {},
      converter: (data) {
        // The converter is only called for successful responses now
        return ChangePasswordModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ProfileDetailsModel>> getUserProfileDetails() async {
    return await _networkService.get<ProfileDetailsModel>(
      path: 'vendor-details/${StorageService().getUserId()}',
      converter: (data) {
        // The converter is only called for successful responses now
        return ProfileDetailsModel.fromJson(data);
      },
    );
  }

  //getMultipartImage
  static Future<MultipartFile> getMultipartImage({required String path}) async {
    String fileName = path.split('/').last;
    String mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    return await MultipartFile.fromFile(path, filename: fileName);
  }

  Future<ApiResponse<ProfileDetailsModel>> updateProfile(
      dio.FormData formData,
      ) async {
    return await _networkService.put<ProfileDetailsModel>(
      data: formData,
      path: 'edit-profile',
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': StorageService().getUserData().authToken ?? '',
      },
      converter: (data) {
        return ProfileDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<MyInstaJobsModel>> getMyInstaJobs(int status) async {
    return await _networkService.get<MyInstaJobsModel>(
      path: 'jobs?page=1&limit=30&status=$status',
      converter: (data) {
        // The converter is only called for successful responses now
        return MyInstaJobsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<MyBookingModel>> getMyBookings(int status) async {
    return await _networkService.get<MyBookingModel>(
      path: 'bookings?page=1&limit=30&status=$status',
      converter: (data) {
        // The converter is only called for successful responses now
        return MyBookingModel.fromJson(data);
      },
    );
  }

  /// MY Offers
  Future<ApiResponse<OfferTabModel>> getOffersApi() async {
    return await _networkService.get<OfferTabModel>(
      path: 'offers/${StorageService().getUserId()}?page=1&limit=50',
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FavOffersModel>> getFavOffersApi() async {
    return await _networkService.get<FavOffersModel>(
      path: 'fav-offers?limit=100',
      converter: (data) {
        // The converter is only called for successful responses now
        return FavOffersModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FavFreelancersModel>> getFavFreelancersApi() async {
    return await _networkService.get<FavFreelancersModel>(
      path: 'fav-vendors',
      converter: (data) {
        // The converter is only called for successful responses now
        return FavFreelancersModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> geFavtFeedData() async {
    return await _networkService.get<FeedTabModel>(
      path: ApiUrlConstants.feedTabData,
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<OfferTabModel>> addOffersApi({
    required Map<String, dynamic> map,
  }) async {
    return await _networkService.post<OfferTabModel>(
      path: 'offers',
      data: map,
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<OfferTabModel>> editOffersApi({
    required Map<String, dynamic> map,
    required String offerId,
  }) async {
    return await _networkService.put<OfferTabModel>(
      path: 'offers/$offerId',
      data: map,
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
      },
    );
  }
}
