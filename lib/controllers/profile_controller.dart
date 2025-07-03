import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; //  👈 add this line
import 'package:instajobs/models/fav_offers_model.dart';
import 'package:instajobs/models/my_booking_model.dart';
import 'package:instajobs/models/profile_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:instajobs/models/my_insta_jobs_model.dart';
import 'package:instajobs/models/my_portfolio_model.dart';
import 'package:instajobs/repositories/prodile_repository.dart';

import '../models/fav_freelancers_model.dart';
import '../models/feed_tab_model.dart';
import '../models/offer_tab_model.dart';
import '../models/popular_service_details_model/popular_services_details_model.dart';

class ProfileController extends GetxController with BaseClass {
  ///
  int pendingTotal = -1;
  int inProgressTotal = -1;
  int cancelledTotal = -1;
  int completedTotal = -1;

  ///
  final ProfileRepository _profileRepository = ProfileRepository();
  List<MyPortfolioModelDataData?>? myPortfolioData;

  List<MyInstaJobsModelDataData?>? pendingInstaJobsData;

  List<MyInstaJobsModelDataData?>? inProgressInstaJobsData;

  List<MyInstaJobsModelDataData?>? historyInstaJobsData;

  List<MyBookingModelDataData?>? pendingBookingsList;
  List<MyBookingModelDataData?>? inProgressBookingsList;
  List<MyBookingModelDataData?>? cancelledBookingsList;
  List<MyBookingModelDataData?>? completedBookingsList;
  List<OfferTabModelDataData?>? offersList;
  List<FavOffersModelDataData?>? favOffersList;

  Future<void> getMyPortfolio() async {
    myPortfolioData = null;
    final response = await _profileRepository.getMyPortfolio();
    if (response.isSuccess) {
      myPortfolioData = response.data?.data?.data ?? [];
    } else {
      myPortfolioData = [];
    }
    update();
  }

  Future<void> addPortfolio(String title, String description) async {
    showGetXCircularDialog();
    final response = await _profileRepository.addPortfolio(
      title: title,
      description: description,
    );
    Get.back();
    if (response.isSuccess) {
      getMyPortfolio();
      showSuccess(title: 'Added', message: 'Portfolio Added Successfully');
    } else {}
    update();
  }

  Future<void> deletePortfolio(String id, int index) async {
    showGetXCircularDialog();
    final response = await _profileRepository.deletePortfolio(id: id);
    Get.back();
    if (response.isSuccess) {
      showSuccess(title: 'Delete', message: 'Portfolio deleted Successfully');
      myPortfolioData?.removeAt(index);
    } else {}
    update();
  }

  Future<void> editPortfolio(
    String id,
    String title,
    String description,
  ) async {
    showGetXCircularDialog();
    final response = await _profileRepository.editPortfolio(
      id: id,
      title: '',
      description: '',
    );
    Get.back();
    if (response.isSuccess) {
      showSuccess(title: 'Edited', message: 'Portfolio edited Successfully');
      getMyPortfolio();
      Get.back();
      Get.back();
    } else {}
    update();
  }

  Future<void> uploadImageHttp({
    required File imageFile,
    required String title,
    required String description,
    bool isEditPortfolio = false,
    String? itemId,
  }) async {
    showGetXCircularDialog();
    final request =
        http.MultipartRequest(
            isEditPortfolio ? 'PUT' : 'POST',
            isEditPortfolio
                ? Uri.parse(
                  'https://app.superinstajobs.com/api/v1/edit-portfolio/$itemId',
                )
                : Uri.parse(
                  'https://app.superinstajobs.com/api/v1/add-portfolio',
                ),
          )
          ..headers['Authorization'] =
              StorageService().getUserData().authToken ?? ''
          ..fields['description'] = description
          ..fields['title'] = title
          ..fields['type'] = '0'
          ..files.add(
            await http.MultipartFile.fromPath(
              'image',
              imageFile.path,
              filename: p.basename(imageFile.path),
              contentType: MediaType('image', 'jpeg'), // ← now recognised
            ),
          );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    Get.back();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      print(response.body);

      throw Exception('Upload failed: ${response.statusCode}');
    } else {
      if (isEditPortfolio) {
        await getMyPortfolio();
        Get.back();
        Get.back();
      } else {
        Get.back();
      }

      showSuccess(title: 'Added', message: 'Portfolio Added Successfully');
    }
  }

  Future<void> getInstaJobs({required int status}) async {
    if (status == 3) {
      pendingInstaJobsData = null;
    } else if (status == 1) {
      inProgressInstaJobsData = null;
    } else if (status == 2) {
      historyInstaJobsData = null;
    }
    myPortfolioData = null;
    final response = await _profileRepository.getMyInstaJobs(status);
    if (response.isSuccess) {
      if (status == 3) {
        pendingInstaJobsData = response.data?.data?.data ?? [];
      } else if (status == 1) {
        inProgressInstaJobsData = response.data?.data?.data ?? [];
      } else if (status == 2) {
        historyInstaJobsData = response.data?.data?.data ?? [];
      }
    } else {
      if (response.isSuccess) {
        if (status == 3) {
          pendingInstaJobsData = [];
        } else if (status == 1) {
          inProgressInstaJobsData = [];
        } else if (status == 2) {
          historyInstaJobsData = [];
        }
      }
    }
    update();
  }

  /// BOOKINGS
  Future<void> getMyBookings({required int status}) async {
    if (status == 0) {
      pendingBookingsList = null;
    } else if (status == 1) {
      inProgressBookingsList = null;
    } else if (status == 2) {
      cancelledBookingsList = null;
    } else if (status == 4) {
      completedBookingsList = null;
    }

    final response = await _profileRepository.getMyBookings(status);
    if (response.isSuccess) {
      if (status == 0) {
        pendingBookingsList = response.data?.data?.data ?? [];
        pendingTotal = pendingBookingsList?.length ?? 0;
        completedTotal = -1;
        cancelledTotal = -1;
        inProgressTotal = -1;
      } else if (status == 1) {
        inProgressBookingsList = response.data?.data?.data ?? [];
        inProgressTotal = inProgressBookingsList?.length ?? 0;
        completedTotal = -1;
        cancelledTotal = -1;
        pendingTotal = -1;
      } else if (status == 2) {
        cancelledBookingsList = response.data?.data?.data ?? [];
        cancelledTotal = cancelledBookingsList?.length ?? 0;
        completedTotal = -1;
        inProgressTotal = -1;
        pendingTotal = -1;
      } else if (status == 4) {
        completedBookingsList = response.data?.data?.data ?? [];
        completedTotal = completedBookingsList?.length ?? 0;
        cancelledTotal = -1;
        inProgressTotal = -1;
        pendingTotal = -1;
      }
    } else {
      if (status == 0) {
        pendingBookingsList = [];
        pendingTotal = 0;
        completedTotal = -1;
        cancelledTotal = -1;
        inProgressTotal = -1;
      } else if (status == 1) {
        inProgressBookingsList = [];
        inProgressTotal = 0;
        completedTotal = -1;
        cancelledTotal = -1;
        pendingTotal = -1;
      } else if (status == 2) {
        cancelledBookingsList = [];
        cancelledTotal = 0;
        completedTotal = -1;
        inProgressTotal = -1;
        pendingTotal = -1;
      } else if (status == 4) {
        completedBookingsList = [];
        completedTotal = 0;
        cancelledTotal = -1;
        inProgressTotal = -1;
        pendingTotal = -1;
      }
    }
    update();
  }

  ///----
  Future<void> changePasswordApi(String oldPassword, String newPassword) async {
    showGetXCircularDialog();
    final response = await _profileRepository.changePasswordApi(
      oldPass: oldPassword,
      newPass: newPassword,
    );
    Get.back();
    if (response.isSuccess) {
      showSuccess(title: 'Changed', message: 'Password changed Successfully');
    } else {}
    update();
  }

  ProfileDetailsModelData? profileDetailsModel;

  Future<void> getProfileDetails() async {
    profileDetailsModel = null;
    final response = await _profileRepository.getUserProfileDetails();

    if (response.isSuccess) {
      profileDetailsModel = response.data?.data;
    } else {}
    update();
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String description,
    required double hourlyPrice,
    required double dailyPrice,
    required String city,
    required String state,
    required String country,
    required String latitude,
    required String longitude,
    required String street,
  }) async {
    final response = await _profileRepository.updateProfile({
      'name': '$firstName $lastName',
      'address': '',
      'state': state,
      'country': country,
      'phone': phone,
      'street': street,
      'latitude': latitude,
      'longitude': longitude,
    });
    if (response.isSuccess) {
      getProfileDetails();
      //profileDetailsModel = response.data?.data;
    } else {}
    update();
  }

  /// MY Offers
  Future<void> getOffersApi() async {
    try {
      offersList = null;
      final response = await _profileRepository.getOffersApi();

      if (response.isSuccess) {
        offersList = response.data?.data?.data ?? [];
      } else {
        offersList = [];
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getFavOffersApi() async {
    try {
      favOffersList = null;
      final response = await _profileRepository.getFavOffersApi();

      if (response.isSuccess) {
        favOffersList = response.data?.data?.data??[];
      } else {
        favOffersList = [];
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }
  List<FavFreelancersModelDataData?>? favFreelancers;
  Future<void> getFavFreelancers() async {
    try {
      favFreelancers = null;
      final response = await _profileRepository.getFavFreelancersApi();
      if (response.isSuccess) {
        favFreelancers = response.data?.data?.data??[];
      } else {
        favFreelancers = [];
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  List<FeedTabModelDataData?>? favFeedList;
  Future<void> getFavFeedData() async {
    favFeedList = null;
    final response = await _profileRepository.geFavtFeedData();
    if (response.isSuccess) {
      favFeedList = response.data?.data?.data ?? [];
    } else {
      favFeedList = [];
    }
    update();
  }
  ///

  Future<void> addOfferApi({
    required String description,
    required String name,
    required String price,
    required int deliveryTime,
  }) async {
    try {
      showGetXCircularDialog();
      final response = await _profileRepository.addOffersApi(
        map: {
          'description': description,
          'name': name,
          'price': price,
          'deliveryTime': deliveryTime,
        },
      );

      if (response.isSuccess) {
        Get.back();
        await getOffersApi();
        Get.back();
        showSuccess(title: 'Offer', message: 'Offer added successfully');



      } else {

        throw response.message.toString();
      }
      update();
    } catch (e) {
      Get.back();
      throw e.toString();
    }
  }

  Future<void> editOffer({
    required String description,
    required String name,
    required String price,
    required int deliveryTime,
    required List<int> removedImageId,
    required String offerId,
  }) async {
    try {
      Map<String, dynamic> map = {
        'description': description,
        'name': name,
        'price': price,
        'deliveryTime': deliveryTime,
      };
      if (removedImageId.isNotEmpty) {
        map.putIfAbsent('removeImageIds', () => removedImageId.join(','));
      }

      final response = await _profileRepository.editOffersApi(
        map: map,
        offerId: offerId,
      );

      if (response.isSuccess) {
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }
}
