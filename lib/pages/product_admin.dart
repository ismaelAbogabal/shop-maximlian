import 'package:flutter/material.dart';
import 'package:programme/pages/product_edit.dart';
import 'package:programme/pages/my_products_list.dart';
import 'package:programme/widgets/drwaer.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("All Products"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Create Product",
                icon: Icon(Icons.edit),
              ),
              Tab(
                text: "My Products",
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[EditProductPage(), MyProductsListPage()],
        ),
      ),
    );
  }
}
