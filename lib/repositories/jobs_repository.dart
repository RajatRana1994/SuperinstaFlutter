import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/models/jobs_model.dart';
import 'package:instajobs/models/offer-details_model.dart';
import 'package:instajobs/models/offer_tab_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/forgot_pass.dart';

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

  Future<ApiResponse<JobDetailsModel>> getJobDetails(String jobId) async {
    return await _networkService.get<JobDetailsModel>(
      path: 'job-details/$jobId',
      converter: (data) {
        // The converter is only called for successful responses now
        return JobDetailsModel.fromJson(data);
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
