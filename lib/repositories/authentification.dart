import 'package:instajobs/models/categoris.dart';
import 'package:instajobs/models/forgot_pass.dart';
import 'package:instajobs/models/subCategory_model.dart';
import 'package:instajobs/models/tags_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

import '../models/customer_sign_up_model.dart';
import '../models/login.dart';
import '../network/api_url.dart';
import '../network/network_service.dart';

class SignUpRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<CustomerSignUpModel>> callCustomerApi({
    required Map<String, dynamic> params,
  }) async {
    return await _networkService.post<CustomerSignUpModel>(
      path: ApiUrlConstants.signUp,
      data: params,
      converter: (data) {
        // The converter is only called for successful responses now
        return CustomerSignUpModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<CustomerSignUpModel>> verifyPin({
    required Map<String, dynamic> params,
  }) async {
    return await _networkService.put<CustomerSignUpModel>(
      path: ApiUrlConstants.getPin(),
      data: params,

      converter: (data) {
        // The converter is only called for successful responses now
        return CustomerSignUpModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<CategoriesModel>> getCategories() async {
    return await _networkService.get<CategoriesModel>(
      path: ApiUrlConstants.categories,

      converter: (data) {
        // The converter is only called for successful responses now
        return CategoriesModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<TagsModel>> getExperience({required String categoryId}) async {
    return await _networkService.get<TagsModel>(
      path: 'tags?categoryId=$categoryId&limit=100&page=1',

      converter: (data) {
        // The converter is only called for successful responses now
        return TagsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<SubCategoryModel>> getSubCategories({
    required String categoryId,
  }) async {
    return await _networkService.get<SubCategoryModel>(
      path: ApiUrlConstants.getSubCategories(categoryId),

      converter: (data) {
        // The converter is only called for successful responses now
        return SubCategoryModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<LoginModel>> callLoginApi({
    required Map<String, dynamic> params,
  }) async {
    return await _networkService.postFormData<LoginModel>(
      path: ApiUrlConstants.signIn,
      data: params,
      converter: (data) => LoginModel.fromJson(data),
    );
  }

  Future<ApiResponse<ForgotPassModel>> forgotPassword({
    required Map<String, dynamic> params,
  }) async {
    return await _networkService.postFormData<ForgotPassModel>(
      path: 'forgot-password',
      data: params,
      converter: (data) => ForgotPassModel.fromJson(data),
    );
  }

  Future<ApiResponse<ForgotPassModel>> resetPassword({
    required String newPassword,
    required String forgotPasswordToken,
  }) async {
    return await _networkService.postFormData<ForgotPassModel>(
      path: 'rest-password/$forgotPasswordToken',
      data: {"new_password": newPassword},
      converter: (data) => ForgotPassModel.fromJson(data),
    );
  }
}
