import 'package:currency_converter/models/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:scaledownbutton/scaledownbutton.dart';

class KeyboardButton extends StatefulWidget {
  final Widget child;
  final Function ontap;

  const KeyboardButton({Key key, this.child, this.ontap}) : super(key: key);

  @override
  _KeyboardButtonState createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<KeyboardButton> {

  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    return ScaleDownButton(
      scale: 0.1,
      child: Container(
        child: Material(
          child: InkWell(
            onTap: () {
              if(widget.ontap!=null) {
                widget.ontap();
              }
            },
            child: Container(
            alignment: Alignment.center,
            child: widget.child,
            width: AppSizes.wUnit * 33.3,
            height: AppSizes.hUnit * 12.5,
            ),
          ),
          color: Colors.transparent,
        ),
        color: Colors.white,
      ),
    );
  }
}
