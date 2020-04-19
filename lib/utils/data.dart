import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:programme/main.dart';
import 'package:programme/utils/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'item.dart';
import 'response.dart';

export './user.dart';

const String dataBase = "https://shop-2e058.firebaseio.com";

Future<List<Item>> getProducts() async {
  http.Response val =
      await http.get("https://shop-2e058.firebaseio.com/products.json");

  List<Item> items = [];
  if (val.body == null) {
    return items;
  }
  (Map<String, Map>.from(json.decode(val.body)))
      .forEach((String key, Map data) {
    Item i = Item.fromMap(data);
    i.id = key;

    if (data["lovers"] != null && data["lovers"][mId] == true)
      i.isLoved = true;
    else
      i.isLoved = false;
    items.add(i);
  });
  return items;
}

List<Item> getMyProducts() {
  return products.where((Item i) {
    return i.creatorId == mId;
  }).toList();
}

Future<http.Response> addProduct(Item p) {
  return http.post(
    "https://shop-2e058.firebaseio.com/products.json",
    body: json.encode(p.toMap),
  );
}

Future<http.Response> editProduct(Item p) async {
  http.Response val =
      await http.get("https://shop-2e058.firebaseio.com/products/${p.id}.json");

  final Map dData = Map<String, dynamic>.from(json.decode(val.body));
  final Map uData = p.toMap;
  uData["lovers"] = dData["lovers"];
  return http.put(
    "https://shop-2e058.firebaseio.com/products/${p.id}.json",
    body: json.encode(uData),
  );
}

Future<http.Response> setLoveState(String id, bool love) {
  if (love) {
    return http.put(
      "https://shop-2e058.firebaseio.com/products/$id/lovers.json",
      body: jsonEncode({
        mId: true,
      }),
    );
  } else {
    return http.delete(
        "https://shop-2e058.firebaseio.com/products/$id/lovers/$mId.json");
  }
}

Future<http.Response> deleteProduct(String id) {
  return http.delete("https://shop-2e058.firebaseio.com/products/$id.json");
}

//Authentication logic

//Future<Map> signUpUser(String email, String password) async {
//  return await http
//      .post(
//    "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCYzZ1_ybZnuow5oB4szbdqM9whQ6S2yU8",
//    body: jsonEncode(
//      {
//        "email": email,
//        "password": password,
//      },
//    ),
//  )
//      .then(
//    (val) {
//      Map data = jsonDecode(val.body);
//      if (data["error"] != null) {
//        return {
//          "error": data["error"]["message"] ?? data["error"],
//          "succes": false,
//          "id": null,
//        };
//      }
//      mId = data["localId"];
//      return {
//        "error": null,
//        "succes": true,
//        "id": data["localId"],
//      };
//    },
//  ).catchError((err) {
//    return {
//      "succes": false,
//      "error": "error connecting the interner",
//    };
//  });
//}

//a = {
//  "success" : true ,
//  "id":id
//  "error": "error"
//}
//Future<Map<String, dynamic>> signInUser(String email, String password) async {
//  return await http
//      .post(
//    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCYzZ1_ybZnuow5oB4szbdqM9whQ6S2yU8",
//    body: jsonEncode(
//      {
//        "email": email,
//        "password": password,
//      },
//    ),
//  )
//      .catchError(
//    (err) {
//      return {
//        "succes": false,
//        "error": err.toString(),
//        "id": null,
//      };
//    },
//  ).then(
//    (val) {
//      Map data = jsonDecode(val.body);
//      if (data["error"] != null) {
//        return {
//          "succes": false,
//          "error": data["error"]["message"],
//          "id": null,
//        };
//      }
//      mId = data["localId"];
//      return {
//        "succes": true,
//        "error": null,
//        "id": data["localId"],
//      };
//    },
//  );
//}

Future<MyResponse> authenticate(
    String mail, String password, bool login) async {
  http.Response response;

  if (login) {
    response = await http
        .post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCYzZ1_ybZnuow5oB4szbdqM9whQ6S2yU8",
      body: jsonEncode(
        {
          "email": mail,
          "password": password,
        },
      ),
    )
        .catchError(
      (err) {
        return http.Response(
          jsonEncode({
            "error": {"code": 400, "message": "NO Internet Connection"}
          }),
          400,
        );
      },
    );
  } else {
    response = await http
        .post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCYzZ1_ybZnuow5oB4szbdqM9whQ6S2yU8",
      body: jsonEncode(
        {
          "email": mail,
          "password": password,
        },
      ),
    )
        .catchError(
      (err) {
        return http.Response(
          jsonEncode({
            "error": {"code": 400, "message": "NO Internet Connection"}
          }),
          400,
        );
      },
    );
  }

  Map data = jsonDecode(response.body);
  mId = data["localId"];
  mMail = data["email"];
  mToken = data["idToken"];

  SharedPreferences.getInstance().then((pref) {
    pref.setString("token", mToken);
    pref.setString("id", mId);
    pref.setString("mail", mMail);
  });

  return MyResponse(
      success: data["registered"] ?? true,
      error: data["error"] != null ? data["error"]["message"] : null);
}
