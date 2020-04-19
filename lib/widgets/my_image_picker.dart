import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class MyImagePicker extends StatefulWidget {
  Function(File image) onSubmit;
  MyImagePicker({GlobalKey<MyImagePickerState> mkey, this.onSubmit})
      : super(key: mkey);

  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State<MyImagePicker> {
  File image;
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    if (image == null) {
      return OutlineButton.icon(
        textColor: color,
        borderSide: BorderSide(
          color: color,
        ),
        onPressed: _getImage,
        icon: Icon(Icons.camera_alt),
        label: Text("Pick a Image"),
      );
    } else {
      return Stack(
        children: <Widget>[
          Image.file(image),
          Container(
            alignment: Alignment(1, 0),
            child: IconButton(
              color: color,
              icon: Icon(Icons.edit),
              onPressed: _getImage,
            ),
          )
        ],
      );
    }
  }

  void _getImage() {
    const double padding = 10;
    Color color = Theme.of(context).primaryColorDark;
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Pick Image", style: Theme.of(context).textTheme.title),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: OutlineButton.icon(
                          borderSide: BorderSide(color: color),
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: Icon(Icons.camera_alt),
                          label: Text("Camera"),
                          textColor: color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: OutlineButton.icon(
                          borderSide: BorderSide(color: color),
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: Icon(Icons.image),
                          label: Text("Gallary"),
                          textColor: color,
                        ),
                      ),
                    ),
                  ],
                ),
                if (image != null)
                  FlatButton(
                    child: Text("Delete"),
                    onPressed: () {
                      setState(() {
                        image = null;
                        widget.onSubmit(null);
                        Navigator.of(context);
                      });
                    },
                  ),
              ],
            ),
          );
        });
  }

  void _pickImage(ImageSource source) {
    ImagePicker.pickImage(source: source).then((val) {
      setState(() {
        image = val ?? image;
        if (widget.onSubmit != null) {
          widget.onSubmit(val);
        }
        Navigator.pop(context);
      });
    });
  }
}
