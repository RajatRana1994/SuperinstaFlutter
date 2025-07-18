///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class AddPortfolioModelData {
/*
{
  "description": "222",
  "title": "This is my  new",
  "type": 0,
  "image": "undefined/uploads/1748688965632.3198.png",
  "id": 5
}
*/

  String? description;
  String? title;
  int? type;
  String? image;
  int? id;

  AddPortfolioModelData({
    this.description,
    this.title,
    this.type,
    this.image,
    this.id,
  });
  AddPortfolioModelData.fromJson(Map<String, dynamic> json) {
    description = json['description']?.toString();
    title = json['title']?.toString();
    type = json['type']?.toInt();
    image = json['image']?.toString();
    id = json['id']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['description'] = description;
    data['title'] = title;
    data['type'] = type;
    data['image'] = image;
    data['id'] = id;
    return data;
  }
}

class AddPortfolioModel {
/*
{
  "success": true,
  "message": "Portfolio added successfully",
  "status": 201,
  "data": {
    "description": "222",
    "title": "This is my  new",
    "type": 0,
    "image": "undefined/uploads/1748688965632.3198.png",
    "id": 5
  }
}
*/

  bool? success;
  String? message;
  int? status;
  AddPortfolioModelData? data;

  AddPortfolioModel({
    this.success,
    this.message,
    this.status,
    this.data,
  });
  AddPortfolioModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    status = json['status']?.toInt();
    data = (json['data'] != null) ? AddPortfolioModelData.fromJson(json['data']) : null;
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
