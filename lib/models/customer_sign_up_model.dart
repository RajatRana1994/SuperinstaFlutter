///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CustomerSignUpModelDataNotifications {
/*
{
  "userId": 8,
  "newOfferUpload": 1,
  "likeAndComment": 1,
  "directMessage": 1,
  "pauseAll": 0
}
*/

  int? userId;
  int? newOfferUpload;
  int? likeAndComment;
  int? directMessage;
  int? pauseAll;

  CustomerSignUpModelDataNotifications({
    this.userId,
    this.newOfferUpload,
    this.likeAndComment,
    this.directMessage,
    this.pauseAll,
  });
  CustomerSignUpModelDataNotifications.fromJson(Map<String, dynamic> json) {
    userId = json['userId']?.toInt();
    newOfferUpload = json['newOfferUpload']?.toInt();
    likeAndComment = json['likeAndComment']?.toInt();
    directMessage = json['directMessage']?.toInt();
    pauseAll = json['pauseAll']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['newOfferUpload'] = newOfferUpload;
    data['likeAndComment'] = likeAndComment;
    data['directMessage'] = directMessage;
    data['pauseAll'] = pauseAll;
    return data;
  }
}

class CustomerSignUpModelDataWalletInfo {
/*
{
  "id": 7,
  "userId": 8,
  "balance": 0,
  "currency": "NGN",
  "created": 1745829928,
  "modified": 1745829928
}
*/

  int? id;
  int? userId;
  int? balance;
  String? currency;
  int? created;
  int? modified;

  CustomerSignUpModelDataWalletInfo({
    this.id,
    this.userId,
    this.balance,
    this.currency,
    this.created,
    this.modified,
  });
  CustomerSignUpModelDataWalletInfo.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    userId = json['userId']?.toInt();
    balance = json['balance']?.toInt();
    currency = json['currency']?.toString();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['balance'] = balance;
    data['currency'] = currency;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}

class CustomerSignUpModelDataCategorySubCategory {
/*
{
  "subCategoryId": 4,
  "name": "Painter",
  "image": ""
}
*/

  int? subCategoryId;
  String? name;
  String? image;

  CustomerSignUpModelDataCategorySubCategory({
    this.subCategoryId,
    this.name,
    this.image,
  });
  CustomerSignUpModelDataCategorySubCategory.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subCategoryId']?.toInt();
    name = json['name']?.toString();
    image = json['image']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['subCategoryId'] = subCategoryId;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class CustomerSignUpModelDataCategory {
/*
{
  "categoryId": 1,
  "categoryName": "Builders",
  "categoryImage": "https://app.superinstajobs.com/uploads/1722582520107.6833.png",
  "subCategory": [
    {
      "subCategoryId": 4,
      "name": "Painter",
      "image": ""
    }
  ]
}
*/

  int? categoryId;
  String? categoryName;
  String? categoryImage;
  List<CustomerSignUpModelDataCategorySubCategory?>? subCategory;

  CustomerSignUpModelDataCategory({
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.subCategory,
  });
  CustomerSignUpModelDataCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId']?.toInt();
    categoryName = json['categoryName']?.toString();
    categoryImage = json['categoryImage']?.toString();
    if (json['subCategory'] != null) {
      final v = json['subCategory'];
      final arr0 = <CustomerSignUpModelDataCategorySubCategory>[];
      v.forEach((v) {
        arr0.add(CustomerSignUpModelDataCategorySubCategory.fromJson(v));
      });
      subCategory = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['categoryImage'] = categoryImage;
    if (subCategory != null) {
      final v = subCategory;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['subCategory'] = arr0;
    }
    return data;
  }
}

class CustomerSignUpModelDataWorkingHours {
/*
{
  "sunday": "",
  "monday": "",
  "tuesday": "",
  "wednesday": "",
  "thursday": "",
  "friday": "",
  "saturday": ""
}
*/

  String? sunday;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;

  CustomerSignUpModelDataWorkingHours({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });
  CustomerSignUpModelDataWorkingHours.fromJson(Map<String, dynamic> json) {
    sunday = json['sunday']?.toString();
    monday = json['monday']?.toString();
    tuesday = json['tuesday']?.toString();
    wednesday = json['wednesday']?.toString();
    thursday = json['thursday']?.toString();
    friday = json['friday']?.toString();
    saturday = json['saturday']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sunday'] = sunday;
    data['monday'] = monday;
    data['tuesday'] = tuesday;
    data['wednesday'] = wednesday;
    data['thursday'] = thursday;
    data['friday'] = friday;
    data['saturday'] = saturday;
    return data;
  }
}

class CustomerSignUpModelData {
/*
{
  "id": 8,
  "email": "Sonal12@gmail.com",
  "name": "Sonal ",
  "phone": "12121212122",
  "userTypes": 0,
  "descriptions": "This is description",
  "totalJobs": 0,
  "totalHours": 0,
  "totalEarning": 0,
  "status": 0,
  "country": "India",
  "state": "HP",
  "city": "UNA",
  "street": "421 House no",
  "latitude": 30.3456,
  "longitude": 74.23232,
  "isEmailVerify": 0,
  "isPhoneVerify": 0,
  "profile": "",
  "boostTime": 0,
  "isBoosted": 0,
  "isBlock": 0,
  "hourlyPrice": 0,
  "dailyPrice": 0,
  "workingHours": {
    "sunday": "",
    "monday": "",
    "tuesday": "",
    "wednesday": "",
    "thursday": "",
    "friday": "",
    "saturday": ""
  },
  "favVendor": 0,
  "isBankLinked": 0,
  "attachments": [
    ""
  ],
  "category": [
    {
      "categoryId": 1,
      "categoryName": "Builders",
      "categoryImage": "https://app.superinstajobs.com/uploads/1722582520107.6833.png",
      "subCategory": [
        {
          "subCategoryId": 4,
          "name": "Painter",
          "image": ""
        }
      ]
    }
  ],
  "walletInfo": {
    "id": 7,
    "userId": 8,
    "balance": 0,
    "currency": "NGN",
    "created": 1745829928,
    "modified": 1745829928
  },
  "notifications": {
    "userId": 8,
    "newOfferUpload": 1,
    "likeAndComment": 1,
    "directMessage": 1,
    "pauseAll": 0
  },
  "authorizationKey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwicGhvbmUiOiIxMjEyMTIxMjEyMiIsImVtYWlsIjoiU29uYWwxMkBnbWFpbC5jb20iLCJpYXQiOjE3NDU4Mjk5Mjh9._NpLiXBMdUF5zWIOe5iS0t2LNxAZObmH4pg9HQcOJ_I"
}
*/

  int? id;
  String? email;
  String? name;
  String? phone;
  int? userTypes;
  String? descriptions;
  int? totalJobs;
  int? totalHours;
  int? totalEarning;
  int? status;
  String? country;
  String? state;
  String? city;
  String? street;
  double? latitude;
  double? longitude;
  int? isEmailVerify;
  int? isPhoneVerify;
  String? profile;
  int? boostTime;
  int? isBoosted;
  int? isBlock;
  int? hourlyPrice;
  int? dailyPrice;
  CustomerSignUpModelDataWorkingHours? workingHours;
  int? favVendor;
  int? isBankLinked;
  List<String?>? attachments;
  List<CustomerSignUpModelDataCategory?>? category;
  CustomerSignUpModelDataWalletInfo? walletInfo;
  CustomerSignUpModelDataNotifications? notifications;
  String? authorizationKey;

  CustomerSignUpModelData({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.userTypes,
    this.descriptions,
    this.totalJobs,
    this.totalHours,
    this.totalEarning,
    this.status,
    this.country,
    this.state,
    this.city,
    this.street,
    this.latitude,
    this.longitude,
    this.isEmailVerify,
    this.isPhoneVerify,
    this.profile,
    this.boostTime,
    this.isBoosted,
    this.isBlock,
    this.hourlyPrice,
    this.dailyPrice,
    this.workingHours,
    this.favVendor,
    this.isBankLinked,
    this.attachments,
    this.category,
    this.walletInfo,
    this.notifications,
    this.authorizationKey,
  });
  CustomerSignUpModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    email = json['email']?.toString();
    name = json['name']?.toString();
    phone = json['phone']?.toString();
    userTypes = json['userTypes']?.toInt();
    descriptions = json['descriptions']?.toString();
    totalJobs = json['totalJobs']?.toInt();
    totalHours = json['totalHours']?.toInt();
    totalEarning = json['totalEarning']?.toInt();
    status = json['status']?.toInt();
    country = json['country']?.toString();
    state = json['state']?.toString();
    city = json['city']?.toString();
    street = json['street']?.toString();
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    isEmailVerify = json['isEmailVerify']?.toInt();
    isPhoneVerify = json['isPhoneVerify']?.toInt();
    profile = json['profile']?.toString();
    boostTime = json['boostTime']?.toInt();
    isBoosted = json['isBoosted']?.toInt();
    isBlock = json['isBlock']?.toInt();
    hourlyPrice = json['hourlyPrice']?.toInt();
    dailyPrice = json['dailyPrice']?.toInt();
    workingHours = (json['workingHours'] != null) ? CustomerSignUpModelDataWorkingHours.fromJson(json['workingHours']) : null;
    favVendor = json['favVendor']?.toInt();
    isBankLinked = json['isBankLinked']?.toInt();
    if (json['attachments'] != null) {
      final v = json['attachments'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      attachments = arr0;
    }
    if (json['category'] != null) {
      final v = json['category'];
      final arr0 = <CustomerSignUpModelDataCategory>[];
      v.forEach((v) {
        arr0.add(CustomerSignUpModelDataCategory.fromJson(v));
      });
      category = arr0;
    }
    walletInfo = (json['walletInfo'] != null) ? CustomerSignUpModelDataWalletInfo.fromJson(json['walletInfo']) : null;
    notifications = (json['notifications'] != null) ? CustomerSignUpModelDataNotifications.fromJson(json['notifications']) : null;
    authorizationKey = json['authorizationKey']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['userTypes'] = userTypes;
    data['descriptions'] = descriptions;
    data['totalJobs'] = totalJobs;
    data['totalHours'] = totalHours;
    data['totalEarning'] = totalEarning;
    data['status'] = status;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['street'] = street;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['isEmailVerify'] = isEmailVerify;
    data['isPhoneVerify'] = isPhoneVerify;
    data['profile'] = profile;
    data['boostTime'] = boostTime;
    data['isBoosted'] = isBoosted;
    data['isBlock'] = isBlock;
    data['hourlyPrice'] = hourlyPrice;
    data['dailyPrice'] = dailyPrice;
    if (workingHours != null) {
      data['workingHours'] = workingHours!.toJson();
    }
    data['favVendor'] = favVendor;
    data['isBankLinked'] = isBankLinked;
    if (attachments != null) {
      final v = attachments;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['attachments'] = arr0;
    }
    if (category != null) {
      final v = category;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['category'] = arr0;
    }
    if (walletInfo != null) {
      data['walletInfo'] = walletInfo!.toJson();
    }
    if (notifications != null) {
      data['notifications'] = notifications!.toJson();
    }
    data['authorizationKey'] = authorizationKey;
    return data;
  }
}

class CustomerSignUpModel {
/*
{
  "success": true,
  "message": "Signup successfully",
  "status": 200,
  "data": {
    "id": 8,
    "email": "Sonal12@gmail.com",
    "name": "Sonal ",
    "phone": "12121212122",
    "userTypes": 0,
    "descriptions": "This is description",
    "totalJobs": 0,
    "totalHours": 0,
    "totalEarning": 0,
    "status": 0,
    "country": "India",
    "state": "HP",
    "city": "UNA",
    "street": "421 House no",
    "latitude": 30.3456,
    "longitude": 74.23232,
    "isEmailVerify": 0,
    "isPhoneVerify": 0,
    "profile": "",
    "boostTime": 0,
    "isBoosted": 0,
    "isBlock": 0,
    "hourlyPrice": 0,
    "dailyPrice": 0,
    "workingHours": {
      "sunday": "",
      "monday": "",
      "tuesday": "",
      "wednesday": "",
      "thursday": "",
      "friday": "",
      "saturday": ""
    },
    "favVendor": 0,
    "isBankLinked": 0,
    "attachments": [
      ""
    ],
    "category": [
      {
        "categoryId": 1,
        "categoryName": "Builders",
        "categoryImage": "https://app.superinstajobs.com/uploads/1722582520107.6833.png",
        "subCategory": [
          {
            "subCategoryId": 4,
            "name": "Painter",
            "image": ""
          }
        ]
      }
    ],
    "walletInfo": {
      "id": 7,
      "userId": 8,
      "balance": 0,
      "currency": "NGN",
      "created": 1745829928,
      "modified": 1745829928
    },
    "notifications": {
      "userId": 8,
      "newOfferUpload": 1,
      "likeAndComment": 1,
      "directMessage": 1,
      "pauseAll": 0
    },
    "authorizationKey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwicGhvbmUiOiIxMjEyMTIxMjEyMiIsImVtYWlsIjoiU29uYWwxMkBnbWFpbC5jb20iLCJpYXQiOjE3NDU4Mjk5Mjh9._NpLiXBMdUF5zWIOe5iS0t2LNxAZObmH4pg9HQcOJ_I"
  }
}
*/

  bool? success;
  String? message;
  int? status;
  CustomerSignUpModelData? data;

  CustomerSignUpModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });
  CustomerSignUpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data = (json['data'] != null) ? CustomerSignUpModelData.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
