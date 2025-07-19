import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as p;

import 'package:instajobs/models/fav_offers_model.dart';
import 'package:instajobs/models/my_booking_model.dart';
import 'package:instajobs/models/profile_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/models/my_insta_jobs_model.dart';
import 'package:instajobs/models/my_portfolio_model.dart';
import 'package:instajobs/repositories/prodile_repository.dart';
import '../models/fav_freelancers_model.dart';
import '../models/feed_tab_model.dart';
import '../models/offer_tab_model.dart';
import 'dart:convert';
import '../models/popular_service_details_model/popular_services_details_model.dart';

class ProfileController extends GetxController with BaseClass {
  int pendingTotal = -1;
  int inProgressTotal = -1;
  int cancelledTotal = -1;
  int completedTotal = -1;

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

  ProfileDetailsModelData? profileDetailsModel;

  Future<void> getMyPortfolio() async {
    myPortfolioData = null;
    final response = await _profileRepository.getMyPortfolio();
    myPortfolioData = response.isSuccess ? response.data?.data?.data ?? [] : [];
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
    }
    update();
  }

  Future<void> deletePortfolio(String id, int index) async {
    showGetXCircularDialog();
    final response = await _profileRepository.deletePortfolio(id: id);
    Get.back();
    if (response.isSuccess) {
      showSuccess(title: 'Delete', message: 'Portfolio deleted Successfully');
      myPortfolioData?.removeAt(index);
    }
    update();
  }

  Future<void> editPortfolio(String id, String title, String description) async {
    showGetXCircularDialog();
    final response = await _profileRepository.editPortfolio(
      id: id,
      title: title,
      description: description,
    );
    Get.back();
    if (response.isSuccess) {
      showSuccess(title: 'Edited', message: 'Portfolio edited Successfully');
      getMyPortfolio();
      Get.back();
      Get.back();
    }
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

    final request = http.MultipartRequest(
      isEditPortfolio ? 'PUT' : 'POST',
      Uri.parse(
        isEditPortfolio
            ? 'https://app.superinstajobs.com/api/v1/edit-portfolio/$itemId'
            : 'https://app.superinstajobs.com/api/v1/add-portfolio',
      ),
    )
      ..headers['Authorization'] = StorageService().getUserData().authToken ?? ''
      ..fields['description'] = description
      ..fields['title'] = title
      ..fields['type'] = '0'
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: p.basename(imageFile.path),
          contentType: MediaType('image', 'jpeg'),
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

    final response = await _profileRepository.getMyInstaJobs(status);
    if (response.isSuccess) {
      final data = response.data?.data?.data ?? [];
      if (status == 3) pendingInstaJobsData = data;
      if (status == 1) inProgressInstaJobsData = data;
      if (status == 2) historyInstaJobsData = data;
    } else {
      if (status == 3) pendingInstaJobsData = [];
      if (status == 1) inProgressInstaJobsData = [];
      if (status == 2) historyInstaJobsData = [];
    }
    update();
  }

  Future<void> getMyBookings({required int status}) async {
    switch (status) {
      case 0: pendingBookingsList = null; break;
      case 1: inProgressBookingsList = null; break;
      case 2: cancelledBookingsList = null; break;
      case 4: completedBookingsList = null; break;
    }

    final response = await _profileRepository.getMyBookings(status);
    if (response.isSuccess) {
      final data = response.data?.data?.data ?? [];
      switch (status) {
        case 0: pendingBookingsList = data; pendingTotal = data.length; break;
        case 1: inProgressBookingsList = data; inProgressTotal = data.length; break;
        case 2: cancelledBookingsList = data; cancelledTotal = data.length; break;
        case 4: completedBookingsList = data; completedTotal = data.length; break;
      }
    } else {
      switch (status) {
        case 0: pendingBookingsList = []; pendingTotal = 0; break;
        case 1: inProgressBookingsList = []; inProgressTotal = 0; break;
        case 2: cancelledBookingsList = []; cancelledTotal = 0; break;
        case 4: completedBookingsList = []; completedTotal = 0; break;
      }
    }
    update();
  }

  Future<void> changePasswordApi(String oldPassword, String newPassword) async {
    showGetXCircularDialog();
    final response = await _profileRepository.changePasswordApi(
      oldPass: oldPassword,
      newPass: newPassword,
    );
    Get.back();
    if (response.isSuccess) {
      showSuccess(title: 'Changed', message: 'Password changed Successfully');
    } else {
      showError(title: 'Error', message: 'Old password is wrong');
    }
    update();
  }

  Future<void> logoutApi() async {
    showGetXCircularDialog();
    await _profileRepository.logoutApi();
    Get.back();
  }

  Future<void> deleteAccountApi() async {
    showGetXCircularDialog();
    await _profileRepository.deleteAccountApi();
    Get.back();
  }

  Future<void> getProfileDetails() async {
    profileDetailsModel = null;
    final response = await _profileRepository.getUserProfileDetails();
    if (response.isSuccess) {
      profileDetailsModel = response.data?.data;
    }
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
    File? profile,
  }) async {
    final map = <String, dynamic>{
      'name': '$firstName $lastName',
      'email': email,
      'phone': phone,
      'descriptions': description,
      'hourly_price': hourlyPrice.toString(),
      'daily_price': dailyPrice.toString(),
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'street': street,
    };

    if (profile != null) {
      print('no image havssse');
      map['profile'] = await dio.MultipartFile.fromFile(
        profile.path,
        filename: profile.path.split('/').last,
      );
    //  map['profile'] = await dio.MultipartFile.fromFile(profile.path);
    } else {
      print('no image');
    }
    final formData = dio.FormData.fromMap(map);
    final response = await _profileRepository.updateProfile(formData);
    if (response.isSuccess) {
      getProfileDetails();
    }
    update();
  }

  Future<void> getOffersApi() async {
    try {
      offersList = null;
      final response = await _profileRepository.getOffersApi();
      offersList = response.isSuccess ? response.data?.data?.data ?? [] : [];
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getFavOffersApi() async {
    try {
      favOffersList = null;
      final response = await _profileRepository.getFavOffersApi();
      favOffersList = response.isSuccess ? response.data?.data?.data ?? [] : [];
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
      favFreelancers = response.isSuccess ? response.data?.data?.data ?? [] : [];
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  List<FeedTabModelDataData?>? favFeedList;
  Future<void> getFavFeedData() async {
    favFeedList = null;
    final response = await _profileRepository.geFavtFeedData();
    favFeedList = response.isSuccess ? response.data?.data?.data ?? [] : [];
    update();
  }

  Future<void> addOfferApi({
    required String description,
    required String name,
    required String price,
    required int deliveryTime,
    List<Map<String, dynamic>>? adOn,
  }) async {
    try {
      showGetXCircularDialog();
      final Map<String, dynamic> map = {
        'description': description,
        'name': name,
        'price': price,
        'deliveryTime': deliveryTime,
      };

      // Include adOn only if it's not empty
      if (adOn != null && adOn.isNotEmpty) {
        map['adOn'] = jsonEncode(adOn.map((item) {
          return item.map((key, value) => MapEntry(key.toString(), value.toString()));
        }).toList());
       // map['adOn'] = adOn;
      }
      print(map);
      final response = await _profileRepository.addOffersApi(
        map: map
      );
      Get.back();
      if (response.isSuccess) {
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
    List<Map<String, dynamic>>? adOn,
  }) async {
    try {
      Map<String, dynamic> map = {
        'description': description,
        'name': name,
        'price': price,
        'deliveryTime': deliveryTime,

      };
      print(adOn?.length);
      if (adOn != null && adOn.isNotEmpty) {
        print('objectsss');
        map['adOn'] = jsonEncode(adOn.map((item) {
          return item.map((key, value) => MapEntry(key.toString(), value.toString()));
        }).toList());
        // map['adOn'] = adOn;
      }
      if (removedImageId.isNotEmpty) {
        map['removeImageIds'] = removedImageId.join(',');
      }

      final response = await _profileRepository.editOffersApi(
        map: map,
        offerId: offerId,
      );

      if (!response.isSuccess) {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }
}
