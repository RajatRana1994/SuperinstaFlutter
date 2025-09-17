import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instajobs/models/categoris.dart';
import 'package:instajobs/models/user_data/user_model.dart';
import 'package:instajobs/network/network_service.dart';

import '../models/subCategory_model.dart';
import '../repositories/authentification.dart';
import '../storage_services/local_stoage_service.dart';
import '../utils/local_keys.dart';

class FreelancerSignUp extends GetxController {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final List<String> languages = [];
  final List<int> selectedSubCategories = [];
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
    languages.clear();
    companyNameController.text = '';
    phoneController.text = '';
    emailController.text = '';
    passController.text = '';
    confirmPassController.text = '';
    descriptionController.text = '';
    cityController.text = '';
    stateController.text = '';
    countryController.text = '';
    _isPasswordVisible = true;
    _isConfirmPasswordVisible = true;
  }

  int selectedIndex = -1;

  updateSubCategorySelection({required int? id, required int index}) {
    if (selectedSubCategories.contains(id)) {
      subCategoriesData?.elementAt(index)?.isSelected = false;
      selectedSubCategories.remove(id);
    } else {
      selectedSubCategories.add(id!);
      subCategoriesData?.elementAt(index)?.isSelected = true;
    }
    update();
  }

  updateSelection(int index) {
    if (selectedIndex == index) {
      return;
    }
    categoriesData?.elementAt(index)?.isSelected = true;
    if (selectedIndex != -1) {
      categoriesData?.elementAt(selectedIndex)?.isSelected = false;
      selectedIndex = index;
    } else {
      selectedIndex = index;
    }
    update();
  }

  List<CategoriesModelDataCategories?>? categoriesData;
  List<SubCategoryModelDataSubCategories?>? subCategoriesData;

  Future<void> getCategories() async {
    categoriesData = null;
    final response = await SignUpRepository().getCategories();
    if (response.isSuccess) {
      categoriesData = response.data?.data?.categories ?? [];
    } else {
      categoriesData = [];
    }
    update();
  }

  Future<void> getSubCategories({required String categoryId}) async {
    subCategoriesData = null;
    final response = await SignUpRepository().getSubCategories(
      categoryId: categoryId,
    );
    if (response.isSuccess) {
      subCategoriesData = response.data?.data?.subCategories ?? [];
    } else {
      subCategoriesData = [];
    }
    update();
  }

  Future<void> callSignUpApi() async {
    try {
      final response = await SignUpRepository().callCustomerApi(
        params: {
          "name": companyNameController.text.trim(),
          "phone": phoneController.text.trim(),
          'email': emailController.text.trim(),
          'categoryId': categoriesData?.elementAt(selectedIndex)?.id.toString(),
          'descriptions': descriptionController.text.trim(),
          'password': passController.text.trim(),
          'userType': 'Freelancer',
          'subCategoryId': selectedSubCategories.join(','),
          'state': stateController.text.trim(),
          'city': cityController.text.trim(),
          'street': streetController.text.trim(),
          'country': countryController.text.trim(),
          'latitude': 30.3456,
          'longitude': 74.23232,
          'languages': "English",
        },
      );
      if (response.isSuccess) {
        UserDataModel userDataModel  = UserDataModel();
        userDataModel.authToken =response.data?.data?.authorizationKey??'';
        userDataModel.isLoggedIn =false;
        userDataModel.userEmail = response.data?.data?.email ?? '';
        userDataModel.fullName =  response.data?.data?.name ?? '';
        userDataModel.userType =
        response.data?.data?.userTypes == 0 ? 'customer' : 'freelancer';
        userDataModel.isCustomer =
        response.data?.data?.userTypes == 0 ? true : false;
        await StorageService().saveData(
          LocalKeys.userData,
          userDataModel.toMap(userDataModel),
        );
        NetworkService().setLoginToken(StorageService().getUserData().getAuthToken());
      } else {
        throw response.message.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
