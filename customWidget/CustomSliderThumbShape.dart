import 'package:flutter/material.dart';

class CustomSliderThumbShape extends RangeSliderThumbShape {
  Paint _paint = Paint();

  CustomSliderThumbShape() {}

  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(20, 20);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      bool isEnabled,
      bool isOnTop,
      TextDirection textDirection,
      SliderThemeData sliderTheme,
      Thumb thumb,
      bool isPressed}) {

    final Canvas canvas = context.canvas;

    _paint.color = Color(0xff498ed5);
    canvas.drawCircle(center,13,_paint);
    _paint.color = Colors.white;
    canvas.drawCircle(center,10,_paint);
  }
}

class CustomTrackShape extends RoundedRectRangeSliderTrackShape {
  Rect getPreferredRect({
    //@required
    RenderBox parentBox,
    Offset offset = Offset.zero,
    //@required
    SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = 13;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width-26;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
