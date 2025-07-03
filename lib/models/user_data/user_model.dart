class UserDataModel {
  String? userId;
  String? authToken;
  String? userEmail;
  String? fullName;
  String? phoneNumber;
  bool? isLoggedIn;
  String? userType;
  bool? isCustomer;
  String? gender;
  String? dob;
  String? userImage;

  /* UserDataModel(
      {this.userId,
        this.userName,
        this.fullName,
        this.userEmail,
        this.isLoggedIn,
        this.userNumber,this.authToken,});*/

  UserDataModel({
    this.userId,
    this.authToken,
    this.userEmail,
    this.gender,
    this.dob,
    this.isLoggedIn,
    this.fullName,
    this.phoneNumber,
    this.userType,
    this.userImage,
    this.isCustomer,
  });

  //////////

  String? getUserId() {
    return userId;
  }

  bool? isLogin() {
    return isLoggedIn;
  }

  String? getFullName() {
    return fullName;
  }

  setFullName(String isUserSub) {
    fullName = isUserSub;
  }

  String? getAuthToken() {
    return authToken;
  }

  setAuthToken(String token) {
    authToken = token;
  }

  String? getUserImage() {
    return userImage;
  }

  setUserImage(String isUserSub) {
    userImage = isUserSub;
  }

  String? getUserType() {
    return userType;
  }

  setUserType(String isUserSub) {
    userType = isUserSub;
  }

  bool? isCustomerType() {
    return isCustomer;
  }

  setIsCustomerType(bool isUserSub) {
    isCustomer = isUserSub;
  }

  String? getPhoneNumber() {
    return phoneNumber;
  }

  setPhoneNumber(String isUserSub) {
    phoneNumber = isUserSub;
  }

  String? getEmail() {
    return userEmail;
  }

  setLogin(bool isLogin) {
    isLoggedIn = isLogin;
  }

  setUserId(String id) {
    userId = id;
  }

  setUserEmail(String email) {
    userEmail = email;
  }

  Map<String, dynamic> toMap(UserDataModel user) => {
    'id': user.userId,
    'authToken': user.authToken,
    'email': user.userEmail,
    'isLoggedIn': user.isLoggedIn,
    'phoneNumber': user.phoneNumber,
    'fullName': user.fullName,
    'userImage': user.userImage,
    'isCustomerType': user.isCustomer,

    'userType': user.userType,
  };

  factory UserDataModel.fromJson(Map<String, dynamic> jsonData) {
    return UserDataModel(
      userId: jsonData['id'],
      authToken: jsonData['authToken'],
      userEmail: jsonData['email'],
      isLoggedIn: jsonData['isLoggedIn'],
      phoneNumber: jsonData['phoneNumber'],
      userImage: jsonData['userImage'],
      isCustomer: jsonData['isCustomerType'],

      fullName: jsonData['fullName'],
      userType: jsonData['userType'],
    );
  }
}
