import 'package:instajobs/storage_services/local_stoage_service.dart';

class ApiUrlConstants {
  static String signUp = 'sign-up';
  static String homeListing = 'home-listing';
  static String feedTabData = 'feeds?limit=20&page=1';
  static String myFeedTabData = 'users/feed/';
  static String getSavedFeed = 'feed/save?page=1&limit=10';
  static String appSetting = 'app-settings';
  static String boostProfile = 'boost-profile';
  static String saveFeed = 'feed/like/';
  static String categories = 'categories';

  static String signIn = 'login';

  static String getSubCategories(String categoryId){
    return 'sub-categories/$categoryId?search=';
  }static String getPin(){
    return 'verify-otp';
  }

}