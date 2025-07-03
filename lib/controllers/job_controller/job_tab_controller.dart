import 'package:get/get.dart';
import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/models/jobs_model.dart';
import 'package:instajobs/models/offer-details_model.dart';
import 'package:instajobs/models/offer_tab_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/repositories/jobs_repository.dart';

class JobTabController extends GetxController {
  JobRepository jobRepository = JobRepository();
  List<JobsModelDataData?>? jobsList;
  List<OfferTabModelDataData?>? offersList;
  OfferDetailsModelData? offerDetailsModelData;
  JobDetailsModelData? jobDetailsModelData;

  Future<void> getJobsApi() async {
    try {
      jobsList = null;
      final response = await jobRepository.getJobsApi();

      if (response.isSuccess) {
        jobsList = response.data!.data?.data ?? [];
      } else {
        jobsList = [];
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }

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

  Future<void> getJobDetailsApi(String jobId) async {
    try {
      jobDetailsModelData = null;
      final response = await jobRepository.getJobDetails(jobId);

      if (response.isSuccess) {
        jobDetailsModelData = response.data?.data;
      } else {
        throw response.message.toString();
      }
      update();
    } catch (e) {
      throw e.toString();
    }
  }
}
