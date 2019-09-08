import 'dart:ui';
import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({
    Key key,
    @required this.text,
    @required this.onPressed,
    @required this.enabled,
    @required this.selected,
    this.selectedColor = Colors.white,
    this.enabledColor = Colors.white70,
    this.disabledColor = Colors.white30
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool enabled;
  final bool selected;
  final Color selectedColor;
  final Color enabledColor;
  final Color disabledColor;

  @override
  MenuItemState createState() {
    return new MenuItemState();
  }
}

class MenuItemState extends State<MenuItem> {

  Color textColor;

  @override
  Widget build(BuildContext context) {
    textColor = widget.enabledColor;
    if(widget.selected)
      textColor = widget.selectedColor;
    
    if(!widget.enabled)
      textColor = widget.disabledColor;

    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: FlatButton(
        splashColor: Colors.transparent,
        onPressed: widget.enabled?widget.onPressed:null,
        child: RichText(
          text: TextSpan(
            text: widget.text,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontStyle: FontStyle.normal,
              color: textColor,
              fontSize: 28.0,
            ),
          ),
        ),
      ),
    );
  }
}