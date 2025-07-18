///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class UserFeedModelDataPagination {
/*
{
  "currentPage": 1,
  "totalPage": 1,
  "totalRecord": 6,
  "limit": 20
}
*/

  int? currentPage;
  int? totalPage;
  int? totalRecord;
  int? limit;

  UserFeedModelDataPagination({
    this.currentPage,
    this.totalPage,
    this.totalRecord,
    this.limit,
  });
  UserFeedModelDataPagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage']?.toInt();
    totalPage = json['totalPage']?.toInt();
    totalRecord = json['totalRecord']?.toInt();
    limit = json['limit']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPage'] = totalPage;
    data['totalRecord'] = totalRecord;
    data['limit'] = limit;
    return data;
  }
}

class UserFeedModelDataDataUsers {
/*
{
  "id": 2,
  "name": "Jyoti Builders",
  "email": "jyoti@yopmail.com",
  "phone": "7888644412",
  "profile": "https://app.superinstajobs.com/uploads/1743437099493.0781.jpg",
  "hourlyPrice": 10,
  "dailyPrice": 100
}
*/

  int? id;
  String? name;
  String? email;
  String? phone;
  String? profile;
  int? hourlyPrice;
  int? dailyPrice;

  UserFeedModelDataDataUsers({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.hourlyPrice,
    this.dailyPrice,
  });
  UserFeedModelDataDataUsers.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    profile = json['profile']?.toString();
    hourlyPrice = json['hourlyPrice']?.toInt();
    dailyPrice = json['dailyPrice']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['profile'] = profile;
    data['hourlyPrice'] = hourlyPrice;
    data['dailyPrice'] = dailyPrice;
    return data;
  }
}

class UserFeedModelDataDataFeedImages {
/*
{
  "id": 16,
  "feedId": 10,
  "images": "https://app.superinstajobs.com/uploads/false",
  "type": 0,
  "video": "https://app.superinstajobs.com/uploads/1742570161559.725.mp4",
  "created": 1742570162,
  "modified": 1742570162
}
*/

  int? id;
  int? feedId;
  String? images;
  int? type;
  String? video;
  int? created;
  int? modified;

  UserFeedModelDataDataFeedImages({
    this.id,
    this.feedId,
    this.images,
    this.type,
    this.video,
    this.created,
    this.modified,
  });
  UserFeedModelDataDataFeedImages.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    feedId = json['feedId']?.toInt();
    images = json['images']?.toString();
    type = json['type']?.toInt();
    video = json['video']?.toString();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['feedId'] = feedId;
    data['images'] = images;
    data['type'] = type;
    data['video'] = video;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}

class UserFeedModelDataData {
/*
{
  "id": 10,
  "userId": 2,
  "title": "Feed Data",
  "description": "Test vdo",
  "isBoosted": 1,
  "boostTime": 1744107642,
  "created": 1742570161,
  "modified": 1743502842,
  "isSaveFeed": 1,
  "totalCoins": 1,
  "totalComments": 0,
  "totalLikes": 0,
  "isLike": 0,
  "feedImages": [
    {
      "id": 16,
      "feedId": 10,
      "images": "https://app.superinstajobs.com/uploads/false",
      "type": 0,
      "video": "https://app.superinstajobs.com/uploads/1742570161559.725.mp4",
      "created": 1742570162,
      "modified": 1742570162
    }
  ],
  "users": {
    "id": 2,
    "name": "Jyoti Builders",
    "email": "jyoti@yopmail.com",
    "phone": "7888644412",
    "profile": "https://app.superinstajobs.com/uploads/1743437099493.0781.jpg",
    "hourlyPrice": 10,
    "dailyPrice": 100
  }
}
*/

  int? id;
  int? userId;
  String? title;
  String? description;
  int? isBoosted;
  int? boostTime;
  int? created;
  int? modified;
  int? isSaveFeed;
  String? totalCoins;
  int? totalComments;
  int? totalLikes;
  int? isLike;
  List<UserFeedModelDataDataFeedImages?>? feedImages;
  UserFeedModelDataDataUsers? users;

  UserFeedModelDataData({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.isBoosted,
    this.boostTime,
    this.created,
    this.modified,
    this.isSaveFeed,
    this.totalCoins,
    this.totalComments,
    this.totalLikes,
    this.isLike,
    this.feedImages,
    this.users,
  });
  UserFeedModelDataData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    userId = json['userId']?.toInt();
    title = json['title']?.toString();
    description = json['description']?.toString();
    isBoosted = json['isBoosted']?.toInt();
    boostTime = json['boostTime']?.toInt();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
    isSaveFeed = json['isSaveFeed']?.toInt();
    totalCoins = json['totalCoins']?.toString();
    totalComments = json['totalComments']?.toInt();
    totalLikes = json['totalLikes']?.toInt();
    isLike = json['isLike']?.toInt();
    if (json['feedImages'] != null) {
      final v = json['feedImages'];
      final arr0 = <UserFeedModelDataDataFeedImages>[];
      v.forEach((v) {
        arr0.add(UserFeedModelDataDataFeedImages.fromJson(v));
      });
      feedImages = arr0;
    }
    users = (json['users'] != null) ? UserFeedModelDataDataUsers.fromJson(json['users']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['isBoosted'] = isBoosted;
    data['boostTime'] = boostTime;
    data['created'] = created;
    data['modified'] = modified;
    data['isSaveFeed'] = isSaveFeed;
    data['totalCoins'] = totalCoins;
    data['totalComments'] = totalComments;
    data['totalLikes'] = totalLikes;
    data['isLike'] = isLike;
    if (feedImages != null) {
      final v = feedImages;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['feedImages'] = arr0;
    }
    if (users != null) {
      data['users'] = users!.toJson();
    }
    return data;
  }
}

class UserFeedModelData {
/*
{
  "data": [
    {
      "id": 10,
      "userId": 2,
      "title": "Feed Data",
      "description": "Test vdo",
      "isBoosted": 1,
      "boostTime": 1744107642,
      "created": 1742570161,
      "modified": 1743502842,
      "isSaveFeed": 1,
      "totalCoins": 1,
      "totalComments": 0,
      "totalLikes": 0,
      "isLike": 0,
      "feedImages": [
        {
          "id": 16,
          "feedId": 10,
          "images": "https://app.superinstajobs.com/uploads/false",
          "type": 0,
          "video": "https://app.superinstajobs.com/uploads/1742570161559.725.mp4",
          "created": 1742570162,
          "modified": 1742570162
        }
      ],
      "users": {
        "id": 2,
        "name": "Jyoti Builders",
        "email": "jyoti@yopmail.com",
        "phone": "7888644412",
        "profile": "https://app.superinstajobs.com/uploads/1743437099493.0781.jpg",
        "hourlyPrice": 10,
        "dailyPrice": 100
      }
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPage": 1,
    "totalRecord": 6,
    "limit": 20
  }
}
*/

  List<UserFeedModelDataData?>? data;
  UserFeedModelDataPagination? pagination;

  UserFeedModelData({
    this.data,
    this.pagination,
  });
  UserFeedModelData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <UserFeedModelDataData>[];
      v.forEach((v) {
        arr0.add(UserFeedModelDataData.fromJson(v));
      });
      this.data = arr0;
    }
    pagination = (json['pagination'] != null) ? UserFeedModelDataPagination.fromJson(json['pagination']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class UserFeedModel {
/*
{
  "success": true,
  "message": "Feed listing",
  "status": 200,
  "data": {
    "data": [
      {
        "id": 10,
        "userId": 2,
        "title": "Feed Data",
        "description": "Test vdo",
        "isBoosted": 1,
        "boostTime": 1744107642,
        "created": 1742570161,
        "modified": 1743502842,
        "isSaveFeed": 1,
        "totalCoins": 1,
        "totalComments": 0,
        "totalLikes": 0,
        "isLike": 0,
        "feedImages": [
          {
            "id": 16,
            "feedId": 10,
            "images": "https://app.superinstajobs.com/uploads/false",
            "type": 0,
            "video": "https://app.superinstajobs.com/uploads/1742570161559.725.mp4",
            "created": 1742570162,
            "modified": 1742570162
          }
        ],
        "users": {
          "id": 2,
          "name": "Jyoti Builders",
          "email": "jyoti@yopmail.com",
          "phone": "7888644412",
          "profile": "https://app.superinstajobs.com/uploads/1743437099493.0781.jpg",
          "hourlyPrice": 10,
          "dailyPrice": 100
        }
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPage": 1,
      "totalRecord": 6,
      "limit": 20
    }
  }
}
*/

  bool? success;
  String? message;
  int? status;
  UserFeedModelData? data;

  UserFeedModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });
  UserFeedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data = (json['data'] != null) ? UserFeedModelData.fromJson(json['data']) : null;
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
