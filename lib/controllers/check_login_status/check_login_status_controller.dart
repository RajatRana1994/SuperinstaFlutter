import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instajobs/views/home_page.dart';
import 'package:instajobs/views/how_it_works/how_it_works_page.dart';
import 'package:instajobs/views/welcome_page.dart';

import '../../models/user_data/user_model.dart';
import '../../utils/local_keys.dart';


class CheckLoginStatusController extends GetxController {
  final localStorage = GetStorage();

  checkLogin() async {
    final prefData = localStorage.read(LocalKeys.userData);

    if (prefData != null) {
      var result = UserDataModel.fromJson(prefData);
      if (result.isLoggedIn == null || result.isLoggedIn == false) {
        //Get.offAll(() => const ChooseRolePage(isAskingLogin:true));

        Get.offAll(() => HowItWorksPage/*WelcomePage*/());

      } else {

        Get.offAll(() => const HomePage());


      }
    } else {
      //  Get.offAll(() => const ChooseRolePage(isAskingLogin: true));
      Get.offAll(() => /*WelcomePage*/HowItWorksPage());
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 3000), () {
      checkLogin();
    });
  }
}
