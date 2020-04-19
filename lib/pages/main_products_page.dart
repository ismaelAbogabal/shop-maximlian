import 'package:flutter/material.dart';
import 'package:programme/main.dart';

import 'package:programme/utils/data.dart' as data;
import 'package:programme/utils/item.dart';
import 'package:programme/widgets/drwaer.dart';
import 'package:programme/widgets/spinner.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool gettingData = true;

  // when true display my lovely products
  bool loveMode = false;

  @override
  void initState() {
    updateProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(loveMode ? "loved product" : "Pro duct"),
        actions: <Widget>[
          IconButton(
            icon: Icon(loveMode ? Icons.favorite : Icons.favorite_border),
            onPressed: () => setState(() => loveMode = !loveMode),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            child: _buildProductsList(),
            onRefresh: () async => await data
                .getProducts()
                .then((val) => setState(() => products = val)),
          ),
          if (gettingData) MySpinner(),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    List<Item> items;

    if (loveMode) {
      items = products.where((val) => val.isLoved).toList();
    } else {
      items = products;
    }

    return items.isEmpty
        ? Center(
            child: Text("no Products yet ! please add some"),
          )
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) => _buildProductItem(ctx, i),
          );
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Hero(
            tag: "image$index",
            child: FadeInImage(
              image: NetworkImage(products[index].imageUrl),
              fit: BoxFit.cover,
              height: 300,
              placeholder: AssetImage("images/placeholderImage.png"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                products[index].name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Oswald",
                ),
              ),
              VerticalDivider(
                width: 20,
              ),
//              Text("\$${products[index].price.toString()}"),
              Chip(
                label: Text(
                  "\$ ${products[index].price.toString()}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
//                backgroundColor: ,
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
                  Icons.info,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => _openProductPage(index),
              ),
              IconButton(
                icon: Icon(
                  products[index].isLoved
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => _love(products[index]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openProductPage(int index) {
    Navigator.pushNamed(
      context,
      "/product",
      arguments: index,
    );
  }

  void updateProducts() {
    if (!gettingData)
      setState(() {
        gettingData = true;
      });

    data.getProducts().then((List<Item> a) {
      setState(() {
        gettingData = false;
        products = a;
      });
    }).catchError((err) {
      setState(() {
        gettingData = false;
      });
    });
  }

  void _love(Item item) {
    setState(() {
      gettingData = true;
    });
    item.changeLoveState().then((v) => setState(() {
          gettingData = false;
        }));
  }
}
