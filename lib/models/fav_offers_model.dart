///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class FavOffersModelDataPagination {
/*
{
  "currentPage": 1,
  "totalPage": 1,
  "totalRecord": 1,
  "limit": 10
}
*/

  int? currentPage;
  int? totalPage;
  int? totalRecord;
  int? limit;

  FavOffersModelDataPagination({
    this.currentPage,
    this.totalPage,
    this.totalRecord,
    this.limit,
  });
  FavOffersModelDataPagination.fromJson(Map<String, dynamic> json) {
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

class FavOffersModelDataDataUsersOffersOfferImages {
/*
{
  "id": 5,
  "offerId": 2,
  "attachments": "https://app.superinstajobs.com/uploads/1738859997396.106.jpg",
  "created": 1738859997,
  "modified": 1738859997
}
*/

  int? id;
  int? offerId;
  String? attachments;
  int? created;
  int? modified;

  FavOffersModelDataDataUsersOffersOfferImages({
    this.id,
    this.offerId,
    this.attachments,
    this.created,
    this.modified,
  });
  FavOffersModelDataDataUsersOffersOfferImages.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    offerId = json['offerId']?.toInt();
    attachments = json['attachments']?.toString();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['offerId'] = offerId;
    data['attachments'] = attachments;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}

class FavOffersModelDataDataUsersOffersAdOn {
/*
{
  "price": "2000",
  "title": "Setting Tiles In Walls of Room",
  "workingDays": "2 Days"
}
*/

  String? price;
  String? title;
  String? workingDays;

  FavOffersModelDataDataUsersOffersAdOn({
    this.price,
    this.title,
    this.workingDays,
  });
  FavOffersModelDataDataUsersOffersAdOn.fromJson(Map<String, dynamic> json) {
    price = json['price']?.toString();
    title = json['title']?.toString();
    workingDays = json['workingDays']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['price'] = price;
    data['title'] = title;
    data['workingDays'] = workingDays;
    return data;
  }
}

class FavOffersModelDataDataUsersOffers {
/*
{
  "id": 2,
  "userId": 2,
  "name": "Tiles Setup In Room",
  "price": 2000,
  "description": "Setting tiles in a room.",
  "totalSold": 0,
  "deliveryTime": 4,
  "image": "",
  "adOn": [
    {
      "price": "2000",
      "title": "Setting Tiles In Walls of Room",
      "workingDays": "2 Days"
    }
  ],
  "isBoosted": 0,
  "boostTime": 0,
  "created": 1738859997,
  "modified": 1742060161,
  "offerImages": [
    {
      "id": 5,
      "offerId": 2,
      "attachments": "https://app.superinstajobs.com/uploads/1738859997396.106.jpg",
      "created": 1738859997,
      "modified": 1738859997
    }
  ]
}
*/

  int? id;
  int? userId;
  String? name;
  int? price;
  String? description;
  int? totalSold;
  int? deliveryTime;
  String? image;
  List<FavOffersModelDataDataUsersOffersAdOn?>? adOn;
  int? isBoosted;
  int? boostTime;
  int? created;
  int? modified;
  List<FavOffersModelDataDataUsersOffersOfferImages?>? offerImages;

  FavOffersModelDataDataUsersOffers({
    this.id,
    this.userId,
    this.name,
    this.price,
    this.description,
    this.totalSold,
    this.deliveryTime,
    this.image,
    this.adOn,
    this.isBoosted,
    this.boostTime,
    this.created,
    this.modified,
    this.offerImages,
  });
  FavOffersModelDataDataUsersOffers.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    userId = json['userId']?.toInt();
    name = json['name']?.toString();
    price = json['price']?.toInt();
    description = json['description']?.toString();
    totalSold = json['totalSold']?.toInt();
    deliveryTime = json['deliveryTime']?.toInt();
    image = json['image']?.toString();
    if (json['adOn'] != null) {
      final v = json['adOn'];
      final arr0 = <FavOffersModelDataDataUsersOffersAdOn>[];
      v.forEach((v) {
        arr0.add(FavOffersModelDataDataUsersOffersAdOn.fromJson(v));
      });
      adOn = arr0;
    }
    isBoosted = json['isBoosted']?.toInt();
    boostTime = json['boostTime']?.toInt();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
    if (json['offerImages'] != null) {
      final v = json['offerImages'];
      final arr0 = <FavOffersModelDataDataUsersOffersOfferImages>[];
      v.forEach((v) {
        arr0.add(FavOffersModelDataDataUsersOffersOfferImages.fromJson(v));
      });
      offerImages = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['totalSold'] = totalSold;
    data['deliveryTime'] = deliveryTime;
    data['image'] = image;
    if (adOn != null) {
      final v = adOn;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['adOn'] = arr0;
    }
    data['isBoosted'] = isBoosted;
    data['boostTime'] = boostTime;
    data['created'] = created;
    data['modified'] = modified;
    if (offerImages != null) {
      final v = offerImages;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['offerImages'] = arr0;
    }
    return data;
  }
}

class FavOffersModelDataData {
/*
{
  "id": 1,
  "userId": 2,
  "offerId": 2,
  "created": 1748696988,
  "modified": 1748696988,
  "rating": "0.0",
  "lowestPrice": 10,
  "usersOffers": {
    "id": 2,
    "userId": 2,
    "name": "Tiles Setup In Room",
    "price": 2000,
    "description": "Setting tiles in a room.",
    "totalSold": 0,
    "deliveryTime": 4,
    "image": "",
    "adOn": [
      {
        "price": "2000",
        "title": "Setting Tiles In Walls of Room",
        "workingDays": "2 Days"
      }
    ],
    "isBoosted": 0,
    "boostTime": 0,
    "created": 1738859997,
    "modified": 1742060161,
    "offerImages": [
      {
        "id": 5,
        "offerId": 2,
        "attachments": "https://app.superinstajobs.com/uploads/1738859997396.106.jpg",
        "created": 1738859997,
        "modified": 1738859997
      }
    ]
  }
}
*/

  int? id;
  int? userId;
  int? offerId;
  int? created;
  int? modified;
  String? rating;
  int? lowestPrice;
  FavOffersModelDataDataUsersOffers? usersOffers;

  FavOffersModelDataData({
    this.id,
    this.userId,
    this.offerId,
    this.created,
    this.modified,
    this.rating,
    this.lowestPrice,
    this.usersOffers,
  });
  FavOffersModelDataData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    userId = json['userId']?.toInt();
    offerId = json['offerId']?.toInt();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
    rating = json['rating']?.toString();
    lowestPrice = json['lowestPrice']?.toInt();
    usersOffers = (json['usersOffers'] != null) ? FavOffersModelDataDataUsersOffers.fromJson(json['usersOffers']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['offerId'] = offerId;
    data['created'] = created;
    data['modified'] = modified;
    data['rating'] = rating;
    data['lowestPrice'] = lowestPrice;
    if (usersOffers != null) {
      data['usersOffers'] = usersOffers!.toJson();
    }
    return data;
  }
}

class FavOffersModelData {
/*
{
  "data": [
    {
      "id": 1,
      "userId": 2,
      "offerId": 2,
      "created": 1748696988,
      "modified": 1748696988,
      "rating": "0.0",
      "lowestPrice": 10,
      "usersOffers": {
        "id": 2,
        "userId": 2,
        "name": "Tiles Setup In Room",
        "price": 2000,
        "description": "Setting tiles in a room.",
        "totalSold": 0,
        "deliveryTime": 4,
        "image": "",
        "adOn": [
          {
            "price": "2000",
            "title": "Setting Tiles In Walls of Room",
            "workingDays": "2 Days"
          }
        ],
        "isBoosted": 0,
        "boostTime": 0,
        "created": 1738859997,
        "modified": 1742060161,
        "offerImages": [
          {
            "id": 5,
            "offerId": 2,
            "attachments": "https://app.superinstajobs.com/uploads/1738859997396.106.jpg",
            "created": 1738859997,
            "modified": 1738859997
          }
        ]
      }
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPage": 1,
    "totalRecord": 1,
    "limit": 10
  }
}
*/

  List<FavOffersModelDataData?>? data;
  FavOffersModelDataPagination? pagination;

  FavOffersModelData({
    this.data,
    this.pagination,
  });
  FavOffersModelData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <FavOffersModelDataData>[];
      v.forEach((v) {
        arr0.add(FavOffersModelDataData.fromJson(v));
      });
      this.data = arr0;
    }
    pagination = (json['pagination'] != null) ? FavOffersModelDataPagination.fromJson(json['pagination']) : null;
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

class FavOffersModel {
/*
{
  "success": true,
  "message": "Fav offer list",
  "status": 200,
  "data": {
    "data": [
      {
        "id": 1,
        "userId": 2,
        "offerId": 2,
        "created": 1748696988,
        "modified": 1748696988,
        "rating": "0.0",
        "lowestPrice": 10,
        "usersOffers": {
          "id": 2,
          "userId": 2,
          "name": "Tiles Setup In Room",
          "price": 2000,
          "description": "Setting tiles in a room.",
          "totalSold": 0,
          "deliveryTime": 4,
          "image": "",
          "adOn": [
            {
              "price": "2000",
              "title": "Setting Tiles In Walls of Room",
              "workingDays": "2 Days"
            }
          ],
          "isBoosted": 0,
          "boostTime": 0,
          "created": 1738859997,
          "modified": 1742060161,
          "offerImages": [
            {
              "id": 5,
              "offerId": 2,
              "attachments": "https://app.superinstajobs.com/uploads/1738859997396.106.jpg",
              "created": 1738859997,
              "modified": 1738859997
            }
          ]
        }
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPage": 1,
      "totalRecord": 1,
      "limit": 10
    }
  }
}
*/

  bool? success;
  String? message;
  int? status;
  FavOffersModelData? data;

  FavOffersModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });
  FavOffersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data = (json['data'] != null) ? FavOffersModelData.fromJson(json['data']) : null;
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
