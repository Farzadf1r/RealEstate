

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';


class PageIndicatorController extends ValueNotifier
{
  PageIndicatorController(value) : super(value);

}

class PageIndicator extends StatefulWidget
{
  final int length;
  final PageIndicatorController controller;

  PageIndicator(this.length,this.controller);

  createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator>
{
  void initState() {
    widget.controller.addListener(_valueChanged);
    super.initState();
  }

  _valueChanged()
  {
    setState(() {});
  }

  void didUpdateWidget(oldWidget) {
    oldWidget.controller.removeListener(_valueChanged);
    widget.controller.addListener(_valueChanged);
    super.didUpdateWidget(oldWidget);
  }

  build(context) => _createIndicator();

  _createIndicator() {
    var size = percentageOfDeviceWidth(context, 0.7) / (widget.length);
    var maxSize = 3.0;
    size = min(size, maxSize);
    var width = size * widget.length * 1.5;

    return Container(
      width: width,
      height: maxSize*2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<int>.generate(widget.length, (index) => index).map<Widget>((index) {

          var extraSize = 0.0;

          var distanceToCurPosition = index - widget.controller.value;
          if (distanceToCurPosition < 0)
            distanceToCurPosition = -distanceToCurPosition;

          if (distanceToCurPosition > 1)
            extraSize = 0;
          else
            extraSize = (1 - distanceToCurPosition) * size * 0.8;

          return Container(
            width: size + extraSize,
            height: size + extraSize,
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }



}