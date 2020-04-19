import 'package:flutter/material.dart';

class MySpinner extends StatelessWidget {
  const MySpinner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      color: Theme.of(context).primaryColor.withOpacity(.3),
      child: Container(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(
          strokeWidth: 10,
        ),
      ),
    );
  }
}
