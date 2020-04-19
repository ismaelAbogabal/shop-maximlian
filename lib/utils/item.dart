import 'package:http/http.dart';

import 'data.dart' as data;

class Item {
  String id, name, description, creatorId, location, imageUrl, creatorMail;
  double price;

  bool isLoved;

  Item({
    this.id,
    this.name,
    this.price,
    this.description,
    this.creatorId,
    this.location,
    this.imageUrl,
    this.isLoved = false,
    this.creatorMail,
  });

//    example of data from the map
//    {
//      "id" : id,
//    "name": name,
//    "description": description,
//    "price": price,
//    "creatorID": creatorId,
//    "location": location,
//    "isLoved" : isLoved,
//    }
  Item.fromMap(Map data) {
    this.id = data["id"];
    this.name = data["name"];
    this.description = data["description"];
    this.price = data["price"];
    this.creatorId = data["creatorId"];
    this.isLoved = data["isLoved"];
    this.imageUrl = data["imageUrl"];
    this.location = data["location"];
    this.creatorMail = data["creatorMail"];
  }

  Map<String, Object> get toMap {
    return {
//      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "creatorId": creatorId,
      "location": location,
      "imageUrl": imageUrl,
      "creatorMail": creatorMail,
    };
  }

  Future<Response> changeLoveState() {
    isLoved = !isLoved;
    return data.setLoveState(id, isLoved);
  }

  @override
  String toString() {
    return toMap.toString();
  }
}
