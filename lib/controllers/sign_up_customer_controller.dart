import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instajobs/models/customer_sign_up_model.dart';
import 'package:instajobs/models/user_data/user_model.dart';
import 'package:instajobs/repositories/authentification.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/home_page.dart';

import '../../network/api_url.dart';
import '../../network/network_service.dart';
import '../storage_services/local_stoage_service.dart';
import '../utils/local_keys.dart';

class SignUpCustomerController extends GetxController with BaseClass {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  bool get getPasswordStatus => _isPasswordVisible;

  bool get getConfirmPasswordStatus => _isConfirmPasswordVisible;

  updatePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }

  updateConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    update();
  }

  void resetItems() {
    nameController.text = '';
    phoneController.text = '';
    emailController.text = '';
    passwordController.text = '';
    confirmPassController.text = '';
    cityController.text = '';
    stateController.text = '';
    countryController.text = '';
    _isPasswordVisible = true;
    _isConfirmPasswordVisible = true;
  }

  Future<void> callSignUpApi() async {
    try {
      showGetXCircularDialog();
      final response = await SignUpRepository().callCustomerApi(
        params: {
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          'email': emailController.text.trim(),
          'categoryId': "1",
          'descriptions': 'This is description',
          'password': passwordController.text.trim(),
          'userType': 'Customer',
          'subCategoryId': '4,3,2,1',
          'state': stateController.text.trim(),
          'city': cityController.text.trim(),
          'street': "test",
          'country': countryController.text.trim(),
          'latitude': 30.3456,
          'longitude': 74.23232,
          'languages': "English",
        },
      );
      Get.back();
      if (response.isSuccess) {
        CustomerSignUpModelData? customerSignUpModel = response.data?.data;

        UserDataModel userDataModel = UserDataModel();
        userDataModel.authToken = customerSignUpModel?.authorizationKey ?? '';
        userDataModel.fullName = customerSignUpModel?.name ?? '';
        userDataModel.userEmail = customerSignUpModel?.email ?? '';
        userDataModel.isLoggedIn = true;
        userDataModel.userType = 'customer';
        userDataModel.isCustomer = true;
        await StorageService().saveData(
          LocalKeys.userData,
          userDataModel.toMap(userDataModel),
        );
        await NetworkService().setLoginToken(userDataModel.authToken);
        Get.offAll(() => HomePage());
      } else {
        throw response.message.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> verifyPin({required String pin}) async {
    try {
      final response = await SignUpRepository().verifyPin(params: {"otp": pin});
      if (response.isSuccess) {
      } else {
        throw response.message.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
