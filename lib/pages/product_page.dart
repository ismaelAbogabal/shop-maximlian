import 'package:flutter/material.dart';
import 'package:programme/main.dart';
import 'package:programme/utils/data.dart';
import 'package:programme/utils/item.dart';
import 'package:programme/widgets/fab.dart';
import 'package:programme/widgets/spinner.dart';

import 'product_edit.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Item item;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    int i = ModalRoute.of(context).settings.arguments;
    if (i == null) Navigator.pop(context);
    item = item ?? products[i];

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text(item.name),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                      item.isLoved ? Icons.favorite : Icons.favorite_border),
                  onPressed: _love,
                ),
              ],
            ),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Hero(
                  tag: "image$i",
                  child: Image.asset("images/food.jpg"),
                ),
                _div(),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                ),
                _div(),
                Text("${item.description} | \$${item.price}",
                    textAlign: TextAlign.center),
                _div(),
                if (item.creatorId == mId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).errorColor),
                        onPressed: () => alertDeletingProduct(context),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: Theme.of(context).errorColor),
                        onPressed: () => _edit(context),
                      ),
                    ],
                  ),
              ],
            ),
            floatingActionButton: MyFAB(
              loveFunc: _love,
              item: item,
            ),
          ),
          if (isLoading) MySpinner(),
        ],
      ),
    );
  }

  Widget _div({double height = 10, double width = 10}) =>
      SizedBox(height: height, width: width);

  void alertDeletingProduct(BuildContext context) {
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
                // pop the alert and the page
                Navigator.pop(context);
                Navigator.pop(context);
                _delete(item);
                // todo remove this item from the internet
              },
            ),
          ],
        ).build);
  }

  void _edit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(body: EditProductPage(product: item)),
      ),
    );
  }

  void _delete(Item i) {
    setState(() {
      isLoading = true;
    });
    deleteProduct(i.id).then(
      (val) {
        setState(() {
          products.remove(i);
        });
      },
    );
  }

  void _love() {
    setState(() {
      isLoading = true;
    });
    item.changeLoveState().then((v) => setState(() {
          isLoading = false;
        }));
  }
}
