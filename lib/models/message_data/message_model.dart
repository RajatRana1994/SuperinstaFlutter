class MessageModel {
  bool? success;
  String? message;
  int? status;
  MessageDataModel? data;

  MessageModel({this.success, this.message, this.status, this.data});

  MessageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data =
        json['data'] != null ? MessageDataModel.fromJson(json['data']) : null;
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

class MessageDataModel {
  List<MessageMainModel>? data;

  MessageDataModel({this.data});

  MessageDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<MessageMainModel>.from(
        json['data'].map((x) => MessageMainModel.fromJson(x)),
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

class MessageMainModel {
  int? id;
  int? senderId;
  int? receiverId;
  int? threadId;
  int? jobId;
  String? message;
  int? messageType;
  int? bookingId;
  int? modified;
  int? created;
  int? friendId;
  String? profile;
  String? name;
  String? email;

  MessageMainModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.threadId,
    this.jobId,
    this.message,
    this.messageType,
    this.bookingId,
    this.modified,
    this.created,
    this.friendId,
    this.profile,
    this.name,
    this.email
  });

  MessageMainModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    threadId = json['threadId'];
    jobId = json['jobId'];
    message = json['message'];
    messageType = json['messageType'];
    bookingId = json['bookingId'];
    modified = json['modified'];
    created = json['created'];
    friendId = json['friendId'];
    profile = json['profile'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['threadId'] = threadId;
    map['jobId'] = jobId;
    map['message'] = message;
    map['messageType'] = messageType;
    map['bookingId'] = bookingId;
    map['modified'] = modified;
    map['created'] = created;
    map['friendId'] = friendId;
    map['profile'] = profile;
    map['name'] = name;
    map['email'] = email;
    return map;
  }
}
