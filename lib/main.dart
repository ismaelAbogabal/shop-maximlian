import 'dart:io';

import 'package:flutter/material.dart';
import 'package:programme/pages/product_admin.dart';
import 'package:programme/pages/main_products_page.dart';
import 'package:programme/pages/product_page.dart';
import 'package:programme/utils/cutom_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth.dart';
import 'utils/item.dart';

void main() => runApp(MyApp());

List<Item> products = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getSavedUser();
    return MaterialApp(
      title: "EasyList",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        buttonColor: Colors.purpleAccent,
        accentColor: Colors.purpleAccent,
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: "Oswald",
          ),
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: (setting) {
        print("generationg route");
        if (setting.name == "/product") {
          return MyFadeRoute(
            builder: (ctx) => ProductPage(),
            settings: setting,
          );
        }
        return null;
      },
      routes: {
        "/": (ctx) => AuthPage(),
        "/products": (ctx) => ProductsPage(),
        "/admin": (ctx) => ProductsAdminPage(),
      },
    );
  }

  void getSavedUser() async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    String id = pref.getString("id");
    String mail = pref.getString("mail");

    if (token == null) return;
  }
}
