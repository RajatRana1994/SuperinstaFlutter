///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class PortfilioModelDataPagination {
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

  PortfilioModelDataPagination({
    this.currentPage,
    this.totalPage,
    this.totalRecord,
    this.limit,
  });
  PortfilioModelDataPagination.fromJson(Map<String, dynamic> json) {
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

class PortfilioModelDataData {
/*
{
  "id": 3,
  "userId": 2,
  "title": "Build Apps",
  "description": "I  builds of multiple categories to",
  "image": "https://app.superinstajobs.com/uploads/1739964948628.7424.jpg",
  "status": 1,
  "type": 0,
  "created": 1739964949,
  "modified": 1739964949
}
*/

  int? id;
  int? userId;
  String? title;
  String? description;
  String? image;
  int? status;
  int? type;
  int? created;
  int? modified;

  PortfilioModelDataData({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.image,
    this.status,
    this.type,
    this.created,
    this.modified,
  });
  PortfilioModelDataData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    userId = json['userId']?.toInt();
    title = json['title']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    status = json['status']?.toInt();
    type = json['type']?.toInt();
    created = json['created']?.toInt();
    modified = json['modified']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['status'] = status;
    data['type'] = type;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}

class PortfilioModelData {
/*
{
  "data": [
    {
      "id": 3,
      "userId": 2,
      "title": "Build Apps",
      "description": "I  builds of multiple categories to",
      "image": "https://app.superinstajobs.com/uploads/1739964948628.7424.jpg",
      "status": 1,
      "type": 0,
      "created": 1739964949,
      "modified": 1739964949
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

  List<PortfilioModelDataData?>? data;
  PortfilioModelDataPagination? pagination;

  PortfilioModelData({
    this.data,
    this.pagination,
  });
  PortfilioModelData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <PortfilioModelDataData>[];
      v.forEach((v) {
        arr0.add(PortfilioModelDataData.fromJson(v));
      });
      this.data = arr0;
    }
    pagination = (json['pagination'] != null) ? PortfilioModelDataPagination.fromJson(json['pagination']) : null;
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

class PortfilioModel {
/*
{
  "success": true,
  "message": "Portfolios",
  "status": 200,
  "data": {
    "data": [
      {
        "id": 3,
        "userId": 2,
        "title": "Build Apps",
        "description": "I  builds of multiple categories to",
        "image": "https://app.superinstajobs.com/uploads/1739964948628.7424.jpg",
        "status": 1,
        "type": 0,
        "created": 1739964949,
        "modified": 1739964949
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
  PortfilioModelData? data;

  PortfilioModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });
  PortfilioModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data = (json['data'] != null) ? PortfilioModelData.fromJson(json['data']) : null;
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
