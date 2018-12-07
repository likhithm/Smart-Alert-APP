import 'package:flutter/material.dart';

class BoomerangCurve extends Curve {

  final Curve child;
  final double boomBack;
  final double overshoot;

  BoomerangCurve({
    this.child: Curves.linear,
    this.boomBack: 0.5,
    this.overshoot: 1.0
  });

  @override
  double transform(double t) {
    if (t < boomBack) {
      double value = t / boomBack;
      return 1 + overshoot * child.transform(value);
    } else {
      double value = 1 - (t - boomBack) / (1 - boomBack);
      return 1 + overshoot * child.transform(value);
    }
  }
}