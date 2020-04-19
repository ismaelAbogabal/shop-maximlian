import 'package:flutter/material.dart';

import 'package:programme/main.dart';

import 'package:programme/pages/product_edit.dart';
import 'package:programme/utils/data.dart';
import 'package:programme/utils/item.dart';
import 'package:programme/widgets/spinner.dart';

class MyProductsListPage extends StatefulWidget {
  @override
  _MyProductsListPageState createState() => _MyProductsListPageState();
}

class _MyProductsListPageState extends State<MyProductsListPage> {
  List<Item> items;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items = getMyProducts();
    return _buildProductsList();
  }

  Widget _buildProductsList() {
    return Stack(
      children: <Widget>[
        items.isEmpty
            ? Center(
                child: Text("no Products yet ! please add some"),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) => _buildProductItem(ctx, i),
              ),
        isLoading ? MySpinner() : Text(""),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Image.asset("images/food.jpg"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                items[index].name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Oswald",
                ),
              ),
              VerticalDivider(
                width: 20,
              ),
              Chip(
                label: Text(
                  "\$ ${items[index].price.toString()}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Theme.of(context).accentColor,
                shadowColor: Colors.green,
              ),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  items[index].isLoved ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => _love(items[index]),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  alertDeletingProduct(context, index);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  _editProduct(context, items[index]);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

//  void _openProductPage(BuildContext context, int index) {
//    Navigator.pushNamed(
//      context,
//      "/product",
//      arguments: products.indexOf(items[index]),
//    );
//  }

  void _deleteProduct(BuildContext context, int index) {
    setState(() {
      isLoading = true;
    });
    deleteProduct(items[index].id).then((val) {
      setState(() {
        isLoading = false;
        products.remove(items[index]);
      });
    });
  }

  void alertDeletingProduct(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: AlertDialog(
          title: Text("Deleting Product"),
          content: Text("do you shure you want to delete this product"),
          actions: <Widget>[
            FlatButton(
              child: Text("cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.pop(context);
                _deleteProduct(context, index);
              },
            ),
          ],
        ).build);
  }

  void _editProduct(BuildContext context, Item product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(body: EditProductPage(product: product)),
      ),
    ).then((val) => setState(() {}));
  }

  void _love(Item i) {
    setState(() {
      isLoading = true;
    });
    i.changeLoveState().then((s) => setState(() => isLoading = false));
  }
}
