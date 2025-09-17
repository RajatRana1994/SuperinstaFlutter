import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/models/jobs_model.dart';
import 'package:instajobs/models/offer-details_model.dart';
import 'package:instajobs/models/offer_tab_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/forgot_pass.dart';
import 'package:instajobs/models/feed_tab_model.dart';
import '../network/network_service.dart';

class JobRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<JobsModel>> getJobsApi({int page = 1}) async {
    return await _networkService.get<JobsModel>(
      path: 'jobs-listing?limit=10&page=$page',
      converter: (data) => JobsModel.fromJson(data),
    );
  }


  Future<ApiResponse<OfferTabModel>> getOffersApi() async {
    return await _networkService.get<OfferTabModel>(
      path: 'offers?page=1&limit=50',
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferTabModel.fromJson(data);
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

  Future<ApiResponse<JobDetailsModel>> getJobDetails(String jobId) async {
    return await _networkService.get<JobDetailsModel>(
      path: 'job-details/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }


  Future<ApiResponse<JobDetailsModel>> rejectJobMilestone(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'reject-job-mileStone/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }


  Future<ApiResponse<JobDetailsModel>> startJobMilestone(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'start-new-mileStone/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<JobDetailsModel>> submitJobMilestone(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'submit-job-mileStone/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<JobDetailsModel>> submitJob(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'submit-job-project/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<JobDetailsModel>> rejectJob(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'reject-job-project/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<JobDetailsModel>> acceptJob(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'accept-job-project/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<JobDetailsModel>> acceptJobMilestone(String jobId) async {
    return await _networkService.post<JobDetailsModel>(
      path: 'accept-job-mileStone/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
      },
    );
  }



  Future<ApiResponse<AppSettingModel>> getAppSetting() async {
    print('objectsss');
    return await _networkService.get<AppSettingModel>(
      path: "app-settings",
      converter: (data) {
        // The converter is only called for successful responses now
        return AppSettingModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<OfferDetailsModel>> getOfferDetails(String offerId) async {
    return await _networkService.get<OfferDetailsModel>(
      path: 'offer-details/$offerId',
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> boostMyOffer(String feedId, String amount) async {
    return await _networkService.post<FeedTabModel>(
      path: 'boost-offers',
      data: {'amount': amount, 'offerId': feedId},
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<FeedTabModel>> boostMyJob(String feedId, String amount) async {
    return await _networkService.post<FeedTabModel>(
      path: 'boost-jobs',
      data: {'amount': amount, 'jobId': feedId},
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ForgotPassModel>> acceptProposal({
    required String id,
    required String assignUserId,
    required String acceptedBudget,
    required String jobProposalId,
  }) async {
    return await _networkService.put<ForgotPassModel>(
      path: 'accept-proposal/$id',
      data: {'assignUserId': assignUserId, 'acceptedBudget': acceptedBudget, 'jobProposalId': jobProposalId},
      converter: (data) {
        // The converter is only called for successful responses now
        return ForgotPassModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<ForgotPassModel>> rejectProposal({
    required String jobProposalId,
  }) async {
    return await _networkService.patch<ForgotPassModel>(
      path: 'reject-proposal/$jobProposalId',
      data: {},
      converter: (data) {
        // The converter is only called for successful responses now
        return ForgotPassModel.fromJson(data);
      },
    );
  }
}
