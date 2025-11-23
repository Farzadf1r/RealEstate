import 'dart:math';

import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/FutureWidget.dart';
import 'package:realestate_app/customWidget/general/PercentageWidget.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/pages/animation/animatedLoadScreen.dart';

import 'PageIndicator.dart';

class ImagePager extends StatefulWidget {
  final List<String> urls;
  final BoxFit fit;
  final double borderRadius;
  final double padding;
  ImagePager(this.urls,{this.fit = BoxFit.cover,this.borderRadius=10,this.padding = 0});

  createState() => ImagePagerState();
}

class ImagePagerState extends State<ImagePager> {
  final controller = PageController();
  final randomString = "${Random().nextInt(4294967296)}";
  final PageIndicatorController _pageIndicatorController = new PageIndicatorController(0.0);

  initState() {
    super.initState();
    controller.addListener(_pageChanged);
  }

  dispose() {
    super.dispose();
    controller.removeListener(_pageChanged);
  }

  _pageChanged() {
    _pageIndicatorController.value = controller.page;
  }

  build(context)
  {
    return Stack(
      children: [
        PageView(
            controller: controller,
            physics: BouncingScrollPhysics(),
            children: widget.urls
                .map<Widget>((url) => Padding(
              padding:  EdgeInsets.all(widget.padding),
              child: Center(
                child: FutureWidget(
                touchInterceptorLoadingWrapperOnTopOfWidget: wrapItInAnimatedLoadingWidgetOnTopWhichInterceptsTouch,
                  future: FutureValue(
                      computation: () =>
                          ServerGateway.instance().loadImage(url),
                      key: "$randomString-$url"),
                  builder: (c, file) => PercentageWidget(
                    child: Image.file(
                      file,
                      fit: widget.fit,
                    ),
                  ),
                ),
              ),
            ))
                .toList()),
        Align(
          alignment: Alignment(0, 0.9),
          child: PageIndicator(widget.urls.length,_pageIndicatorController),
        )
      ],
    );
  }

}
