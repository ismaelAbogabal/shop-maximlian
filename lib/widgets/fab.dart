import 'dart:math';

import "package:flutter/material.dart";
import 'package:programme/utils/item.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFAB extends StatefulWidget {
  final Function loveFunc;
  final Item item;

  MyFAB({this.loveFunc, this.item});

  @override
  _MyFABState createState() => _MyFABState();
}

class _MyFABState extends State<MyFAB> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double padding = 5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.up,
      children: <Widget>[
        AnimatedBuilder(
          animation: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1, curve: Curves.easeOut),
          ),
          builder: (ctx, child) {
            return Transform.rotate(
              child: Container(
                padding: EdgeInsets.all(padding),
                child: FloatingActionButton(
                  mini: false,
                  heroTag: "details",
                  onPressed: () {
                    _switchState();
                  },
                  child: Icon(
                      _controller.value > .5 ? Icons.close : Icons.more_vert),
                ),
              ),
              angle: _controller.value * pi / 2,
            );
          },
        ),
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, .8, curve: Curves.easeOut),
          ),
          child: Container(
            padding: EdgeInsets.all(padding),
            child: FloatingActionButton(
              mini: true,
              heroTag: "favorite",
              onPressed: () {
                setState(() {
                  widget.loveFunc();
                });
              },
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              child: Icon(
                  widget.item.isLoved ? Icons.favorite : Icons.favorite_border),
            ),
          ),
        ),
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.2, 1, curve: Curves.easeOut),
          ),
          child: Container(
            padding: EdgeInsets.all(padding),
            child: FloatingActionButton(
              mini: true,
              heroTag: "mail",
              onPressed: _mailHim,
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.mail),
            ),
          ),
        ),
      ],
    );
  }

  void _mailHim() async {
    final uri = "mailto:${widget.item.creatorMail}";
    if (await canLaunch(uri)) {
      launch(uri);
    }
  }

  void _switchState() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
}
