import 'package:instajobs/models/add_potfolio_model.dart';
import 'package:instajobs/models/change_password.dart';
import 'package:instajobs/models/delete_portfolio_model.dart';
import 'package:instajobs/models/fav_freelancers_model.dart';
import 'package:instajobs/models/fav_offers_model.dart';
import 'package:instajobs/models/forgot_pass.dart';
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


  Future<ApiResponse<ForgotPassModel>> boostProfile(String price) async {

    final currentLoginUserId = StorageService().getUserData().userId.toString();
    return await _networkService.post<ForgotPassModel>(
      path: "${ApiUrlConstants.boostProfile}",
      data: {'amount': price},
      converter: (data) {
        // The converter is only called for successful responses now
        return ForgotPassModel.fromJson(data);
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

  Future<ApiResponse<ProfileDetailsModel>> updateWorkingHour(String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
      String sunday) async {
    return await _networkService.put<ProfileDetailsModel>(
      path: 'user-working-hours',
      data: {'monday': monday, 'tuesday': tuesday, 'wednesday': wednesday, 'thursday': thursday, 'friday': friday, 'saturday': saturday, 'sunday': sunday},
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

  Future<ApiResponse<MyBookingDetailModel>> getBookingDetail(
      String bookingId,
      ) async {
    return await _networkService.get<MyBookingDetailModel>(
      path: 'booking/$bookingId',
      converter: (data) {
        try {
          print('Sham');
          final model = MyBookingDetailModel.fromJson(data);
          print(model.message); // This line was crashing before
          print('Sundar');
          return model;
        } catch (e, stack) {
          print('❌ Error in converter');
          print(e);
          print(stack);
          rethrow; // So the error propagates properly
        }
      },
    );
  }

  Future<ApiResponse<MyBookingDetailModel>> completeBooking(
      String bookingId,
      ) async {
    return await _networkService.patch<MyBookingDetailModel>(
      path: 'complete-booking/$bookingId',
      converter: (data) {
        try {
          print('Sham');
          final model = MyBookingDetailModel.fromJson(data);
          print(model.message); // This line was crashing before
          print('Sundar');
          return model;
        } catch (e, stack) {
          print('❌ Error in converter');
          print(e);
          print(stack);
          rethrow; // So the error propagates properly
        }
      },
    );
  }

  Future<ApiResponse<MyBookingDetailModel>> adOnAcceptReject(
      String adOnid,
      String status,
      ) async {
    return await _networkService.put<MyBookingDetailModel>(
      path: 'booking/addon-accept-reject/$adOnid',
      data: {'status': status},
      converter: (data) {
        try {
          print('Sham');
          final model = MyBookingDetailModel.fromJson(data);
          print(model.message); // This line was crashing before
          print('Sundar');
          return model;
        } catch (e, stack) {
          print('❌ Error in converter');
          print(e);
          print(stack);
          rethrow; // So the error propagates properly
        }
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

  Future<ApiResponse<OfferTabModel>> offerFavApi(String offerId) async {
    return await _networkService.post<OfferTabModel>(
      path: 'fav-offers/$offerId',
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
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

  Future<ApiResponse<FavFreelancersModel>> addVendertoFav(
      String vendorId,
      ) async {
    return await _networkService.post<FavFreelancersModel>(
      path: 'fav-vendors/$vendorId',
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

  Future<ApiResponse<OfferTabModel>> bookingAcceptReject({
    required String status,
    required String bookingId,
  }) async {
    return await _networkService.put<OfferTabModel>(
      path: 'booking-accept-reject/$bookingId',
      data: {'status': status},
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<OfferTabModel>> bookingCancel({
    required String bookingId,
  }) async {
    return await _networkService.patch<OfferTabModel>(
      path: 'cancel-booking/$bookingId',
      data: {},
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<AddPortfolioModel>> addBookingAdOn({
    required String bookingId,
    required String price,
    required String description,
    required String timeToComplete,
  }) async {
    return await _networkService.post<AddPortfolioModel>(
      path: 'booking/add-on/$bookingId',
      data: {
        'price': price,
        'description': description,
        'timeToComplete': timeToComplete,
      },
      converter: (data) {
        // The converter is only called for successful responses now
        return AddPortfolioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<AddPortfolioModel>> addBookingRating({
    required String bookingId,
    required String userId,
    required String communicationRating,
    required String attitudeRating,
    required String deliveryRating,
    required String deliveryComment,
    required String attitudeComment,
    required String communicationComment,
  }) async {
    return await _networkService.post<AddPortfolioModel>(
      path: 'rating',
      data: {
        'bookingId': bookingId,
        'userId': userId,
        'communicationRating': communicationRating,
        'attitudeRating': attitudeRating,
        'deliveryRating': deliveryRating,
        'deliveryComment': deliveryComment,
        'attitudeComment': attitudeComment,
        'communicationComment': communicationComment
      },
      converter: (data) {
        // The converter is only called for successful responses now
        return AddPortfolioModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<AddPortfolioModel>> addJobRating({
    required String bookingId,
    required String userId,
    required String communicationRating,
    required String attitudeRating,
    required String deliveryRating,
    required String deliveryComment,
    required String attitudeComment,
    required String communicationComment,
  }) async {
    return await _networkService.post<AddPortfolioModel>(
      path: 'rating',
      data: {
        'jobId': bookingId,
        'userId': userId,
        'communicationRating': communicationRating,
        'attitudeRating': attitudeRating,
        'deliveryRating': deliveryRating,
        'deliveryComment': deliveryComment,
        'attitudeComment': attitudeComment,
        'communicationComment': communicationComment
      },
      converter: (data) {
        // The converter is only called for successful responses now
        return AddPortfolioModel.fromJson(data);
      },
    );
  }

}
