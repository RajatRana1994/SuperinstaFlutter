import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as diox;
import 'package:instajobs/views/jobs_tab/job_send_proposal.dart';
import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/models/jobs_model.dart';
import 'package:instajobs/models/offer-details_model.dart';
import 'package:instajobs/models/offer_tab_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/repositories/jobs_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:instajobs/utils/baseClass.dart';
import '../../storage_services/local_stoage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:instajobs/models/feed_tab_model.dart';

class JobTabController extends GetxController with BaseClass {
  JobRepository jobRepository = JobRepository();
  List<JobsModelDataData?> jobsList = [];
  // List<JobsModelDataData?>? jobsList;
  List<OfferTabModelDataData?>? offersList;
  OfferDetailsModelData? offerDetailsModelData;
  JobDetailsModelData? jobDetailsModelData;
  List<AppSettingBodyModel>? appSetting;
  AppSettingBodyModel? boostFeedSetting;
  AppSettingBodyModel? boostJobSetting;
  List<String> skillsList = [];

  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  Future<void> getJobsApi({bool isInitialLoad = false}) async {
    print("_isFetching: $_isFetching");
    print("isInitialLoad: $isInitialLoad");
    print("_hasMore: $_hasMore");

    if (_isFetching || (!isInitialLoad && !_hasMore)) return;

    print("Fetching jobs...");
    try {
      _isFetching = true;

      if (isInitialLoad) {
        _currentPage = 1;
        _hasMore = true; // ✅ Reset this here
        jobsList.clear();
      }

      final response = await jobRepository.getJobsApi(page: _currentPage);

      if (response.isSuccess) {
        final newJobs = response.data!.data?.data ?? [];

        if (newJobs.isEmpty || newJobs.length < 10) {
          _hasMore = false;
        }

        jobsList.addAll(newJobs);
        _currentPage++;
      } else {
        _hasMore = false;
      }

      update();
    } catch (e) {
      print("Pagination Error: $e");
    } finally {
      _isFetching = false;
    }
  }


  // Future<void> getJobsApi() async {
  //   try {
  //     jobsList = null;
  //     final response = await jobRepository.getJobsApi();
  //
  //     if (response.isSuccess) {
  //       jobsList = response.data!.data?.data ?? [];
  //     } else {
  //       jobsList = [];
  //       throw response.message.toString();
  //     }
  //     update();
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Future<void> getOffersApi() async {
    try {
      offersList = null;
      final response = await jobRepository.getOffersApi();

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

  Future<void> favOffeerApi(String offerId, int index) async {
    try {

      final response = await jobRepository.offerFavApi(offerId);

      if (response.isSuccess) {

        final currentFav = offersList?[index]?.isFavOffer ?? 0;
        offersList?[index]?.isFavOffer = currentFav == 1 ? 0 : 1;
        update(); // Notify UI


      } else {

      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getOffersDetailsApi(String offerId) async {
    try {
      offerDetailsModelData = null;
      final response = await jobRepository.getOfferDetails(offerId);

      if (response.isSuccess) {
        offerDetailsModelData = response.data?.data;
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> boostMyOffer(String id, String amount) async {
    final response = await jobRepository.boostMyOffer(id, amount);
    print("Raw wrapper message: ${response.message}");
    print("Model message: ${response.data?.message}");
    if (response.isSuccess) {
      offerDetailsModelData?.isBoosted = 1;
      showSuccess(title: 'Boost', message: response.data?.message ?? '');
    } else {
      showError(title: 'Boost', message: response.data?.message ?? '');
    }
    update();
  }

  Future<void> boostMyJob(String id, String amount) async {
    final response = await jobRepository.boostMyJob(id, amount);
    print("Raw wrapper message: ${response.message}");
    print("Model message: ${response.data?.message}");
    if (response.isSuccess) {
      jobDetailsModelData?.isBoosted = 1;
      showSuccess(title: 'Boost', message: response.data?.message ?? '');
    } else {
      showError(title: 'Boost', message: response.data?.message ?? '');
    }
    update();
  }



  Future<void> getJobDetailsApi(String jobId) async {
    try {
      jobDetailsModelData = null;
      final response = await jobRepository.getJobDetails(jobId);

      if (response.isSuccess) {
        jobDetailsModelData = response.data?.data;

        skillsList = (jobDetailsModelData?.skills ?? '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }


  Future<void> rejectJobMilestone(String proposalId, String jobId) async {
    try {

      final response = await jobRepository.rejectJobMilestone(proposalId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }


  Future<void> startJobMileStone(String proposalId, String jobId) async {
    try {

      final response = await jobRepository.startJobMilestone(proposalId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }



  Future<void> acceptJobMilstone(String proposalId, String jobId) async {
    try {

      final response = await jobRepository.acceptJobMilestone(proposalId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> submitJobMilestone(String proposalId, String jobId) async {
    try {

      final response = await jobRepository.submitJobMilestone(proposalId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> submitJob(String jobId) async {
    try {

      final response = await jobRepository.submitJob(jobId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> rejectJob(String jobId) async {
    try {

      final response = await jobRepository.rejectJob(jobId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> acceptJob(String jobId) async {
    try {

      final response = await jobRepository.acceptJob(jobId);

      if (response.isSuccess) {
        getJobDetailsApi(jobId);
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getAppSetting() async {
    appSetting = null;
    final response = await jobRepository.getAppSetting();
    if (response.isSuccess) {
      appSetting = response.data?.data ?? [];
      boostFeedSetting = appSetting?.firstWhere(
            (e) => e.name == "Boost offer",
        orElse: () => AppSettingBodyModel(value: "0"),
      );

      boostJobSetting = appSetting?.firstWhere(
            (e) => e.name == "Boost job",
        orElse: () => AppSettingBodyModel(value: "0"),
      );
    } else {
      appSetting = [];
    }
    update();
  }

  Future<void> acceptJobApi(
      String jobId,
      String assignUserid,
      String acceptedBudget,
      String jobProposalId,
      VoidCallback onSuccess,
      ) async {
    try {
      final response = await jobRepository.acceptProposal(
        id: jobId,
        assignUserId: assignUserid,
        acceptedBudget: acceptedBudget,
        jobProposalId: jobProposalId,
      );

      if (response.isSuccess) {
        onSuccess(); // 🔥 Call success
      } else {
        showError(title: '', message: response.message ?? '');
        throw response.message.toString();
      }

      update();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> rejectJobApi(String jobProposalId, VoidCallback onSuccess,) async {
    try {
      final response = await jobRepository.rejectProposal(jobProposalId: jobProposalId);

      if (response.isSuccess) {
        onSuccess(); // 🔥 Call success
      } else {
        showError(title: '', message: response.message ?? '');
        throw response.message.toString();
      }

      update();
    } catch (e) {
      throw e.toString();
    }
  }

  final ImagePicker _picker = ImagePicker();
  List<File> pickedImages = [];
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController proposalDescription = TextEditingController();

  Future<void> pickOne(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file == null) return;

    pickedImages.add(File(file.path));
    update();
  }

  void removeImage(int index) {
    pickedImages.removeAt(index);
    update();
  }



  Map<String, dynamic> queryParams = {};
  final Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Authorization": StorageService().getUserData().getAuthToken() ?? '',
  };


  Future<void> uploadImages(String jobId, String type, [List<MilestoneModel>? milestones]) async {
    print(type);
    if (type == '2' && totalAmountController.text.isEmpty) {
      showError(title: 'Name', message: 'Please add amount');
    } else if (proposalDescription.text.isEmpty) {
      showError(title: 'Price', message: 'Please add proposal');
    } else {

      if (type == '1') {
        for (int i = 0; i < (milestones?.length ?? 0); i++) {
          final milestone = milestones![i];

          if (milestone.descriptionController.text
              .trim()
              .isEmpty) {
            showError(title: 'Milestone',
                message: 'Please enter description for milestone ${i + 1}');
            return;
          } else if (milestone.dueDateController.text
              .trim()
              .isEmpty) {
            showError(title: 'Milestone',
                message: 'Please select due date for milestone ${i + 1}');
            return;
          } else if (milestone.amountController.text
              .trim()
              .isEmpty) {
            showError(title: 'Milestone',
                message: 'Please enter amount for milestone ${i + 1}');
            return;
          }
        }
      }

      final dio = diox.Dio();

      final Map<String, dynamic> queryParams = {
        'jobId': jobId,
        'description': proposalDescription.text.trim(),
        'requestBudget': totalAmountController.text.trim(),
        'type': type,
      };

      if (type == '2') {
        queryParams['requestBudget'] = totalAmountController.text.trim();
      } else if (type == '1' && milestones != null && milestones.isNotEmpty) {
        // Sum up milestone amounts
        double total = milestones.fold(0.0, (sum, m) {
          return sum + (double.tryParse(m.amountController.text.trim()) ?? 0);
        });
        queryParams['requestBudget'] = total.toStringAsFixed(2);

        // Also include milestone data
        final milestoneList = milestones.map((milestone) {
          return {
            "price": double.tryParse(milestone.amountController.text.trim()) ?? 0,
            "description": milestone.descriptionController.text.trim(),
            "date": ((milestone.selectedDate?.millisecondsSinceEpoch ?? 0) ~/ 1000),
          };
        }).toList();

        queryParams['mileStoneDetails'] = jsonEncode(milestoneList);
      }

      print(queryParams);
      final formMap = Map<String, dynamic>.from(queryParams);

      if (pickedImages.isNotEmpty) {
        formMap['attachments'] = pickedImages.map((file) {
          return diox.MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          );
        }).toList();
      }

      try {
        showGetXCircularDialog();

        final formData = diox.FormData.fromMap(formMap);

        final response = await dio.post(
          'https://app.superinstajobs.com/api/v1/add-proposal',
          data: formData,
          options: diox.Options(headers: headers),
        );

        Get.back();

        if (response.statusCode == 201 ) {
          Get.until((route) => route.isFirst);
          showSuccess(title: 'Job', message: 'Job Proposal sent successfully');
        } else {
          throw Exception('Fassiled with status ${response.statusCode}');
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        showError(title: 'Post Job', message: e.toString());
      }
    }

  }

}
