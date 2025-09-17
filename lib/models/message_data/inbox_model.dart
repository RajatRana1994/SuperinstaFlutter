
class InboxModel {
  bool? success;
  String? message;
  int? status;
  InboxDataModel? data;

  InboxModel({this.success, this.message, this.status, this.data});

  InboxModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data = json['data'] != null ? InboxDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class InboxDataModel {
  List<InboxLastMessageModel>? data;

  InboxDataModel({this.data});

  InboxDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<InboxLastMessageModel>.from(
        json['data'].map((x) => InboxLastMessageModel.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((x) => x.toJson()).toList();
    }
    return map;
  }
}

class InboxLastMessageModel {
  int? id;
  String? name;
  String? message;
  int? modified;
  int? friendId;
  int? userId;
  String? profile;
  int? offerId;
  int? bookingId;
  UserOfferModel? usersOffers;
  UserBookingModel? bookings;
  UserBookingModel? jobs;

  InboxLastMessageModel({this.id, this.name, this.message, this.modified, this.bookingId, this.profile, this.offerId,  this.friendId, this.usersOffers, this.bookings, this.userId, this.jobs});

  InboxLastMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    message = json['message'];
    modified = json['modified'];
    profile = json['profile'];
    userId = json['userId'];
    offerId = json['offerId'];
    bookingId = json['bookingId'];
    friendId = json['friendId'];
    if (json['usersOffers'] != null && json['usersOffers'] is Map<String, dynamic>) {
      usersOffers = UserOfferModel.fromJson(json['usersOffers']);
    } else {
      usersOffers = null; // in case it's int, string, or null
    }

    if (json['bookings'] != null && json['bookings'] is Map<String, dynamic>) {
      bookings = UserBookingModel.fromJson(json['bookings']);
    } else {
      bookings = null; // in case it's int, string, or null
    }

    if (json['jobs'] != null && json['jobs'] is Map<String, dynamic>) {
      jobs = UserBookingModel.fromJson(json['jobs']);
    } else {
      jobs = null; // in case it's int, string, or null
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['message'] = message;
    map['modified'] = modified;
    map['profile'] = profile;
    map['friendId'] = friendId;
    map['offerId'] = offerId;
    map['bookingId'] = bookingId;
    map['userId'] = userId;
    if (usersOffers != null) {
      map['usersOffers'] = usersOffers;
    }

    if (bookings != null) {
      map['bookings'] = bookings;
    }

    if (jobs != null) {
      map['jobs'] = jobs;
    }
    return map;
  }
}

class UserOfferModel {
  int? userId;
  int? id;

  UserOfferModel({this.userId, this.id});

  UserOfferModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['id'] = id;
    return map;
  }
}

class UserBookingModel {
  int? userId;
  int? id;

  UserBookingModel({this.userId, this.id});

  UserBookingModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['id'] = id;
    return map;
  }
}