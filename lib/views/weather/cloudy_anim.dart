import 'package:flutter/material.dart';

import 'base_weather_state.dart';
import 'cloudy_paint.dart';

class CloudyAnim extends StatefulWidget {

  CloudyAnim({Key key}) : super(key: key);

  @override
  _CloudyAnimState createState() => _CloudyAnimState();
}

class _CloudyAnimState extends BaseAnimState<CloudyAnim> {
  AnimationController controller;
  Animation<double> animationX;
  Animation<double> animationY;

  List<Cloud> cloudy = List();

  _CloudyAnimState();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      cloudy.add(Cloud(0, 0));
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3750),
    )
      ..addListener(() {
        _render();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    animationX = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animationX = Tween<double>(begin: -8, end: 8).animate(animationX);

    animationY = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animationY = Tween<double>(begin: -8, end: 8).animate(animationY);

    animationX.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  _render() {
    setState(() {
      cloudy.forEach((cloud) {
        cloud.dx = animationX.value;
        cloud.dy = animationY.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: CloudyPainter(cloudy, maskAlpha),
      ),
      decoration: BoxDecoration(color: Color(0xFF4B97D1)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
