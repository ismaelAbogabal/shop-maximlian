import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:programme/main.dart';
import 'package:programme/utils/data.dart';
import 'package:programme/utils/item.dart';
import 'package:programme/widgets/my_image_picker.dart';

class EditProductPage extends StatefulWidget {
  final Item product;

  EditProductPage({this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _cName = TextEditingController();
  final _cDesc = TextEditingController();
  final _cPrice = TextEditingController();
  final _fDesc = FocusNode();
  final _fPrice = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<MyImagePickerState> _pickerKey = GlobalKey();

  File image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.product != null) {
      _cName.text = widget.product.name;
      _cPrice.text = widget.product.price.toString();
      _cDesc.text = widget.product.description;
    }
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _cName,
              autofocus: true,
              onFieldSubmitted: (s) => _fPrice.requestFocus(),
              decoration: InputDecoration(
                labelText: "name",
              ),
              validator: (String val) =>
                  val.isEmpty ? "Name is requierd" : null,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _cPrice,
              focusNode: _fPrice,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (s) => _fDesc.requestFocus(),
              decoration: InputDecoration(
                labelText: "price",
              ),
              validator: (String val) {
                try {
                  double.parse(val);
                  return null;
                } catch (e) {
                  return "enter a valid number";
                }
              },
            ),
            // description more than 10 character
            TextFormField(
              controller: _cDesc,
              focusNode: _fDesc,
              maxLines: 4,
              buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) {
                return isFocused
                    ? Text(
                        "$currentLength / 10",
                        style: TextStyle(
                          color: currentLength >= 10
                              ? Theme.of(context).accentColor
                              : Theme.of(context).errorColor,
                        ),
                      )
                    : null;
              },
              decoration: InputDecoration(
                labelText: "description",
              ),
              validator: (String val) => val.length >= 10
                  ? null
                  : "description must have more than 10 characters",
            ),
            MyImagePicker(
              mkey: _pickerKey,
              onSubmit: (val) {
                this.image = val;
              },
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  onPressed: () => _cancel(context),
                  child: Text("Cancel"),
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: () => proceed(context),
                        clipBehavior: Clip.antiAlias,
                        child: Text(widget.product == null
                            ? "Add Product"
                            : "Modify Product"),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _add(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;
//    if (image == null) return;
    double price = double.tryParse(_cPrice.text);
    setState(() {
      isLoading = true;
    });
    //todo
//    String path = await _uploadImage();

//    uploadImage(image);
    Item newItem = Item(
      name: _cName.text.trim(),
      description: _cDesc.text.trim(),
      price: price,
      creatorId: mId,
      creatorMail: mMail,
      imageUrl:
          "https://i.ndtvimg.com/i/2016-03/salad-625-new_625x350_51457095799.jpg",
    );
    newItem.creatorId = mId;
    addProduct(newItem).then((a) {
      setState(() {
        newItem.id = jsonDecode(a.body)["name"];
        products.add(newItem);
        isLoading = false;
        _cDesc.text = "";
        _cName.text = "";
        _cPrice.text = "";
        _pickerKey.currentState.image = null;
      });
    }).catchError((err) {
      print("error sending data to the internet");
      setState(() {
        isLoading = false;
      });
    });
  }

  void _edit(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });
    double price = double.tryParse(_cPrice.text);
    widget.product.name = _cName.text;
    widget.product.price = price;
    widget.product.description = _cDesc.text;
    editProduct(widget.product).then(
      (val) {
        isLoading = false;
        Navigator.pop(context);
      },
    );
  }

  void proceed(BuildContext context) {
    if (widget.product == null) {
      _add(context);
    } else {
      _edit(context);
    }
  }

  void _cancel(BuildContext context) {
    if (widget.product == null) {
      Navigator.pushReplacementNamed(context, "/products");
    } else {
      Navigator.pop(context);
    }
  }
}
