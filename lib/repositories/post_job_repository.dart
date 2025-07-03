import '../models/customer_sign_up_model.dart';
import '../network/network_service.dart';

class PostJObRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<CustomerSignUpModel>> postJobApi({
    required Map<String, dynamic> params,
  }) async {
    return await _networkService.post<CustomerSignUpModel>(
      path: 'add-job',
      data: params,
      converter: (data) {
        // The converter is only called for successful responses now
        return CustomerSignUpModel.fromJson(data);
      },
    );
  }
}