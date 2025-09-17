import 'dart:io';
import 'package:dio/dio.dart' as diox;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/models/tags_model.dart';
import 'package:instajobs/repositories/post_job_repository.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../../models/categoris.dart';
import '../../models/subCategory_model.dart';
import '../../repositories/authentification.dart';
import '../../repositories/home_tab_repository.dart';
import '../../storage_services/local_stoage_service.dart';

class PostJobController extends GetxController with BaseClass {
  resetItems() {
    categoriesData = null;
    subCategoriesData = null;
    selectedCategory = null;
    selectedSubCategory = null;
    selectedExperience = null;
    selectedDelivery = null;
    tagsData = null;
    titleController.text = '';
    priceFromController.text = '';
    priceToController.text = '';
    budgetController.text = '';
    countryController.text = '';
    stateController.text = '';
    descriptionController.text = '';
    pickedImages.clear();
  }

  ///--
  TextEditingController titleController = TextEditingController();
  TextEditingController priceFromController = TextEditingController();
  TextEditingController priceToController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double? lat;
  double? lng;
  ///--
  List<CategoriesModelDataCategories?>? categoriesData;
  List<TagsModelDataData?>? tagsData;
  List<SubCategoryModelDataSubCategories?>? subCategoriesData;
  CategoriesModelDataCategories? selectedCategory;

  SubCategoryModelDataSubCategories? selectedSubCategory;

  String? selectedExperience;

  int? selectedDelivery;
  PostJObRepository postJObRepository = PostJObRepository();

  List<String> experienceList = ['Entry Level', 'Intermediate', 'Expert'];

  updateTagSelection(int index, bool isSelected) {
    tagsData?.elementAt(index)?.isSelected = !isSelected;
    update();
  }

  Future<void> getCategories() async {
    categoriesData = null;
    final response = await SignUpRepository().getCategories();
    if (response.isSuccess) {
      categoriesData = response.data?.data?.categories ?? [];
      if (categoriesData?.isNotEmpty ?? false) {
        selectedCategory = categoriesData?.elementAt(0);
        selectedCategory = categoriesData?.elementAt(0);
        await getExperience(categoryId: selectedCategory?.id.toString() ?? '');
        await getSubCategories(
          categoryId: selectedCategory?.id.toString() ?? '',
        );
      }
    } else {
      categoriesData = [];
    }
    update();
  }

  Future<void> getExperience({required String categoryId}) async {
    tagsData = null;
    final response = await SignUpRepository().getExperience(
      categoryId: categoryId,
    );
    if (response.isSuccess) {
      tagsData = response.data?.data?.data ?? [];
    } else {
      tagsData = [];
    }
    update();
  }

  Future<void> getSubCategories({required String categoryId}) async {
    subCategoriesData = null;
    showGetXCircularDialog();

    final response = await SignUpRepository().getSubCategories(
      categoryId: categoryId,
    );

    Get.back();
    if (response.isSuccess) {
      subCategoriesData = response.data?.data?.subCategories ?? [];
    } else {
      subCategoriesData = [];
    }
    update();
  }

  Future<void> postJobAPi() async {
    showGetXCircularDialog();
    final List<TagsModelDataData?> tags = tagsData ?? [];

    final String selectedTags = tags
        .where((tag) => tag?.isSelected == true)
        .map((tag) => tag?.name ?? '')
        .join(', ');
    Map<String, dynamic> map = {
      'title': titleController.text.trim(),
      'categoryId': selectedCategory?.id ?? '',
      'devilryTime': selectedDelivery,
      //country:India
      'descriptions': descriptionController.text.trim(),
      //latitude:30.35434
      //longitude:74.23232
      'totalBudgets': budgetController.text.trim(),
      'state': stateController.text.trim(),
      'subCategoryId': selectedSubCategory?.id ?? '',
      'isAnyWhere': '0',
      'longitude': lng,
      'latitude': lat,
      'country': countryController.text.trim(),

      'priceTo': priceToController.text.trim(),
      'priceForm': priceFromController.text.trim(),
      'skills': selectedTags,
      'experience': selectedExperience,
    };
    print(map);
    final response = await postJObRepository.postJobApi(params: map);

    Get.back();
    if (response.isSuccess) {
      Get.back();
      showSuccess(title: 'Posted', message: 'Job posted successfully');
    } else {
      showError(title: 'Not Posted', message: 'Job is Not posted');
    }

    update();
  }

  ///----
  final ImagePicker _picker = ImagePicker();
  final List<File> pickedImages = [];
  final Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Authorization": StorageService().getUserData().getAuthToken() ?? '',
  };
  Map<String, dynamic> queryParams = {};

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

  Future<void> uploadImages() async {
    if (pickedImages.isEmpty) return;

    final dio = diox.Dio();
    final List<TagsModelDataData?> tags = tagsData ?? [];

    final String selectedTags = tags
        .where((tag) => tag?.isSelected == true)
        .map((tag) => tag?.name ?? '')
        .join(', ');
    queryParams.addAll({
      'title': titleController.text.trim(),
      'categoryId': selectedCategory?.id ?? '',
      'devilryTime': selectedDelivery,
      //country:India
      'descriptions': descriptionController.text.trim(),
      //latitude:30.35434
      //longitude:74.23232
      'totalBudgets': budgetController.text.trim(),
      'state': stateController.text.trim(),
      'subCategoryId': selectedSubCategory?.id ?? '',
      'isAnyWhere': '0',
      'longitude': lat,
      'latitude': lng,
      'country': countryController.text.trim(),

      'priceTo': priceToController.text.trim(),
      'priceForm': priceFromController.text.trim(),
      'skills': selectedTags,
      'experience': selectedExperience,
    });
    try {
      showGetXCircularDialog();
      // Build multipart form data
      final formData = diox.FormData.fromMap({
        ...queryParams,
        'attachments':
        pickedImages.map((file) {
          return diox.MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          );
        }).toList(),
      });

      final response = await dio.post(
        'https://app.superinstajobs.com/api/v1/add-job',
        data: formData,
        options: diox.Options(headers: headers),
      );

      Get.back();
      if (response.statusCode == 200) {
        Get.back();
        showSuccess(title: 'Post Job', message: 'Job posted successfully');
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showError(title: 'Post Job', message: e.toString());
    }
  }
}
