import 'package:instajobs/models/categoris.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:instajobs/models/feed_model.dart';
import 'package:instajobs/models/feed_tab_model.dart';
import 'package:instajobs/models/offers_model.dart';
import 'package:instajobs/models/popular_service_details_model/popular_services_details_model.dart';
import 'package:instajobs/models/portfolio_model.dart';
import 'package:instajobs/models/subCategory_model.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

import '../models/customer_sign_up_model.dart';
import '../models/login.dart';
import '../network/api_url.dart';
import '../network/network_service.dart';

class AppointmentRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<FeedTabModel>> createAppointment(Map<String,dynamic> data) async {
    return await _networkService.postFormData<FeedTabModel>(
      path: 'create-booking',
      data: data,
      converter: (data) {
        // The converter is only called for successful responses now
        return FeedTabModel.fromJson(data);
      },
    );
  }
}
