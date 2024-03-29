import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  // const AdaptiveFlatButton({Key key}) : super(key: key);

  final String _text;
  final Function _handler;

  AdaptiveFlatButton(this._text, this._handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              _text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _handler,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              _text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _handler,
          );
  }
}
