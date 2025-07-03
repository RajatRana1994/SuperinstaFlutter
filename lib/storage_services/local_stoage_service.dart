import 'package:get_storage/get_storage.dart';
import '../../utils/local_keys.dart';
import '../models/user_data/user_model.dart';


class StorageService {
  Future<void> clearData() async {
    //Get.reset();

    await _getStorage.remove(LocalKeys.userData);
  }

  static final StorageService _instance = StorageService._internal();
  late GetStorage _getStorage;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  init() {
    _getStorage = GetStorage();
  }

  //  Storing and retrieving data
  saveData(String key, Map<String, dynamic> value) {
    //  print("///");
    //  print(value);
    _getStorage.write(key, value);
  }

  saveBooleanData(String key, bool data) {
    _getStorage.write(key, data);
  }

  loadData(String key) {
    return _getStorage.read(key);
  }

  UserDataModel getUserData() {
    final prefData = loadData(LocalKeys.userData);
    if (prefData == null) return UserDataModel();
    UserDataModel result = UserDataModel.fromJson(prefData);
    return result;
  }

  bool isLoggedIn() {
    final prefData = loadData(LocalKeys.userData);
    if (prefData == null) {
      return false;
    }
    UserDataModel result = UserDataModel.fromJson(prefData);
    return result.isLoggedIn ?? false;
  }

  String getUserId() {
    return getUserData().getUserId() ?? "";
  }

}
