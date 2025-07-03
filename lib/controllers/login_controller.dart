import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instajobs/repositories/authentification.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../../network/api_url.dart';
import '../../network/network_service.dart';
import '../models/login.dart';
import '../models/user_data/user_model.dart';
import '../storage_services/local_stoage_service.dart';
import '../utils/local_keys.dart';
import '../views/home_page.dart';

class LoginController extends GetxController with BaseClass{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  bool _isPasswordVisible = true;
  final NetworkService _networkService = NetworkService();

  bool get getPasswordStatus => _isPasswordVisible;

  updatePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }

  Future<void> callLoginApi() async {
    try {
      showGetXCircularDialog();
      final response = await SignUpRepository().callLoginApi(
        params: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          //userType:Customer
          "deviceType": "1",
          "deviceToken": "sdsdasdsadasdasdasdadasdsa",
        },
      );
      Get.back();
      if (response.isSuccess) {
        LoginModelData? loginModelData = response.data?.data;

        UserDataModel userDataModel = UserDataModel();
        userDataModel.authToken = loginModelData?.authorizationKey ?? '';
        userDataModel.fullName = loginModelData?.name ?? '';
        userDataModel.userEmail = loginModelData?.email ?? '';
        userDataModel.userId = loginModelData?.id.toString() ?? '';
        userDataModel.isLoggedIn = true;
        userDataModel.userType =
            loginModelData?.userTypes == 0 ? 'customer' : 'freelancer';
        userDataModel.isCustomer =
        loginModelData?.userTypes == 0 ? true : false;
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



}
